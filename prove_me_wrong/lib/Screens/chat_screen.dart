import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.room});

  final Room room;

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
                  room.title,
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontFamily: "SpaceMono",
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "${room.ownerScore} | ${room.language.name} | ${room.category.name}",
                  style: TextStyle(
                    fontFamily: "Azer29LT",
                    fontSize: 12,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_back, color: AppColors.onSecondary),
          ],
        ),
        backgroundColor: AppColors.primaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(12),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "Hello! Welcome to the chat.",
                      isSentByMe: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "Thank you! Glad to be here.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "I'm thinking you are wrong.",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      text: "What do you think?",
                      isSentByMe: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChatBubble(
                      text: "No, I believe I'm right.",
                      isSentByMe: false,
                    ),
                  ),
                ],
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
