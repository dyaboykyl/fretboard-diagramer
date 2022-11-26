import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/figure.dart';
import 'package:fretboard_diagramer/models/music//melody.dart';
import 'package:mobx/mobx.dart';

part 'staff_widget_store.g.dart';

final log = logger('StaffWidgetStore');

class StaffWidgetStore = _StaffWidgetStore with _$StaffWidgetStore;

abstract class _StaffWidgetStore with Store {
  Size size;
  final lineCount = 5.0;
  @observable
  Melody melody;
  @observable
  Figure figure;

  late final staffHeight = size.height / 2;
  late final startLineWidth = 4 * staffHeight / 100;
  late final horizontalLineWidth = .5 * staffHeight / 100;
  late final noteStrokeWidth = horizontalLineWidth * 8;

  _StaffWidgetStore(this.size, this.figure, [Melody? melody]) : melody = melody ?? Melody.empty();
}
