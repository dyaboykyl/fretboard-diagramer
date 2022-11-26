import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/note.dart';

part 'note_group.g.dart';

@dataClass
class NoteGroup {
  final List<Note> notes;
  final int beat;
  final int measure;

  NoteGroup({
    required this.notes,
    required this.measure,
    required this.beat,
  });

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
