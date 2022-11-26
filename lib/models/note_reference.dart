import 'package:data_class_annotation/data_class_annotation.dart';

part 'note_reference.g.dart';

@dataClass
class NoteReference {
  // middle C = 60, 0 = rest
  final int bar;
  final int step;
  final int note;

  NoteReference({required this.bar, required this.step, required this.note});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
