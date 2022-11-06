import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/models/melody.dart';
import 'package:fretboard_diagramer/view/staff/staff_widget_store.dart';
import 'package:touchable/touchable.dart';

class StaffPainter extends CustomPainter {
  final StaffWidgetStore store;
  final BuildContext context;
  final Paint linePaint;
  final Paint notePaint;
  late Size size;
  late Canvas canvas;
  late TouchyCanvas touchyCanvas;

  StaffPainter(this.context, this.store)
      : linePaint = Paint()..color = Colors.black,
        notePaint = Paint()
          ..color = Colors.black
          ..strokeWidth = store.noteStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    this.canvas = canvas;
    touchyCanvas = TouchyCanvas(context, canvas);
    _drawStartLine();
    _drawHorizontalLines();
    _drawMelody();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  _drawStartLine() {
    linePaint.strokeWidth = store.startLineWidth;
    _drawVerticalLine(0);
  }

  _drawHorizontalLines() {
    linePaint.strokeWidth = store.horizontalLineWidth;
    for (var i = 0; i <= store.lineCount; i++) {
      final y = store.staffTop + store.staffHeight * i / store.lineCount;
      final start = Offset(0, y);
      final end = Offset(size.width, y);
      canvas.drawLine(start, end, linePaint);
    }
  }

  _drawMelody() {
    if (store.melody.measures.isEmpty) {
      linePaint.strokeWidth = store.horizontalLineWidth;
      _drawVerticalLine(store.measureLength);
      return;
    }

    int measureCount = 0;
    for (var measure in store.melody.measures) {
      var x = store.firstNoteX + store.measureLength * measureCount;
      for (var component in measure.components) {
        if (component is Note) {
          _drawNote(x, component);
        }
      }
      measureCount++;
      _drawVerticalLine(store.measureLength * measureCount);
    }
  }

  _drawNote(double x, Note note) {
    if (note.duration == 4) {
      // canvas.(pi / 12);
      notePaint.style = PaintingStyle.stroke;
      final center = Offset(x, store.staffBottom);
      var rect = Rect.fromCenter(center: center, width: store.noteSize.width, height: store.noteSize.height);
      drawRotated(canvas, center, -pi / 8, () => canvas.drawOval(rect, notePaint));
      // canvas.rotate(-pi / 12);
    }
  }

  _drawVerticalLine(double x) {
    final start = Offset(x, store.staffBottom + store.horizontalLineWidth / 2);
    final end = Offset(x, store.staffTop - store.horizontalLineWidth / 2);
    canvas.drawLine(start, end, linePaint);
  }

  void drawRotated(
    Canvas canvas,
    Offset center,
    double angle,
    VoidCallback drawFunction,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }
}
