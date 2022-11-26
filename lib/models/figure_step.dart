import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/note.dart';

part 'figure_step.g.dart';

@dataClass
class FigureStep {
  final List<Note> notes;

  FigureStep({required this.notes});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
