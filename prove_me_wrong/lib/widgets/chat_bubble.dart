import 'package:flutter/material.dart ';
import 'package:prove_me_wrong/widgets/bubble_paint.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByMe;
  const ChatBubble({super.key, required this.text, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            CustomPaint(
              painter: ChatBubblePainter(
                color: isSentByMe ? AppColors.tertiary : AppColors.primary,
                isSender: isSentByMe,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 16,
                    fontFamily: "Azer29LT",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
