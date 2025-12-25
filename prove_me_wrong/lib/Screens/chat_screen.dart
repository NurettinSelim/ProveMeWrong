import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/widgets/chat_bubble.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser;

  late final userDb = FirebaseDatabase.instance.ref(
    "users/${currentUser!.uid}",
  );

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage(String text) async {
    final userID = FirebaseAuth
        .instance
        .currentUser!
        .uid; //ownerID yaparsam sadece room sahibi mesaj atabilir, o yüzden direkt uygulamayı açan kişinin idsini alıyorum
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

  Stream<DatabaseEvent> messageStream() {
    final roomid = widget.rooms.roomId;
    return FirebaseDatabase.instance
        .ref("rooms/$roomid/messages")
        .orderByChild("timeStamp")
        .onValue; //değişiklik olması durumunda
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
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: AppColors.onSecondary),
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
                stream: messageStream(),
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

                  messages.sort(
                    (a, b) => a["timeStamp"].compareTo(b["timeStamp"]),
                  );

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
              onPressed: () {
                final text = messageController.text;
                sendMessage(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
