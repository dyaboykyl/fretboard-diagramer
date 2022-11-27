import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/view/staff/models.dart';
import 'package:fretboard_diagramer/view/staff/positioning.dart';
import 'package:touchable/touchable.dart';

final log = logger('StaffPositioning');

class StaffPainter extends CustomPainter {
  final BuildContext context;
  StaffPainterPositioning positioning;
  final Paint linePaint;
  final Paint notePaint;
  final Paint clefPaint;
  final Paint keySignaturePaint;
  final Paint timeSignaturePaint;
  final Paint boundaryPainter = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.red.shade200;
  late Size size;
  late Canvas canvas;
  late TouchyCanvas touchyCanvas;

  StaffPainter(this.context, this.positioning)
      : linePaint = Paint()..color = Colors.black,
        notePaint = Paint()
          ..color = Colors.black
          ..strokeWidth = positioning.noteStrokeWidth,
        clefPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke,
        keySignaturePaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke,
        timeSignaturePaint = Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    this.canvas = canvas;
    touchyCanvas = TouchyCanvas(context, canvas);
    // _drawStartLine();

    _drawBoundaries();
    _drawHorizontalLines();
    _drawStaffIntro();
    _drawMeasureLines();
    _drawFigure();
    // _drawMelody();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as StaffPainter).positioning != positioning;
  }

  _drawBoundaries() {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), boundaryPainter);
  }

  _drawHorizontalLines() {
    linePaint.strokeWidth = positioning.horizontalLineWidth;
    for (var line in positioning.horizontalLines) {
      canvas.drawLine(line.start, line.end, linePaint);
    }
  }

  _drawStaffIntro() {
    _drawClef();
    _drawKeySignature();
    _drawTimeSignature();
  }

  _drawClef() {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(positioning.clefX, positioning.yMid),
          width: positioning.staffIntroComponentWidth,
          height: positioning.staffHeight * .9),
      clefPaint,
    );
  }

  _drawKeySignature() {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(positioning.keyX, positioning.yMid),
          width: positioning.staffIntroComponentWidth,
          height: positioning.staffHeight * .9),
      keySignaturePaint,
    );
  }

  _drawTimeSignature() {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(positioning.timeSignatureX, positioning.yMid),
          width: positioning.staffIntroComponentWidth,
          height: positioning.staffHeight * .9),
      timeSignaturePaint,
    );
  }

  _drawMeasureLines() {
    linePaint.strokeWidth = positioning.horizontalLineWidth;
    for (var line in positioning.measureLines) {
      canvas.drawLine(line.start, line.end, linePaint);
    }
    linePaint.strokeWidth = positioning.endLineWidth;
    final lastLine = positioning.finalMeasureLine;
    canvas.drawLine(lastLine.start, lastLine.end, linePaint);
  }

  _drawFigure() {
    log.i("Drawing ${positioning.measurePositions}");
    for (var measurePosition in positioning.measurePositions) {
      for (var beamGroup in measurePosition.beamGroups) {
        for (var noteGroup in beamGroup.noteGroupPositions) {
          for (var notePosition in noteGroup.notePositions) {
            _drawNote(notePosition);
          }
        }
      }
    }
  }

  _drawNote(NotePosition notePosition) {
    _drawNoteHead(notePosition.head, PaintingStyle.stroke);
    if (notePosition.headStyle != PaintingStyle.stroke) {
      _drawNoteHead(notePosition.head, notePosition.headStyle);
    }
    _drawStem(notePosition);
  }

  _drawNoteHead(Offset head, PaintingStyle headStyle) {
    notePaint.style = headStyle;
    // final center = Offset(not, store.staffBottom);
    var rect = Rect.fromCenter(center: head, width: positioning.noteSize.width, height: positioning.noteSize.height);
    drawRotated(canvas, head, positioning.noteAngle, () => canvas.drawOval(rect, notePaint));
  }

  _drawStem(NotePosition notePosition) {
    linePaint.strokeWidth = positioning.noteStrokeWidth;
    if (notePosition.stem != null) {
      canvas.drawLine(notePosition.stem!.start, notePosition.stem!.end, linePaint);
    }
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
