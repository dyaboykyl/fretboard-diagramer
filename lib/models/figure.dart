import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/figure_step.dart';
import 'package:fretboard_diagramer/models/measure.dart';
import 'package:fretboard_diagramer/models/note.dart';

part 'figure.g.dart';

@dataClass
class Figure {
  final List<Measure> measures;

  Figure({required this.measures});

  static Figure fromNotes(List<Note> notes) {
    final List<Measure> measures = [];

    List<FigureStep> currentMeasure = [];
    double currentBeat = 1;
    for (var note in notes) {
      currentMeasure.add(FigureStep(notes: [note]));
      currentBeat += note.duration;
      if (currentBeat > 4) {
        // TODO: Time signature
        currentBeat = 1;
        measures.add(Measure(steps: currentMeasure));
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
