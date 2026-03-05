//chatscreen
import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prove_me_wrong/core/data/hive_functions.dart';
import 'package:prove_me_wrong/core/data/message_adapter.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/chat_bubble.dart';
import 'package:prove_me_wrong/widgets/rate_card.dart';

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
  late final String roomId = widget.rooms.roomId;

  late final userDb = FirebaseDatabase.instance.ref(
    "users/${currentUser!.uid}",
  );

  final userID = FirebaseAuth
      .instance
      .currentUser!
      .uid; //ownerID yaparsam sadece room sahibi mesaj atabilir, o yüzden direkt uygulamayı açan kişinin idsini alıyorum
  late bool isOwner = userID == widget.rooms.ownerId ? true : false;

  Box<ChatMessage>? _chatMessagesBox;
  bool _isInitialized = false;
  StreamSubscription? firebaseSub;

  @override
  void initState() {
    super.initState();
    _initRoom();
    final notifyName = isOwner
        ? "ownerNotificationCount"
        : "guestNotificationCount";
    FirebaseDatabase.instance
        .ref("rooms/$roomId/$notifyName")
        .onDisconnect()
        .set(0);
  }

  Future<void> _initRoom() async {
    try {
      print('🟢 [_initRoom] Starting initialization for roomId: $roomId');

      // Uses imported functions from hive_functions.dart (removed duplicates)
      final metadataBox = await getRoomData();
      print('🟢 [_initRoom] Got metadata box');

      RoomMetadata? metadata = metadataBox.get(roomId);
      if (metadata == null) {
        print('🟡 [_initRoom] No metadata found, creating new');
        metadata = RoomMetadata(roomId: roomId, lastSyncTimeStamp: 0);
        await metadataBox.put(roomId, metadata);
      } else {
        print(
          '🟢 [_initRoom] Found existing metadata: lastSync=${metadata.lastSyncTimeStamp}',
        );
      }

      print('🟢 [_initRoom] Starting syncNewData...');
      await syncNewData(roomId, metadata.lastSyncTimeStamp);
      print('🟢 [_initRoom] syncNewData complete');

      final roomBox = await getRoom(roomId);
      print('🟢 [_initRoom] Got room box with ${roomBox.length} messages');

      firebaseSub = _listenToNewMessages(roomId, metadata.lastSyncTimeStamp)
          .listen((_) {
            // Yeni mesaj geldiğinde ValueListenableBuilder otomatik güncellenecek
          });
      print('🟢 [_initRoom] Firebase listener started');

      if (mounted) {
        setState(() {
          _chatMessagesBox = roomBox;
          _isInitialized = true;
        });
        print('🟢 [_initRoom] Initialization complete!');
      }
    } catch (e, stackTrace) {
      print('🔴 [_initRoom] ERROR: $e');
      print('🔴 [_initRoom] Stack: $stackTrace');
      // Still set initialized to true to avoid infinite loading
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }

    // Anlık olarak odada misafir yok ama kullanıcı chat ekranındayken
    // Misafir katılabilir bunun için guestID yi dinlememiz lazım
    if (widget.rooms.guestId == "") {
      FirebaseDatabase.instance
          .ref("rooms/$roomId/guestID")
          .onValue
          .where((event) => event.snapshot.exists)
          .first
          .then((value) {
            if (!mounted) return;
            print("${value.snapshot.value} katıldı");
            setState(() {
              widget.rooms.guestId = value.snapshot.value as String;
            });
          });
    }

    FirebaseDatabase.instance
        .ref("rooms/$roomId/isClosed")
        .onValue
        .where((event) => event.snapshot.exists)
        .first
        .then((value) {
          if (!mounted) return;
          isRoomClosed = (value.snapshot.value as bool?) ?? false;
          setState(() {});
        });
  }

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    firebaseSub?.cancel();
    final notifyName = isOwner
        ? "ownerNotificationCount"
        : "guestNotificationCount";
    FirebaseDatabase.instance.ref("rooms/$roomId/$notifyName").set(0);
    closeRoom(roomId);
    super.dispose();
  }

  String get otherUserId => widget.rooms.ownerId == userID
      ? widget.rooms.guestId
      : widget.rooms.ownerId;

  //  Puan verme işlemi tamamlanmadıysa FALSE döndürüyor
  //  TRUE döndüremez. İşlem tamamlandığında rooms_screen
  //  Bu widgetı ağactan siliyor.
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
          LinkedHashMap data;
          if (mutableData == null) {
            data = {"total": 0, "count": 0, "score": 0} as LinkedHashMap;
          } else {
            data = mutableData as LinkedHashMap;
          }

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

  // ✅ FIX #7: Removed duplicate getRoom(), getRoomData(), syncNewData()

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return; // ✅ Guard against empty messages

    // ✅ FIX #8: Use local timestamp for Hive — `ServerValue.timestamp` is a Map placeholder,
    // NOT an int. Casting it to int crashes at runtime.
    final localTimestamp = DateTime.now().millisecondsSinceEpoch;

    final messageRef = FirebaseDatabase.instance
        .ref("rooms/$roomId/messages")
        .push();

    final room2Save = await getRoom(roomId);
    final message2Save = ChatMessage(
      id: messageRef.key!,
      roomId: roomId,
      senderId: userID,
      message: text,
      timestamp: localTimestamp,
    );

    // ✅ FIX #9: Use message ID as key, NOT roomId.
    // Before: room2Save.put(roomId, message2Save) — overwrote the same key every time!
    await room2Save.put(messageRef.key!, message2Save);

    // Firebase'e yükleniyor — server resolves the timestamp
    await messageRef.set({
      "message": text,
      "timeStamp": ServerValue.timestamp,
      "senderId": userID,
    });

    final notifyName = isOwner
        ? "guestNotificationCount"
        : "ownerNotificationCount";
    FirebaseDatabase.instance
        .ref("rooms/$roomId/$notifyName")
        .set(ServerValue.increment(1));
    final roomBox = await getRoomData();
    final roomData = roomBox.get(roomId);

    if (roomData != null) {
      roomData.lastSyncTimeStamp = localTimestamp;
      roomData.messageCount = room2Save.length;
      await roomData.save();
    }

    messageController.clear();
  }

  // ✅ FIX #10: Field name consistency — was `timestamp` (lowercase), but Firebase uses `timeStamp`
  Stream<ChatMessage> _listenToNewMessages(String roomId, int lastTimestamp) {
    return FirebaseDatabase.instance
        .ref('rooms/$roomId/messages')
        .orderByChild(
          'timeStamp',
        ) // ✅ FIX: was 'timestamp' — doesn't match Firebase field
        .startAt(lastTimestamp + 1)
        .onChildAdded
        .asyncMap((event) async {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final message = ChatMessage(
            id: event.snapshot.key!,
            roomId: roomId,
            senderId: data['senderId'],
            message: data['message'],
            timestamp:
                data['timeStamp'], // ✅ FIX: was 'timestamp' — returned null!
          );
          final roomBox = await getRoom(roomId);

          // ✅ Only save if not already present (own messages are saved in sendMessage)
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
                  content: Text(
                    widget.rooms.guestId.isNotEmpty
                        ? "Session will be over and you can rate your opponent."
                        : "The room will be closed.",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Are you sure? dialogunu kapat
                        if (widget.rooms.guestId.isNotEmpty) {
                          final success = await giveRating();
                          if (!success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Something went wrong when trying to give rating. Please try again.",
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          Map<String, Object?> dbUpdates = {};
                          dbUpdates["users/$userID/roomCount"] =
                              ServerValue.increment(-1);
                          dbUpdates["users/$userID/rooms/$roomId"] = null;
                          dbUpdates["rooms/$roomId/"] = null;
                          try {
                            await FirebaseDatabase.instance.ref().update(
                              dbUpdates,
                            );
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
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
              // ✅ FIX #11: Show loading indicator while async init completes
              child: !_isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : ValueListenableBuilder(
                      valueListenable: _chatMessagesBox!.listenable(),
                      builder: (context, Box<ChatMessage> box, _) {
                        final messages = box.values.toList()
                          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                        if (messages.isEmpty) {
                          return Center(
                            child: Text(
                              widget.rooms.guestId != ''
                                  ? "Start the Conversation"
                                  : "Waiting for Someone to Join",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "SpaceMono",
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.all(12),
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                messages[messages.length - 1 - index];
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
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: AppColors.tertiary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        "\b Warning: \b Room is closed by the other user. You can rate them by leaving the room.",
                        style: TextStyle(
                          fontFamily: "Azer29LT",
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                enabled: !isRoomClosed && (widget.rooms.guestId != ''),
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
              onPressed: !isRoomClosed && (widget.rooms.guestId != '')
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
