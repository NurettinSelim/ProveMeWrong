import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final bool isSender;

  ChatBubblePainter({required this.color, required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isSender) {
      path.moveTo(12, 0);
      path.lineTo(size.width - 12, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 12);
      path.lineTo(size.width, size.height - 12);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 12,
        size.height,
      );

      path.lineTo(size.width - 8, size.height - 3);
      path.lineTo(size.width + 3, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(12, size.height);

      path.quadraticBezierTo(0, size.height, 0, size.height - 12);
      path.lineTo(0, 12);
      path.quadraticBezierTo(0, 0, 12, 0);
    } else {
      path.moveTo(12, 0);
      path.lineTo(size.width - 12, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 12);
      path.lineTo(size.width, size.height - 12);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 12,
        size.height,
      );
      path.lineTo(12, size.height);
      path.lineTo(0, size.height);
      path.lineTo(3, size.height);
      path.lineTo(-8, size.height + 3);

      path.quadraticBezierTo(0, size.height, 0, size.height - 12);
      path.lineTo(0, 12);
      path.quadraticBezierTo(0, 0, 12, 0);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
