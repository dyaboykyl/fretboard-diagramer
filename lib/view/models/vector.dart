import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/material.dart';

part 'vector.g.dart';

@dataClass
class Vector {
  final Offset start;
  final Offset end;
  static Vector zero = Vector.horizontal(xStart: 0, xEnd: 0);

  Vector({required this.start, required this.end});

  Vector.horizontal({required double xStart, required double xEnd, double y = 0})
      : this(start: Offset(xStart, y), end: Offset(xEnd, y));

  Vector.vertical({required double yStart, required double yEnd, double x = 0})
      : this(start: Offset(x, yStart), end: Offset(x, yEnd));

  double get height => (end.dy - start.dy).abs();

  @override
  String toString() => dataToString();
}
