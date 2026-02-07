//chatscreen
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  late final String roomId;

  late final userDb = FirebaseDatabase.instance.ref(
    "users/${currentUser!.uid}",
  );

  final userID = FirebaseAuth
      .instance
      .currentUser!
      .uid; //ownerID yaparsam sadece room sahibi mesaj atabilir, o yüzden direkt uygulamayı açan kişinin idsini alıyorum
  late final Stream<DatabaseEvent> messageStream;

  @override
  void initState() {
    super.initState();
    roomId = widget.rooms.roomId;
    messageStream = FirebaseDatabase.instance
        .ref("rooms/$roomId/messages")
        .orderByChild("timeStamp")
        .onValue;
    final room = widget.rooms;
    FirebaseDatabase.instance.ref("rooms/$roomId/isClosed").onValue.listen((
      event,
    ) {
      isRoomClosed = (event.snapshot.value as bool?) ?? false;
      setState(() {});
    });
  }

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
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

  Future<void> sendMessage(String text) async {
    final roomId = widget.rooms.roomId;

    final messageRef = FirebaseDatabase.instance
        .ref("rooms/$roomId/messages")
        .push();

    await messageRef.set({
      "message": text,
      "timeStamp": ServerValue.timestamp,
      "senderId": userID,
    });
    messageController.clear();
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
                        final success = await giveRating();
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
              child: StreamBuilder(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
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

                  final data = snapshot.data!.snapshot.value as Map;
                  final messages = data.values.toList();

                  return ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe =
                          msg["senderId"] ==
                          FirebaseAuth.instance.currentUser!.uid;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ChatBubble(
                          text: msg["message"],
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
