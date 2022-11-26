import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/measure.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/models/note_group.dart';

part 'figure.g.dart';

@dataClass
class Figure {
  final List<Measure> measures;

  Figure({required this.measures});

  static Figure fromNotes(List<Note> notes) {
    final List<Measure> measures = [];

    List<NoteGroup> currentMeasure = [];
    double currentBeat = 1;
    for (var note in notes) {
      currentMeasure.add(NoteGroup(
        notes: [note],
        beat: currentBeat.floor(),
        measure: measures.length,
      ));
      currentBeat += note.duration;
      if (currentBeat > 4) {
        // TODO: Time signature
        currentBeat = 1;
        measures.add(Measure(measureNumber: measures.length, noteGroups: currentMeasure));
        currentMeasure = [];
      }
    }

    return Figure(measures: measures);
  }

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
