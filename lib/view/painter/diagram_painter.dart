import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';

const fretboardWith = 300.0;
const stringGap = 40;
const stringCount = 6;
const fretLength = 50.0;
const markingRadius = fretLength / 4;
const xStart = 50.0;
const yStart = 100.0;

final log = logger('DiagramPainter');

class DiagramPainter extends CustomPainter {
  final linePainter = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  final markingPainter = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill
    ..strokeWidth = 4;

  final FretboardDiagram fretboardDiagram;

  DiagramPainter(this.fretboardDiagram);

  @override
  void paint(Canvas canvas, Size size) {
    log.i('Drawing fretboard diagram $fretboardDiagram');
    _drawStrings(canvas);
    _drawFrets(canvas);
    _drawNoteMarkings(canvas);
  }

  FretPosition? getFretPosition(num x, num y) {
    log.d('Getting fret position of $x, $y');

    for (int string = 0; string < stringCount; string++) {
      for (int fret = 0; fret <= fretboardDiagram.fretboard.fretCount; fret++) {
        final fretPosition = FretPosition(fret: fret, string: string);
        final fretPositionCenter = _getFretPositionCenter(fretPosition);
        final distance = sqrt(pow((x - fretPositionCenter.dx), 2) + pow(y - fretPositionCenter.dy, 2));
        // log.d("Distance for $fretPosition: $distance");
        final match = distance < markingRadius;
        if (match) {
          return fretPosition;
        }
      }
    }

    return null;
  }

  void _drawStrings(Canvas canvas) {
    final length = fretLength * fretboardDiagram.fretboard.fretCount;
    final yEnd = yStart + length;
    for (int i = 0; i < stringCount; i++) {
      final x = xStart + stringGap * i;
      canvas.drawLine(Offset(x, yStart), Offset(x, yEnd), linePainter);
    }
  }

  void _drawFrets(Canvas canvas) {
    const xEnd = xStart + stringGap * (stringCount - 1);
    for (int i = 0; i <= fretboardDiagram.fretboard.fretCount; i++) {
      final y = yStart + fretLength * i;
      canvas.drawLine(Offset(xStart, y), Offset(xEnd, y), linePainter);
    }
  }

  void _drawNoteMarkings(Canvas canvas) {
    fretboardDiagram.markings.forEach((marking) {
      canvas.drawCircle(_getFretPositionCenter(marking.fretPosition), markingRadius, markingPainter);
    });
  }

  Offset _getFretPositionCenter(FretPosition fretPosition) {
    final x = xStart + fretPosition.string * stringGap;
    final y = yStart + fretPosition.fret * fretLength - fretLength / 2;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
