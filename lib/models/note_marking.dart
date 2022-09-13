import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';

class NoteMarking {
  final FretPosition fretPosition;
  final int? scaleValue;

  NoteMarking({required this.fretPosition, this.scaleValue});

  String? getScaleValue(FretboardDiagram diagram) {
    final dominant = diagram.hasScaleValue(11) && diagram.hasScaleValue(5);
    final hasSeventh = diagram.hasScaleValue(12) || diagram.hasScaleValue(11);
    final majorSeventh = diagram.hasScaleValue(12);
    final minorSeventh = (diagram.hasScaleValue(11) && diagram.hasScaleValue(4) && !diagram.hasScaleValue(5));
    final hasSixth = diagram.hasScaleValue(10);
    final second = hasSeventh || hasSixth ? '9' : '2';
    final scaleValueMap = {
      1: 'R',
      2: 'b$second',
      3: second,
      4: dominant ? '#9' : 'b3',
      5: '3',
      6: hasSeventh ? '11' : '4',
      7: dominant || majorSeventh ? '#11' : 'b5',
      8: '5',
      9: dominant ? 'b13' : 'b6',
      10: dominant || minorSeventh ? '13' : '6',
      11: 'b7',
      12: '7',
    };
    return scaleValueMap[scaleValue];
  }
}
