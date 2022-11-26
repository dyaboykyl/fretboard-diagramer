import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/key.dart';
import 'package:fretboard_diagramer/models/time_signature.dart';

part 'melody.g.dart';

abstract class MelodyComponent {
  double get duration;
}

@dataClass
class Rest extends MelodyComponent {
  @override
  final double duration;

  Rest({required this.duration});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}

@dataClass
class Note extends MelodyComponent {
  // middle C = 60, 0 = rest
  final int value;
  @override
  final double duration;

  Note({required this.value, required this.duration});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}

@dataClass
class Measure {
  late final List<MelodyComponent> components;

  Measure({required this.components});

  bool isFull(int beats) {
    return components.fold(0.0, (totalDuration, element) => (totalDuration as double) + element.duration) == beats;
  }
}

@dataClass
class Melody {
  final TimeSignature timeSignature;
  late final List<Measure> measures;
  final Key key;

  Melody({required this.measures, required this.timeSignature, this.key = Key.none});

  Melody.empty() : this(measures: [], timeSignature: TimeSignature.fourFour());

  Melody add(MelodyComponent melodyComponent, [Measure? measure]) {
    var newMeasures = measures.toList();
    // first note
    if (measures.isEmpty) {
      newMeasures.add(Measure(components: [melodyComponent]));
    }

    // last note
    else if (measure == null) {
      if (measures.last.isFull(4)) {
        newMeasures.add(Measure(components: [melodyComponent]));
      } else {
        measures.last.components.add(melodyComponent);
      }
    }

    // final newComponents = components.toList()..insert(positionToAdd, melodyComponent);
    return copyWith(measures: newMeasures);
  }
}
