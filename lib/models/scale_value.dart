import 'package:fretboard_diagramer/models/chord.dart';

enum ScaleValue {
  none,
  tonic,
  minorSecond,
  second,
  minorThird,
  majorThird,
  fourth,
  tritone,
  fifth,
  minorSixth,
  sixth,
  minorSeventh,
  majorSeventh,
}

extension ScaleValueExtension on ScaleValue {
  ScaleValue operator +(int amount) {
    if (amount == 0) {
      return this;
    }
    if (amount > 0) {
      return next() + (amount - 1);
    } else {
      return this - -amount;
    }
  }

  ScaleValue operator -(int amount) {
    if (amount == 0) {
      return this;
    }
    if (amount > 0) {
      return previous() - (amount - 1);
    } else {
      return this + -amount;
    }
  }

  ScaleValue previous() {
    return ScaleValue.values[(this == ScaleValue.tonic) ? 12 : index - 1];
  }

  ScaleValue next() {
    return ScaleValue.values[(this == ScaleValue.majorSeventh) ? 1 : index + 1];
  }

  String? chordRepresentation(Chord chord) {
    final second = chord.hasSeventh || chord.hasSixth ? '9' : '2';
    final scaleValueMap = {
      ScaleValue.tonic: 'R',
      ScaleValue.minorSecond: 'b$second',
      ScaleValue.second: second,
      ScaleValue.minorThird: chord.dominant ? '#9' : 'b3',
      ScaleValue.majorThird: '3',
      ScaleValue.fourth: chord.hasSeventh ? '11' : '4',
      ScaleValue.tritone: chord.dominant || chord.majorSeventh ? '#11' : 'b5',
      ScaleValue.fifth: '5',
      ScaleValue.minorSixth: chord.dominant ? 'b13' : 'b6',
      ScaleValue.sixth: chord.dominant || chord.minorSeventh ? '13' : '6',
      ScaleValue.minorSeventh: 'b7',
      ScaleValue.majorSeventh: '7',
    };
    return scaleValueMap[this];
  }
}
