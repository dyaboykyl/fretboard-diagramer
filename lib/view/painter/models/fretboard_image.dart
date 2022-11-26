import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/models/music//fretboard_diagram.dart';
import 'package:fretboard_diagramer/view/painter/models/base_models.dart';

const stringCount = 6;
const stringSeparation = 1.0 / (stringCount - 1);

Painting fretboardImage(FretboardDiagram fretboardDiagram) {
  final fretSeparation = 1.0 / fretboardDiagram.fretboard.fretCount;
  final strings = List.generate(stringCount, (string) {
    final x = string * stringSeparation;
    return Line(Point(x, 0), Point(x, 1));
  });
  final frets = List.generate(fretboardDiagram.fretboard.fretCount + 1, (fret) {
    final y = fret * fretSeparation;
    return Line(Point(0, y), Point(1, y));
  });

  return Painting(
    paintable: Rectangle(center: const Point.center(), size: const Size(.6, .8)),
    children: strings + frets,
  );
}
