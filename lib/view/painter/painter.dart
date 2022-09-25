import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/view/painter/models/base_models.dart';

final log = logger('paint');

paintToScale(Painting painting, Size size, Canvas canvas) {
  final space = Space(const Point.topLeft(), Point(size.width, size.height));
  final absolutePainting = painting.scale(space);
  log.i('Painting absolute $absolutePainting');
  absolutePainting.paint(canvas);
}
