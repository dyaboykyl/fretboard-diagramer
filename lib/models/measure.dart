import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/figure_step.dart';

part 'measure.g.dart';

@dataClass
class Measure {
  final List<FigureStep> steps;

  Measure({required this.steps});

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
