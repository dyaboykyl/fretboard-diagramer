import 'dart:math';

import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/figure.dart';
import 'package:fretboard_diagramer/models/measure.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/models/note_group.dart';
import 'package:fretboard_diagramer/view/models/vector.dart';
import 'package:fretboard_diagramer/view/staff/models.dart';

part 'positioning.g.dart';

final log = logger('StaffPositioning');

const maxMeasureWidth = .5;
const minMeasureWidth = .2;
const stemYstartOffset = .985;

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

  late final firstNoteX = noteSize.width * 1.5;
  late final noteAngle = -pi / 10;
  late final noteHeight = staffNoteHeightSpacing * .75;
  late final noteSize = Size(noteHeight * 1.4, noteHeight);
  late final minNoteSpaceWidth = noteSize.width * 2;
  late final minMeasureWidth = firstNoteX + 3 * minNoteSpaceWidth;
  late final stemYstartOffset = .985;

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

    bool first = true;

    log.d("Creating measure position for $measure");
    final beamGroups = measure.noteGroups
        .groupListsBy((noteGroup) {
          if (noteGroup.notes.first.duration > 1) {
            return noteGroup.beat;
          }
          final group = noteGroup.beat.isOdd ? noteGroup.beat : noteGroup.beat - 1; // TODO: odd time signatures
          log.d("---Group for $noteGroup: $group");
          return group;
        })
        .entries
        .sortedBy<num>((element) => element.key)
        // .map((e) => e.value)
        .map((entry) {
          final noteGroups = entry.value;
          log.d("--BeamGroup $entry");
          // figure out stem direction, start, and end
          final totalNotes = noteGroups.map((g) => g.notes).flattened.where((element) => element.hasStem);
          final averageHeight = totalNotes.isEmpty ? 0 : totalNotes.map((e) => e.height).average;
          final stemDirection = averageHeight > 0 ? StemDirection.down : StemDirection.up;
          final changesDirection = groupChangesDirection(noteGroups);

          final stems = totalNotes.map((e) => getStemVector(note: e, stemDirection: stemDirection));
          final farthestY = stems.isEmpty
              ? 0
              : stems
                  .reduce((maxStem, stem) => (stemDirection == StemDirection.down
                          ? stem.end.dy > maxStem.end.dy
                          : stem.end.dy < maxStem.end.dy)
                      ? stem
                      : maxStem)
                  .end
                  .dy;

          final noteGroupPositions = noteGroups.mapIndexed((stepNumber, noteGroup) {
            final notePositions = noteGroup.notes.map((note) {
              final minX = first ? noteX : measureStartX + firstNoteX + (noteGroup.beat - 1) * minNoteSpaceWidth;
              first = false;
              if (noteX < minX) {
                noteX = minX;
              }
              final head = Offset(noteX, getNoteY(note));
              noteX += minNoteSpaceWidth;

              // TODO: time signature
              Vector? stem;
              if (note.hasStem) {
                final stemMultiplier = stemDirection == StemDirection.down ? 1 : -1;
                final stemX = head.dx - (noteSize.width / 2 * stemMultiplier) + (noteStrokeWidth / 10 * stemMultiplier);
                stem = getStemVector(note: note, stemDirection: stemDirection, x: stemX);
                if (stem.end.dy.compareTo(farthestY) != 0 && changesDirection) {
                  stem = Vector.vertical(yStart: stem.start.dy, yEnd: farthestY.toDouble(), x: stem.start.dx);
                }
              }

              // TODO: beams/flags

              return NotePosition(note: note, head: head, stem: stem);
            }).toList();

            return NoteGroupPosition(notePositions);
          }).toList();
          return BeamGroupPosition(noteGroupPositions);
        })
        .toList();
    final width = max(minMeasureWidth, noteX - measureStartX); //- minNoteSpaceWidth / 2;
    return MeasurePosition(width: width, startX: measureStartX, beamGroups: beamGroups);
  }

  bool groupChangesDirection(List<NoteGroup> noteGroups) {
    if (noteGroups.length > 2) {
      int? direction;
      for (int i = 0; i < noteGroups.length - 1; i++) {
        final note = noteGroups[i].notes.first; // TODO: multiple notes in noteGroup
        final nextNote = noteGroups[i + 1].notes.first;
        if (nextNote.height != note.height) {
          int nextDirection = nextNote.height - note.height;
          nextDirection = nextDirection == 0 ? nextDirection : nextDirection ~/ nextDirection.abs();
          if (nextDirection == 0) {
            continue;
          }

          if (direction == null) {
            direction = nextDirection;
          } else {
            if (nextDirection != direction) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Vector getStemVector({required Note note, required StemDirection stemDirection, double x = 0}) {
    final headY = getNoteY(note);
    final stemMultiplier = stemDirection == StemDirection.down ? 1 : -1;
    final yStart = headY * (stemDirection == StemDirection.up ? stemYstartOffset : (1 / stemYstartOffset));
    final yEnd = yStart + (staffHeight * .75 * stemMultiplier);
    return Vector.vertical(yStart: yStart, yEnd: yEnd, x: x);
  }

  // Style
  late final horizontalLineWidth = .025 * staffHeight;
  late final endLineWidth = 4 * horizontalLineWidth;
  late final noteStrokeWidth = horizontalLineWidth * 1.5;
}
