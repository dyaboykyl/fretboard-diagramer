import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/scale_value.dart';

class NoteMarking {
  final FretPosition fretPosition;
  final ScaleValue scaleValue;

  NoteMarking({required this.fretPosition, this.scaleValue = ScaleValue.none});
}
