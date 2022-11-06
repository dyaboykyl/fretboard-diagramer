import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/models/melody.dart';
import 'package:mobx/mobx.dart';

part 'staff_widget_store.g.dart';

class StaffWidgetStore = _StaffWidgetStore with _$StaffWidgetStore;

abstract class _StaffWidgetStore with Store {
  Size size;
  @observable
  Melody melody;
  final lineCount = 5.0;
  late final staffHeight = size.height / 2;
  late final staffTop = size.height / 2 - staffHeight / 2;
  late final staffBottom = staffTop + staffHeight;
  late final startLineWidth = 4 * staffHeight / 100;
  late final horizontalLineWidth = .5 * staffHeight / 100;
  late final measureLength = size.width / max(melody.measures.length, 2);
  late final firstNoteX = measureLength / 8;
  late final noteSize = Size(measureLength / 12, .8 * staffHeight / lineCount);
  late final noteStrokeWidth = horizontalLineWidth * 8;

  _StaffWidgetStore(this.size, [Melody? melody]) : melody = melody ?? Melody.empty();
}
