import 'package:fretboard_diagramer/models/fret_position.dart';

class Fretboard {
  final int fretCount;
  final FretPosition? root;
  final Map<FretPosition, int> scaleValues = {};

  Fretboard({required this.fretCount, this.root}) {
    _setScaleValues();
  }

  int? getScaleValue(FretPosition fretPosition) {
    return scaleValues[fretPosition];
  }

  void _setScaleValues() {
    if (this.root == null) {
      return;
    }

    final root = this.root!;
    int scaleValue = 1;
    int string = root.string;
    int fret = root.fret;
    // walk down
    while (string > 0) {
      while (fret >= 0) {
        final position = FretPosition(fret: fret, string: string);
        scaleValues[position] = scaleValue;
        scaleValue = _previousScaleValue(scaleValue);
        fret--;
      }
      string--;
      fret = string == 4 ? 4 : 5;
      scaleValue = _nextScaleValue(scaleValue);
      while (fret < fretCount) {
        fret++;
        scaleValue = _nextScaleValue(scaleValue);
      }
    }

    scaleValue = 1;
    string = root.string;
    fret = root.fret;
    while (string <= 6) {
      while (fret <= fretCount) {
        final position = FretPosition(fret: fret, string: string);
        scaleValues[position] = scaleValue;
        scaleValue = _nextScaleValue(scaleValue);
        fret++;
      }

      final nextStringFret = string == 4 ? 4 : 5;
      while (fret > nextStringFret) {
        fret--;
        scaleValue = _previousScaleValue(scaleValue);
      }

      string++;
      fret = 0;
    }
  }

  int _previousScaleValue(int scaleValue) {
    return (scaleValue == 1) ? 12 : scaleValue - 1;
  }

  int _nextScaleValue(int scaleValue) {
    return (scaleValue == 12) ? 1 : scaleValue + 1;
  }
}
