import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/note_marking.dart';

import 'fretboard.dart';

class FretboardDiagram {
  final String title;
  final Fretboard fretboard;
  final List<NoteMarking> markings;

  FretboardDiagram({required this.fretboard, required this.markings, this.title = ""});

  FretboardDiagram.empty()
      : fretboard = Fretboard(fretCount: 0),
        markings = List.empty(),
        title = "";

  bool hasNoteMarking(FretPosition fretPosition) {
    return markings.any((m) => m.fretPosition == fretPosition);
  }

  bool hasScaleValue(int scaleValue) {
    return markings.any((m) => m.scaleValue == scaleValue);
  }

  FretboardDiagram removeNoteMarking(FretPosition fretPosition) {
    final newMarkings = markings.toList();
    newMarkings.retainWhere((m) => m.fretPosition != fretPosition);
    return FretboardDiagram(fretboard: fretboard, markings: _filterOutNoteMarking(fretPosition));
  }

  FretboardDiagram addNoteMarking(FretPosition fretPosition) {
    final newMarkings = _filterOutNoteMarking(fretPosition);
    newMarkings.add(NoteMarking(fretPosition: fretPosition, scaleValue: fretboard.getScaleValue(fretPosition)));
    return FretboardDiagram(fretboard: fretboard, markings: newMarkings);
  }

  FretboardDiagram toggleRoot(FretPosition? root) {
    final fretboard = Fretboard(
      fretCount: this.fretboard.fretCount,
      root: root,
    );
    final newMarkings = markings
        .map((m) => NoteMarking(
              fretPosition: m.fretPosition,
              scaleValue: fretboard.getScaleValue(m.fretPosition),
            ))
        .toList();
    return FretboardDiagram(title: title, fretboard: fretboard, markings: newMarkings);
  }

  List<NoteMarking> _filterOutNoteMarking(FretPosition fretPosition) {
    final newMarkings = markings.toList();
    newMarkings.retainWhere((m) => m.fretPosition != fretPosition);
    return newMarkings;
  }
}
