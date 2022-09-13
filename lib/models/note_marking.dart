import 'package:fretboard_diagramer/models/fret_position.dart';

class NoteMarking {
  final FretPosition fretPosition;
  final int? scaleValue;

  NoteMarking({required this.fretPosition, this.scaleValue});

  String? getScaleValue() {
    const scaleValueMap = {
      1: 'R',
      2: 'b2',
      3: '2',
      4: 'b3',
      5: '3',
      6: '4',
      7: 'b5',
      8: '5',
      9: 'b6',
      10: '6',
      11: 'b7',
      12: '7',
    };
    return scaleValueMap[scaleValue];
  }
}
