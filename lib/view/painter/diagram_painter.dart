import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';

const fretboardWith = 300.0;
const stringGap = 40;
const stringCount = 6;
const fretLength = 50.0;
const xStart = 50.0;
const yStart = 100.0;

final log = logger('DiagramPainter');

class DiagramPainter extends CustomPainter {
  final painter = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  final FretboardDiagram fretboardDiagram;

  DiagramPainter(this.fretboardDiagram);

  @override
  void paint(Canvas canvas, Size size) {
    if (fretboardDiagram == null) {
      log.w('Attempted to draw a diagram with a null fretboard diagram');
      return;
    }

    log.i('Drawing fretboard diagram $fretboardDiagram');
    _drawStrings(canvas);
    _drawFrets(canvas);
  }

  void _drawStrings(Canvas canvas) {
    final length = fretLength * fretboardDiagram.fretboard.fretCount;
    final yEnd = yStart + length;
    for (int i = 0; i < stringCount; i++) {
      final x = xStart + stringGap * i;
      canvas.drawLine(Offset(x, yStart), Offset(x, yEnd), painter);
    }
  }

  void _drawFrets(Canvas canvas) {
    const xEnd = xStart + stringGap * (stringCount - 1);
    for (int i = 0; i <= fretboardDiagram.fretboard.fretCount; i++) {
      final y = yStart + fretLength * i;
      canvas.drawLine(Offset(xStart, y), Offset(xEnd, y), painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
