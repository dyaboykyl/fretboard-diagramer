import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/note_group.dart';

part 'measure.g.dart';

@dataClass
class Measure {
  final int measureNumber;
  final List<NoteGroup> noteGroups;

  Measure({required this.measureNumber, required this.noteGroups});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
