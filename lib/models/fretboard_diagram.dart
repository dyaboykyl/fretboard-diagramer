import 'package:fretboard_diagramer/models/note_marking.dart';

import 'fretboard.dart';

class FretboardDiagram {
  final Fretboard fretboard;
  final List<NoteMarking> markings;

  FretboardDiagram({required this.fretboard, required this.markings});
}
