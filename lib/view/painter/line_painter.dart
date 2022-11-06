import 'package:flutter/material.dart';

// @dataClass
class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Paint painter;

  LinePainter(
    this.start,
    this.end, {
    color = Colors.black,
    width = 0,
    strokeAlign = StrokeAlign.center,
  }) : painter = Paint()
          ..color = color
          ..strokeWidth = width
          // ..strokeJoin = StrokeJoin.
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(start.scale(size.width, size.height), end.scale(size.width, size.height), painter);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return true;
  }
}
