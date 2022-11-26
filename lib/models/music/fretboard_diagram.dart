import 'chord.dart';
import 'fret_position.dart';
import 'fretboard.dart';
import 'note_marking.dart';

class FretboardDiagram {
  final String? titleOverride;
  final Fretboard fretboard;
  final List<NoteMarking> markings;
  Chord get chord => Chord(fretboard.root, markings.map((m) => m.scaleValue).toList());
  String get title => titleOverride ?? chord.title;

  FretboardDiagram({required this.fretboard, required this.markings, this.titleOverride});

  FretboardDiagram.empty()
      : fretboard = Fretboard(fretCount: 0),
        markings = List.empty(),
        titleOverride = null;

  bool hasNoteMarking(FretPosition fretPosition) {
    return markings.any((m) => m.fretPosition == fretPosition);
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
      rootFret: root,
    );
    final newMarkings = markings
        .map((m) => NoteMarking(
              fretPosition: m.fretPosition,
              scaleValue: fretboard.getScaleValue(m.fretPosition),
            ))
        .toList();
    return FretboardDiagram(fretboard: fretboard, markings: newMarkings, titleOverride: titleOverride);
  }

  List<NoteMarking> _filterOutNoteMarking(FretPosition fretPosition) {
    final newMarkings = markings.toList();
    newMarkings.retainWhere((m) => m.fretPosition != fretPosition);
    return newMarkings;
  }
}
