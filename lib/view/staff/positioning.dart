import 'dart:math';

import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/figure.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/view/models/vector.dart';

part 'positioning.g.dart';

final log = logger('StaffPositioning');

const maxMeasureWidth = .5;
const minMeasureWidth = .2;

enum StemDirection { none, up, down }

@dataClass
class NoteGroup {
  final List<Note> notes;
  final int beat;
  final int measure;

  NoteGroup({required this.notes, required this.measure, required this.beat});

  StemDirection get stemDirection {
    if (!notes.any((n) => n.duration < 1 && n.duration > 0)) {
      return StemDirection.none;
    }

    final noteHeightSum = notes.map((n) => n.height).sum;
    if (noteHeightSum > 0) {
      return StemDirection.up;
    } else {
      return StemDirection.down;
    }
  }

  @override
  String toString() => dataToString();
}

@dataClass
class NotePosition {
  final Note note;
  final Offset head;
  Vector stem = Vector.horizontal(xStart: 0, xEnd: 0);

  NotePosition({required this.note, required this.head, required Vector stem}) : stem = stem;

  PaintingStyle get headStyle {
    // TODO: time signatures
    if (note.duration > 1) {
      return PaintingStyle.stroke;
    }

    return PaintingStyle.fill;
  }

  @override
  String toString() => dataToString();
}

// connected by a beam
@dataClass
class NoteGroupPosition {
  final List<NotePosition> notePositions;

  NoteGroupPosition(this.notePositions);

  @override
  String toString() => dataToString();
}

@dataClass
class StaffPainterPositioning {
  final Size size;
  final Figure figure;
  final lineCount = 5.0;

  StaffPainterPositioning({required this.size, required this.figure});

  @override
  String toString() => dataToString();

  late final yMid = size.height / 2;
  late final staffHeight = size.height / 3;
  late final staffTop = yMid - staffHeight / 2;
  late final staffBottom = staffTop + staffHeight;
  late final staffNoteHeightSpacing = staffHeight / (lineCount - 1);

  late final measureWidth = staffHeight * 3; // TODO: calculate measure lengths dynamically
  late final staffMeasuresWidth = figure.measures.length * measureWidth;
  late final staffIntroWidth = staffHeight * 1.5;
  late final staffWidth = staffIntroWidth + staffMeasuresWidth;

  late final staffStart = size.width / 2 - staffMeasuresWidth / 2 - staffIntroWidth;
  late final staffEnd = staffWidth + staffStart;

  late final staffIntroComponentWidth = staffIntroWidth / 3;
  late final staffIntroWidthMid = staffIntroWidth / 2 + staffStart;

  late final clefX = staffIntroComponentWidth / 2 + staffStart;
  late final keyX = clefX + staffIntroComponentWidth;
  late final timeSignatureX = keyX + staffIntroComponentWidth;

  late final measureStartX = staffStart + staffIntroWidth;
  late final measureLines = figure.measures.mapIndexed((i, m) {
    final x = measureStartX + measureWidth * (i + 1);
    return Vector.vertical(yStart: staffBottom, yEnd: staffTop, x: x);
  });
  late final finalMeasureLine = Vector.vertical(
    yStart: staffTop - (horizontalLineWidth / 2),
    yEnd: staffBottom + (horizontalLineWidth / 2),
    x: measureLines.last.start.dx,
  );

  late final firstNoteX = noteSize.width;
  late final noteAngle = -pi / 10;
  late final availableMeasureSpace = measureWidth - firstNoteX * 2;
  late final noteHeight = staffNoteHeightSpacing * .85;
  late final noteSize = Size(noteHeight * 1.5, noteHeight);
  late final minGroupWidth = availableMeasureSpace / 4; // TODO: time signature
  late final minNoteSpaceWidth = noteSize.width * 2;

  late final horizontalLines = List.generate(
    lineCount.toInt(),
    (line) => Vector.horizontal(xStart: staffStart, xEnd: staffEnd, y: staffTop + (line * staffNoteHeightSpacing)),
  );
  late final noteGroupPositions = createNoteGroupPositions();

  double getNoteY(Note note) {
    return yMid - (note.value - Note.middleStaffNote) * staffNoteHeightSpacing / 2;
  }

  List<NoteGroupPosition> createNoteGroupPositions() {
    return figure.measures
        .mapIndexed((measureCount, measure) {
          final List<NoteGroup> noteGroups = [];
          int currentBeat = 1;
          for (var step in measure.steps) {
            log.d("Processing measure=$measureCount, currentBeat=$currentBeat");
            if (currentBeat > 4) {
              log.e('More than 4 beats in measure');
            }

            // TODO: handle multiple notes in step
            for (var note in step.notes) {
              // TODO: handle other time signatures
              if (note.duration >= 1) {
                final noteGroup = NoteGroup(notes: [note], measure: measureCount, beat: currentBeat);
                noteGroups.add(noteGroup);
              }
              // TODO: handle cross beat notes
              currentBeat = (currentBeat + note.duration).floor();
              break;
            }
          }
          log.d("Created $noteGroups");

          double noteX = measureStartX + firstNoteX;
          int currentMeasure = 0;
          return noteGroups.map((group) {
            if (group.measure > currentMeasure) {
              currentMeasure = group.measure;
              noteX = measureStartX + firstNoteX + currentMeasure * measureWidth;
            }
            // double groupWidth = min(minGroupWidth, group.notes.length * minNoteSpaceWidth);

            final notePositions = group.notes.map((note) {
              final head = Offset(noteX, getNoteY(note));
              noteX += minNoteSpaceWidth;

              // TODO: time signature
              Vector? stem;
              if (group.stemDirection != StemDirection.none) {
                final stemMultiplier = group.stemDirection == StemDirection.down ? 1 : -1;
                stem = Vector.vertical(yStart: head.dy, yEnd: head.dy + (staffHeight * stemMultiplier));
              }

              // TODO: beams/flags

              return NotePosition(note: note, head: head, stem: stem ?? Vector.zero);
            }).toList();

            return NoteGroupPosition(notePositions);
            // noteGroup.notePositions.add(value)
          });
        })
        .flattened
        .toList();
  }

  // Style
  late final horizontalLineWidth = .02 * staffHeight;
  late final endLineWidth = 4 * horizontalLineWidth;
  late final noteStrokeWidth = horizontalLineWidth;
}
