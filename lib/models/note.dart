import 'package:data_class_annotation/data_class_annotation.dart';

part 'note.g.dart';

@dataClass
class Note {
  // middle C = 60, 0 = rest
  final int value;
  final double duration;

  Note({required this.value, required this.duration});

  Note.note(int v) : this(value: v, duration: 0);

  Note.rest(double d) : this(value: 0, duration: d);

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
