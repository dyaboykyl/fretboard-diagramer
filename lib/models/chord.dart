import 'package:fretboard_diagramer/models/scale_value.dart';

class Chord {
  final ScaleValue root;
  final List<ScaleValue> notes;

  Chord(this.root, this.notes);

  bool get major => hasScaleValue(ScaleValue.majorThird);
  bool get minor => hasScaleValue(ScaleValue.minorThird) && !major;
  bool get dominant => hasScaleValue(ScaleValue.minorSeventh) && major;
  bool get majorSeventh => hasScaleValue(ScaleValue.majorSeventh);
  bool get minorSeventh => hasScaleValue(ScaleValue.minorSeventh);
  bool get hasSeventh => majorSeventh || minorSeventh;
  bool get hasExtension => hasScaleValues([ScaleValue.minorSecond, ScaleValue.second, ScaleValue.fourth]);
  bool get hasSixth => hasScaleValue(ScaleValue.sixth);
  bool get dimished => hasExactScaleValues([ScaleValue.tonic, ScaleValue.minorThird, ScaleValue.tritone, ScaleValue.sixth]);
  bool get augmented => hasExactScaleValues([ScaleValue.tonic, ScaleValue.majorThird, ScaleValue.minorSixth]);

  bool hasScaleValue(ScaleValue scaleValue) {
    return notes.any((n) => n == scaleValue);
  }

  bool hasScaleValues(List<ScaleValue> scaleValues) {
    return scaleValues.every((s) => notes.any((n) => n == s));
  }

  bool hasExactScaleValues(List<ScaleValue> scaleValues) {
    if (!hasScaleValues(scaleValues)) {
      return false;
    }

    final copy = notes.toList();
    copy.removeWhere((n) => scaleValues.contains(n));
    return copy.isEmpty;
  }

  String get title {
    if (root == ScaleValue.none) {
      return "";
    }

    // overrides
    // dim, aug, half dim, min maj 7
    if (dimished) {
      return "dim";
    }

    if (augmented) {
      return "aug";
    }

    String tonality = "";
    if (major && !dominant) {
      tonality = "maj";
    } else if (minor) {
      tonality = "min";
    }
    if (hasSeventh) {
      tonality += "7";
    } else if (hasSixth) {
      tonality += "6";
    }
    String flatNine = hasScaleValue(ScaleValue.minorSecond) ? "b9" : "";
    String nine = hasScaleValue(ScaleValue.second) ? "9" : "";
    String sharpNine = hasScaleValue(ScaleValue.minorThird) && major ? "#9" : "";
    String eleven = hasScaleValue(ScaleValue.fourth) ? "11" : "";
    String sharpEleven = hasScaleValue(ScaleValue.tritone) ? "#11" : "";
    String flatFive = "";
    if (sharpEleven != "" && eleven != "") {
      sharpEleven = "";
      flatFive = "b5";
    }
    String flatThirteen = hasScaleValue(ScaleValue.minorSixth) ? "b13" : "";
    String thirteen = hasScaleValue(ScaleValue.sixth) ? "13" : "";
    String sharpFive = "";
    if (flatThirteen != "" && thirteen != "") {
      flatThirteen = "";
      sharpFive = "#5";
    }
    List<String> extensionList = [];

    if (dominant || (minor && minorSeventh) || (major && majorSeventh)) {
      extensionList = [flatNine, nine, sharpNine, eleven, sharpEleven, flatFive, sharpFive, flatThirteen, thirteen];
    } else if (hasSixth) {
      extensionList = [flatNine, nine, sharpNine, eleven, sharpEleven, flatFive, sharpFive];
    }
    extensionList.removeWhere((e) => e == "");

    if (!hasSeventh && !hasSixth) {
      return tonality;
    }

    return "$tonality ${extensionList.join(",")}";

    // return "unknown";
  }
}
