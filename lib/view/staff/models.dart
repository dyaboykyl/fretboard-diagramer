import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/models/note_group.dart';
import 'package:fretboard_diagramer/view/models/vector.dart';

part 'models.g.dart';

enum StemDirection { none, up, down }

@dataClass
class NotePosition {
  final Note note;
  final Offset head;
  Vector? stem;

  NotePosition({required this.note, required this.head, this.stem});

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

// connected by a beam
@dataClass
class BeamGroupPosition {
  final List<NoteGroupPosition> noteGroupPositions;

  BeamGroupPosition(this.noteGroupPositions);

  @override
  String toString() => dataToString();
}

@dataClass
class MeasurePosition {
  final List<BeamGroupPosition> beamGroups;
  final double width;
  final double startX;
  double get endX => width + startX;
  // Vector get line = Vector.vertical(yStart: staffBottom, yEnd: staffTop, x: x);

  MeasurePosition({
    required this.width,
    required this.startX,
    required this.beamGroups,
  });

  @override
  String toString() => dataToString();
}

extension NoteGroupExt on NoteGroup {
  StemDirection get stemDirection {
    if (!notes.any((n) => n.hasStem)) {
      return StemDirection.none;
    }

    final noteHeightSum = notes.map((n) => n.height).sum;
    if (noteHeightSum > 0) {
      return StemDirection.down;
    } else {
      return StemDirection.up;
    }
  }
}

extension NoteExt on Note {
  bool get hasStem => duration < 4 && duration > 0;

  StemDirection get stemDirection {
    if (!hasStem) {
      return StemDirection.none;
    }

    if (height > 0) {
      return StemDirection.down;
    } else {
      return StemDirection.up;
    }
  }
}
