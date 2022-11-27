import 'dart:math';

import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/figure.dart';
import 'package:fretboard_diagramer/models/measure.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/view/models/vector.dart';
import 'package:fretboard_diagramer/view/staff/models.dart';

part 'positioning.g.dart';

final log = logger('StaffPositioning');

const maxMeasureWidth = .5;
const minMeasureWidth = .2;

@dataClass
class StaffPainterPositioning {
  final Size size;
  final Figure figure;
  final lineCount = 5.0;

  StaffPainterPositioning({required this.size, required this.figure});

  @override
  String toString() => dataToString();

  late final yMid = size.height / 2;
  late final staffHeight = size.height / 2;
  late final staffTop = yMid - staffHeight / 2;
  late final staffBottom = staffTop + staffHeight;
  late final staffNoteHeightSpacing = staffHeight / (lineCount - 1);

  late final actualStaffMeasuresWidth = measurePositions.map((m) => m.width).sum;
  late final staffIntroWidth = staffHeight * 2;
  late final staffWidth = staffIntroWidth + actualStaffMeasuresWidth;

  late final staffStart = 0.0; // TODO: position staff in center
  late final staffEnd = staffWidth + staffStart;

  late final staffIntroComponentWidth = staffIntroWidth / 3;
  late final staffIntroWidthMid = staffIntroWidth / 2 + staffStart;

  late final clefX = staffIntroComponentWidth / 2 + staffStart;
  late final keyX = clefX + staffIntroComponentWidth;
  late final timeSignatureX = keyX + staffIntroComponentWidth;

  late final firstMeasureStartX = staffStart + staffIntroWidth;
  late final measureLines = measurePositions.map(
    (e) => Vector.vertical(yStart: staffBottom, yEnd: staffTop, x: e.endX),
  );
  late final finalMeasureLine = Vector.vertical(
    yStart: staffTop - (horizontalLineWidth / 2),
    yEnd: staffBottom + (horizontalLineWidth / 2),
    x: measureLines.last.start.dx,
  );

  late final firstNoteX = noteSize.width;
  late final noteAngle = -pi / 10;
  // late final availableMeasureSpace = measureWidth - firstNoteX * 2;
  late final noteHeight = staffNoteHeightSpacing * .85;
  late final noteSize = Size(noteHeight * 1.5, noteHeight);
  // late final minGroupWidth = availableMeasureSpace / 4; // TODO: time signature
  late final minNoteSpaceWidth = noteSize.width * 1.25;

  late final horizontalLines = List.generate(
    lineCount.toInt(),
    (line) => Vector.horizontal(xStart: staffStart, xEnd: staffEnd, y: staffTop + (line * staffNoteHeightSpacing)),
  );
  late final measurePositions = createMeasurePositions();

  double getNoteY(Note note) {
    return yMid - (note.value - Note.middleStaffNote) * staffNoteHeightSpacing / 2;
  }

  List<MeasurePosition> createMeasurePositions() {
    log.d("Creating positions for ${figure.measures}");
    List<MeasurePosition> measurePositions = [];

    figure.measures.forEachIndexed((index, measure) {
      measurePositions.add(createMeasurePosition(measure, index == 0 ? null : measurePositions[index - 1]));
    });

    return measurePositions;
  }

  MeasurePosition createMeasurePosition(Measure measure, MeasurePosition? previous) {
    double measureStartX = previous == null ? firstMeasureStartX : previous.endX;
    double noteX = measureStartX + firstNoteX;

    final List<NoteGroupPosition> groupPositions = measure.noteGroups.mapIndexed((stepNumber, step) {
      // double groupWidth = min(minGroupWidth, group.notes.length * minNoteSpaceWidth);

      final notePositions = step.notes.map((note) {
        final minX = stepNumber == 0 ? noteX : measureStartX + firstNoteX + (step.beat - 1) * noteSize.width * 1.5;
        if (noteX < minX) {
          noteX = minX;
        }
        final head = Offset(noteX, getNoteY(note));
        noteX += minNoteSpaceWidth;

        // TODO: time signature
        Vector? stem;
        final stemDirection = step.stemDirection;
        if (stemDirection != StemDirection.none) {
          final stemMultiplier = step.stemDirection == StemDirection.down ? 1 : -1;
          const yOffset = .985;
          final yStart = stemDirection == StemDirection.up ? head.dy * yOffset : head.dy / yOffset;
          stem = Vector.vertical(
            yStart: yStart,
            yEnd: yStart + (staffHeight * .75 * stemMultiplier),
            x: head.dx - (noteSize.width / 2 * stemMultiplier) + (noteStrokeWidth / 4 * stemMultiplier),
          );
        }

        // TODO: beams/flags

        return NotePosition(note: note, head: head, stem: stem);
      }).toList();

      return NoteGroupPosition(notePositions);
      // noteGroup.notePositions.add(value)
    }).toList();

    final width = noteX - measureStartX + minNoteSpaceWidth;
    return MeasurePosition(width: width, startX: measureStartX, groupPositions: groupPositions);
  }

  // Style
  late final horizontalLineWidth = .025 * staffHeight;
  late final endLineWidth = 4 * horizontalLineWidth;
  late final noteStrokeWidth = horizontalLineWidth * 1.5;
}
