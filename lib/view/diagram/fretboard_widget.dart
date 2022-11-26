import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/models/music//fretboard_diagram.dart';
import 'package:fretboard_diagramer/view/painter/line_painter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'fretboard_widget.g.dart';

const stringCount = 6;
const stringSpacing = 1 / (stringCount - 1);

@swidget
Widget fretboardWidget(FretboardDiagram fretboardDiagram, Size size) {
  final List<Widget> children = [];
  final fretSpacing = 1 / (fretboardDiagram.fretboard.fretCount);
  for (int i = 0; i < stringCount; i++) {
    final x = i * stringSpacing;
    children.add(CustomPaint(
      painter: LinePainter(Offset(x, 0), Offset(x, 1)),
      size: size,
    ));
  }

  for (int i = 0; i <= fretboardDiagram.fretboard.fretCount; i++) {
    final y = i * fretSpacing;
    children.add(CustomPaint(
      painter: LinePainter(Offset(0, y), Offset(1, y)),
      size: size,
    ));
  }

  return Stack(children: children);
}
