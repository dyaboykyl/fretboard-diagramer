import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:fretboard_diagramer/models/figure.dart';

part 'sheet.g.dart';

@dataClass
class Sheet {
  final String title;
  final List<String> tags;
  final Figure figure;

  Sheet({
    required this.title,
    required this.tags,
    required this.figure,
  });

  @override
  int get hashCode => dataHashCode;

  @override
  bool operator ==(other) => dataEquals(other);

  @override
  String toString() => dataToString();
}
