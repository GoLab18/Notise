import 'package:flutter/material.dart';

class BottomNavBarPainter extends CustomPainter {
  final Color color;

  BottomNavBarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    final centerWidth = size.width / 2;
    final bumpRadius = 20.0;

    path.moveTo(0, bumpRadius);
    path.lineTo(centerWidth - bumpRadius - 48, bumpRadius);

    path.cubicTo(
      centerWidth - bumpRadius - 24,
      bumpRadius,
      centerWidth - bumpRadius - 12,
      0,
      centerWidth,
      0,
    );

    path.cubicTo(
      centerWidth + bumpRadius + 12,
      0,
      centerWidth + bumpRadius + 24,
      bumpRadius,
      centerWidth + bumpRadius + 48,
      bumpRadius,
    );

    path.lineTo(size.width, bumpRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
