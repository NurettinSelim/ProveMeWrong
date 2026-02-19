//chatscreen
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prove_me_wrong/core/data/message_adapter.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/chat_bubble.dart';
import 'package:prove_me_wrong/widgets/rate_card.dart';
import 'package:prove_me_wrong/core/data/hive_functions.dart';

//rulesda $message .write kısmında: null && root.child('users/' + auth.uid + '/rooms/' + $id).exists() && newData.child('senderId').val() === auth.uid

class ChatScreen extends StatefulWidget {
  final Room rooms;

  const ChatScreen({
    super.key,
    required this.rooms,
  }); // required room = chatscreen başka screende çağırıldığında yazılacak

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isRoomClosed = false;
  final currentUser = FirebaseAuth.instance.currentUser;
  late final String roomId;

  late final userDb = FirebaseDatabase.instance.ref(
    "users/${currentUser!.uid}",
  );

  final userID = FirebaseAuth
      .instance
      .currentUser!
      .uid; //ownerID yaparsam sadece room sahibi mesaj atabilir, o yüzden direkt uygulamayı açan kişinin idsini alıyorum
  late final Stream<DatabaseEvent> messageStream;
  late Box<ChatMessage> chatMessagesBox;
  late Box<RoomMetadata> metadataBox;

  @override
  void initState() {
    super.initState();
    _initializeRoom();
  }

  Future<void> _initializeRoom() async {
    await initializeRoom(roomId);
  }

  Future<void> initializeRoom(String roomId) async {
    final metadataBox = await getRoomData();
    final roomBox = await getRoom(roomId);

    RoomMetadata? metadata = metadataBox.get(roomId);
    if (metadata == null) {
      metadata = RoomMetadata(roomId: roomId, lastSyncTimeStamp: 0);
      await metadataBox.put(roomId, metadata);
    }
    await syncNewData(roomId, metadata.lastSyncTimeStamp);
  }

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
    //hive clean'i buna koymalı mıyım
  }

  String get otherUserId => widget.rooms.ownerId == userID
      ? widget.rooms.guestId
      : widget.rooms.ownerId;

  //  Puan verme işlemi tamamlandıysa TRUE döndürüyor
  Future<bool> giveRating() async {
    final int? rating = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rate Your Opponent", textAlign: TextAlign.center),
          content: RateCard(ratedId: otherUserId),
        );
      },
    );

    if (rating == null) return false;

    final ratingTransaction = await FirebaseDatabase.instance
        .ref("users/$otherUserId/rating")
        .runTransaction((mutableData) {
          print(mutableData.runtimeType);
          var data = mutableData as LinkedHashMap;

          int totalS = (data['total'] as int) + rating;

          int count = (data['count'] as int) + 1;

          double avg = totalS / count;

          data["total"] = totalS;

          data["count"] = count;

          data["score"] = avg;

          data["roomID"] = roomId;

          return Transaction.success(data);
        });

    if (!ratingTransaction.committed) return false;

    Map<String, Object?> dbUpdates = {};
    dbUpdates["users/$userID/roomCount"] = ServerValue.increment(-1);
    dbUpdates["users/$userID/rooms/$roomId"] = null;
    if (isRoomClosed) {
      dbUpdates["rooms/$roomId/"] = null;
    } else {
      dbUpdates["rooms/$roomId/isClosed"] = true;
    }

    try {
      await FirebaseDatabase.instance.ref().update(dbUpdates);
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  //box where messages from roomId is stored
  Future<Box<ChatMessage>> getRoom(String roomId) async {
    if (!Hive.isBoxOpen('room_$roomId')) {
      return await Hive.openBox('room_$roomId');
    } else {
      return Hive.box<ChatMessage>('room_$roomId');
    }
  }

  // the box of rooms
  Future<Box<RoomMetadata>> getRoomData() async {
    if (!Hive.isBoxOpen('room_data')) {
      return await Hive.openBox('room_data');
    } else {
      return Hive.box<RoomMetadata>('room_data');
    }
  }

  //
  Future syncNewData(String roomId, int lastSync) async {
    final snapshot = await FirebaseDatabase.instance
        .ref('rooms/$roomId/messages')
        .orderByChild('timeStamp')
        .startAt(lastSync + 1)
        .get();

    if (snapshot.exists) {
      final currentRoom = await getRoom(roomId);
      final roomBox = await getRoomData();

      final roomData = roomBox.get(roomId);

      final data = snapshot.value as Map<dynamic, dynamic>;
      for (var messageId in data.entries) {
        final entry =
            messageId.value
                as Map<
                  dynamic,
                  dynamic
                >; // messageId'nin içindeki timestmap, senderid, messages map'lendi
        final hiveMessage = ChatMessage(
          id: messageId.key,
          roomId: roomId,
          senderId: entry['senderId'],
          message: entry['message'],
          timestamp: entry['timeStamp'], //serverValue alınıyor
        );

        await currentRoom.put(roomId, hiveMessage);
        if (hiveMessage.timestamp > lastSync) {
          lastSync = hiveMessage.timestamp;
        }
      }

      roomData!.lastSyncTimeStamp = lastSync;
      roomData.messageCount = currentRoom.length;
      await roomData.save();
    }
  }

  Future<void> sendMessage(String text) async {
    final messageTime = ServerValue.timestamp;
    final messageRef = FirebaseDatabase.instance
        .ref("rooms/$roomId/messages")
        .push();

    final room2Save = await getRoom(roomId);
    final message2Save = ChatMessage(
      id: messageRef.key!,
      roomId: roomId,
      senderId: userID,
      message: text,
      timestamp: messageTime as int,
    );
    room2Save.put(roomId, message2Save);

    final roomBox = await getRoomData();
    final roomData = roomBox.get(roomId);

    //firebase'e yükleniyor
    await messageRef.set({
      "message": text,
      "timeStamp": messageTime,
      "senderId": userID,
    });

    roomData?.lastSyncTimeStamp = messageTime as int;
    roomData?.messageCount = roomBox.length;
    await roomData!.save();

    messageController.clear();
  }

  Stream<ChatMessage> listenToNewMessages(String roomId, int lastTimestamp) {
    return FirebaseDatabase.instance
        .ref('rooms/$roomId/messages')
        .orderByChild('timestamp')
        .startAt(lastTimestamp + 1)
        .onChildAdded
        .asyncMap((event) async {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final message = ChatMessage(
            id: event.snapshot.key!,
            roomId: roomId,
            senderId: data['senderId'],
            message: data['message'],
            timestamp: data['timestamp'],
          );
          final roomBox = await getRoom(roomId);

          if (!roomBox.containsKey(event.snapshot.key)) {
            await roomBox.put(message.id, message);
            final metadataBox = await getRoomData();
            final metadata = metadataBox.get(roomId)!;
            metadata.lastSyncTimeStamp = message.timestamp;
            metadata.messageCount = roomBox.length;
            await metadata.save();
          }
          return message;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onSecondary,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.rooms.title,
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontFamily: "SpaceMono",
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "${widget.rooms.ownerScore} | ${widget.rooms.language.name} | ${widget.rooms.category.name}",
                  style: TextStyle(
                    fontFamily: "Azer29LT",
                    fontSize: 16,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
            Spacer(),
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text(
                    "Session will be over and you can rate your opponent.",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Are you sure? dialogunu kapat
                        await giveRating(); //normalde final success = await giveRating() idi ancak kullanılmadığı için SİLDİMMM :)
                      },

                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll<Color>(
                          AppColors.primary,
                        ),
                      ),
                      child: const Text("Flee"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll<Color>(
                          AppColors.onPrimary,
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.primary,
                        ),
                      ),
                      child: const Text("Stay"),
                    ),
                  ],
                ),
              ),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsetsGeometry.all(16),
                ),
                alignment: Alignment.center,
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.onPrimary,
                ),
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    fontFamily: "Azer29LT",
                  ),
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.secondary,
                ),
              ),
              child: Text("Flee From the Fight"),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: chatMessagesBox.listenable(),
                builder: (context, Box<ChatMessage> box, _) {
                  final messages = box.values.toList()
                    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "Start the Conversation",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SpaceMono",
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isMe = message.senderId == userID;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ChatBubble(
                          text: message.message,
                          isSentByMe: isMe,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            isRoomClosed
                ? Text(
                    "Room is closed. You can rate the other user by leaving the room.",
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: AppColors.primaryContainer,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: !isRoomClosed,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Start the Fight...",
                  hintStyle: TextStyle(
                    color: AppColors.onPrimary.withOpacity(0.6),
                    fontFamily: "Azer29LT",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.onPrimary.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontFamily: "Azer29LT",
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: AppColors.onPrimary),
              onPressed: !isRoomClosed
                  ? () {
                      final text = messageController.text;
                      sendMessage(text);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
