import 'package:fretboard_diagramer/models/fret_position.dart';
import 'package:fretboard_diagramer/models/note_marking.dart';
import 'package:fretboard_diagramer/models/scale_value.dart';

import 'fretboard.dart';

class FretboardDiagram {
  final String? titleOverride;
  final Fretboard fretboard;
  final List<NoteMarking> markings;

  FretboardDiagram({required this.fretboard, required this.markings, this.titleOverride});

  FretboardDiagram.empty()
      : fretboard = Fretboard(fretCount: 0),
        markings = List.empty(),
        titleOverride = null;

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

  bool hasNoteMarking(FretPosition fretPosition) {
    return markings.any((m) => m.fretPosition == fretPosition);
  }

  bool hasScaleValue(ScaleValue scaleValue) {
    return markings.any((m) => m.scaleValue == scaleValue);
  }

  bool hasScaleValues(List<ScaleValue> scaleValues) {
    return scaleValues.every((s) => markings.any((m) => m.scaleValue == s));
  }

  bool hasExactScaleValues(List<ScaleValue> scaleValues) {
    if (!hasScaleValues(scaleValues)) {
      return false;
    }

    final copy = markings.toList();
    copy.removeWhere((m) => scaleValues.contains(m.scaleValue));
    return copy.isEmpty;
  }

  FretboardDiagram removeNoteMarking(FretPosition fretPosition) {
    final newMarkings = markings.toList();
    newMarkings.retainWhere((m) => m.fretPosition != fretPosition);
    return FretboardDiagram(fretboard: fretboard, markings: _filterOutNoteMarking(fretPosition));
  }

  FretboardDiagram addNoteMarking(FretPosition fretPosition) {
    final newMarkings = _filterOutNoteMarking(fretPosition);
    newMarkings.add(NoteMarking(fretPosition: fretPosition, scaleValue: fretboard.getScaleValue(fretPosition)));
    return FretboardDiagram(fretboard: fretboard, markings: newMarkings);
  }

  FretboardDiagram toggleRoot(FretPosition? root) {
    final fretboard = Fretboard(
      fretCount: this.fretboard.fretCount,
      root: root,
    );
    final newMarkings = markings
        .map((m) => NoteMarking(
              fretPosition: m.fretPosition,
              scaleValue: fretboard.getScaleValue(m.fretPosition),
            ))
        .toList();
    return FretboardDiagram(fretboard: fretboard, markings: newMarkings, titleOverride: titleOverride);
  }

  String get title {
    if (titleOverride != null) {
      return titleOverride!;
    }

    if (fretboard.root == null) {
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

  List<NoteMarking> _filterOutNoteMarking(FretPosition fretPosition) {
    final newMarkings = markings.toList();
    newMarkings.retainWhere((m) => m.fretPosition != fretPosition);
    return newMarkings;
  }
}
