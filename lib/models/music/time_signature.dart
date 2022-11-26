import 'package:data_class_annotation/data_class_annotation.dart';

part 'time_signature.g.dart';

@dataClass
class TimeSignature {
  final int notesPerMeasure;
  final int beatsPerNote;

  TimeSignature({required this.notesPerMeasure, required this.beatsPerNote});

  TimeSignature.fourFour() : this(notesPerMeasure: 4, beatsPerNote: 4);

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
