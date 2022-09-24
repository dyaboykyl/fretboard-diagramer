import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/scale_value.dart';

class Fretboard {
  final int fretCount;
  final FretPosition? rootFret;
  final Map<FretPosition, ScaleValue> scaleValues = {};
  ScaleValue get root => getScaleValue(rootFret);

  Fretboard({required this.fretCount, this.rootFret}) {
    _setScaleValues();
  }

  ScaleValue getScaleValue(FretPosition? fretPosition) {
    return scaleValues[fretPosition] ?? ScaleValue.none;
  }

  void _setScaleValues() {
    if (rootFret == null) {
      return;
    }

    ScaleValue scaleValue = ScaleValue.tonic;
    int string = rootFret!.string;
    int fret = rootFret!.fret;
    // walk down
    while (string > 0) {
      while (fret >= 0) {
        final position = FretPosition(fret: fret, string: string);
        scaleValues[position] = scaleValue;
        scaleValue--;
        fret--;
      }
      string--;
      fret = string == 4 ? 4 : 5;
      scaleValue++;
      while (fret < fretCount) {
        fret++;
        scaleValue++;
      }
    }

    scaleValue = ScaleValue.tonic;
    string = rootFret!.string;
    fret = rootFret!.fret;
    while (string <= 6) {
      while (fret <= fretCount) {
        final position = FretPosition(fret: fret, string: string);
        scaleValues[position] = scaleValue;
        scaleValue++;
        fret++;
      }

      final nextStringFret = string == 4 ? 4 : 5;
      while (fret > nextStringFret) {
        fret--;
        scaleValue--;
      }

      string++;
      fret = 0;
    }
  }
}
