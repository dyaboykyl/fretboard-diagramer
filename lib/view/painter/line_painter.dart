import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  LinePainter(this.start, this.end, {this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawLine(start.scale(size.width, size.height), end.scale(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
