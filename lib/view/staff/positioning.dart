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
const noteAngle = -pi / 10;

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

  late final firstNoteX = noteSize.width * 1.5;
  late final noteHeight = staffNoteHeightSpacing * .75;
  late final noteSize = Size(noteHeight * 1.4, noteHeight);
  late final minNoteSpaceWidth = noteSize.width * 2;
  late final minMeasureWidth = firstNoteX + 3 * minNoteSpaceWidth;

  late final horizontalLines = List.generate(
    lineCount.toInt(),
    (line) => Vector.horizontal(xStart: staffStart, xEnd: staffEnd, y: staffTop + (line * staffNoteHeightSpacing)),
  );

  // measures
  late final measureLines = measurePositions.map(
    (e) => Vector.vertical(yStart: staffBottom, yEnd: staffTop, x: e.endX),
  );
  late final finalMeasureLine = Vector.vertical(
    yStart: staffTop - (horizontalLineWidth / 2),
    yEnd: staffBottom + (horizontalLineWidth / 2),
    x: measureLines.last.start.dx,
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
    final groups = measure.noteGroups
        .groupListsBy((noteGroup) {
          if (noteGroup.notes.first.duration > 1) {
            return noteGroup.beat;
          }
          final group = noteGroup.beat.isOdd ? noteGroup.beat : noteGroup.beat - 1; // TODO: odd time signatures
          // log.d("---Group for $noteGroup: $group");
          return group;
        })
        .entries
        .sortedBy<num>((element) => element.key);
    final List<BeamGroupPosition> beamGroups = [];
    groups.forEachIndexed((index, group) {
      beamGroups.add(createBeamGroup(
        measureStartX: measureStartX,
        noteX: index == 0 ? noteX : beamGroups[index - 1].xEnd,
        groupNumber: group.key,
        noteGroups: group.value,
      ));
    });
    final width = max(minMeasureWidth, beamGroups.last.xEnd - measureStartX); //- minNoteSpaceWidth / 2;
    return MeasurePosition(width: width, startX: measureStartX, beamGroups: beamGroups);
  }

  BeamGroupPosition createBeamGroup({
    required double measureStartX,
    required double noteX,
    required int groupNumber,
    required List<NoteGroup> noteGroups,
  }) {
    // final noteGroups = entry.value;
    log.d("  BeamGroup $groupNumber: $noteGroups");
    // figure out stem direction, start, and end
    final totalNotes = noteGroups.map((g) => g.notes).flattened.where((element) => element.hasStem);
    final averageHeight =
        totalNotes.isEmpty ? 0 : totalNotes.map((e) => pow(e.height - Note.middleStaffNote, 2)).average;
    final stemDirection = averageHeight > 0 ? StemDirection.down : StemDirection.up;
    final changesDirection = groupChangesDirection(noteGroups);

    final stems = totalNotes.map((e) => getStemVector(note: e, stemDirection: stemDirection)).toList();
    final farthestY = stems.isEmpty
        ? 0
        : stems
            .reduce((maxStem, stem) =>
                (stemDirection == StemDirection.down ? stem.end.dy > maxStem.end.dy : stem.end.dy < maxStem.end.dy)
                    ? stem
                    : maxStem)
            .end
            .dy;

    final noteGroupPositions = noteGroups.mapIndexed((stepNumber, noteGroup) {
      log.d("   Processing $stepNumber");
      final notePositions = noteGroup.notes.map((note) {
        log.d("    $note");
        final minX = groupNumber == 1 ? noteX : measureStartX + firstNoteX + (noteGroup.beat - 1) * minNoteSpaceWidth;
        // first = false;
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
          // stem = getStemVector(note: note, stemDirection: stemDirection, x: stemX);
          if (stem.end.dy.compareTo(farthestY) != 0 && changesDirection) {
            // TODO: check if within beam slope
            stem = Vector.vertical(yStart: stem.start.dy, yEnd: farthestY.toDouble(), x: stem.start.dx);
          }
        }

        // TODO: beams/flags

        return NotePosition(note: note, head: head, stem: stem);
      }).toList();

      return NoteGroupPosition(notePositions);
    }).toList();

    // TODO: multiple notes in note group
    final beamStart = noteGroupPositions.first.notePositions.first.stem?.end ?? Offset.zero;
    final beamEnd = noteGroupPositions.last.notePositions.first.stem?.end ?? Offset.zero;
    final stemCorrectedNoteGroupPositions = noteGroupPositions.map((noteGroupPosition) {
      return NoteGroupPosition(noteGroupPosition.notePositions.map((notePosition) {
        if (notePosition.note.hasStem && stems.length > 2) {
          var stem = getStemVectorForBeam(
            note: notePosition.note,
            stemDirection: stemDirection,
            beamStart: beamStart,
            beamEnd: beamEnd,
            x: notePosition.stem?.start.dx ?? 0,
          );

          return notePosition.copyWith(stem: stem);
        }
        return notePosition;
      }).toList());
    }).toList();

    final beam = stems.isEmpty ? Vector.zero : Vector(start: beamStart, end: beamEnd);

    return BeamGroupPosition(stemCorrectedNoteGroupPositions, beam, noteX);
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

  Vector getStemVectorForBeam({
    required Note note,
    required StemDirection stemDirection,
    required Offset beamStart,
    required Offset beamEnd,
    double x = 0,
  }) {
    final originalStem = getStemVector(note: note, stemDirection: stemDirection, x: x);
    final yEnd = pointOnLine(beamStart, beamEnd, x);
    final val = Vector.vertical(yStart: originalStem.start.dy, yEnd: yEnd, x: x);
    if (val != originalStem) {
      log.w("Changing stem: $originalStem -> $val");
    }
    return val;
  }

  // Style
  late final horizontalLineWidth = .025 * staffHeight;
  late final endLineWidth = 4 * horizontalLineWidth;
  late final noteStrokeWidth = horizontalLineWidth * 1.5;
}
