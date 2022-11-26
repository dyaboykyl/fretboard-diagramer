import 'package:data_class_annotation/data_class_annotation.dart';

part 'note.g.dart';

@dataClass
class Note {
  static const int middleStaffNote = 66;
  // middle C = 60, 0 = rest
  final int value;
  final double duration;
  final int height;

  Note({required this.value, required this.duration}) : height = value - middleStaffNote;

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
