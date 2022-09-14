import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';
import 'package:fretboard_diagramer/models/scale_value.dart';

class NoteMarking {
  final FretPosition fretPosition;
  final ScaleValue scaleValue;

  NoteMarking({required this.fretPosition, this.scaleValue = ScaleValue.none});

  String? getScaleValue(FretboardDiagram diagram) {
    final second = diagram.hasSeventh || diagram.hasSixth ? '9' : '2';
    final scaleValueMap = {
      ScaleValue.tonic: 'R',
      ScaleValue.minorSecond: 'b$second',
      ScaleValue.second: second,
      ScaleValue.minorThird: diagram.dominant ? '#9' : 'b3',
      ScaleValue.majorThird: '3',
      ScaleValue.fourth: diagram.hasSeventh ? '11' : '4',
      ScaleValue.tritone: diagram.dominant || diagram.majorSeventh ? '#11' : 'b5',
      ScaleValue.fifth: '5',
      ScaleValue.minorSixth: diagram.dominant ? 'b13' : '#5',
      ScaleValue.sixth: diagram.dominant || diagram.minorSeventh ? '13' : '6',
      ScaleValue.minorSeventh: 'b7',
      ScaleValue.majorSeventh: '7',
    };
    return scaleValueMap[scaleValue];
  }
}
