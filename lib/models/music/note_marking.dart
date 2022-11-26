import 'fret_position.dart';
import 'scale_value.dart';

class NoteMarking {
  final FretPosition fretPosition;
  final ScaleValue scaleValue;

  NoteMarking({required this.fretPosition, this.scaleValue = ScaleValue.none});
}
