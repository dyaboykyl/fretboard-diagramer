// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/music//fretboard.dart';
import 'package:fretboard_diagramer/models/music//fretboard_diagram.dart';
import 'package:fretboard_diagramer/view/diagram/diagram_painter.dart';
import 'package:fretboard_diagramer/view/diagram/diagram_view_options.dart';
import 'package:mobx/mobx.dart';

part 'diagramer_store.g.dart';

final log = logger('DiagramerStore');

class DiagramerStore = _DiagramerStore with _$DiagramerStore;

abstract class _DiagramerStore with Store {
  @observable
  FretboardDiagram? _currentDiagram;

  @observable
  bool selectingRoot = false;

  @observable
  DiagramViewOptions diagramViewOptions = DiagramViewOptions(displayAllScaleValues: false);

  @computed
  bool get diagramVisibile => _currentDiagram != null;

  @computed
  String get displayAllScaleValuesString => diagramViewOptions.displayAllScaleValues ? "Don't display scale values" : "Display scale values";

  @computed
  FretboardDiagram get currentDiagram => _currentDiagram ?? FretboardDiagram.empty();

  @computed
  DiagramPainter get diagramPainter => DiagramPainter(currentDiagram, diagramViewOptions);

  @action
  onTapNewDiagram() {
    log.d('newDiagram tapped');
    _currentDiagram = FretboardDiagram(
      fretboard: Fretboard(
        fretCount: 5,
      ),
      markings: List.empty(),
    );
  }

  @action
  onTapSelectRoot() {
    selectingRoot = !selectingRoot;
  }

  @action
  toggleShowAllScaleValues() {
    diagramViewOptions = DiagramViewOptions(displayAllScaleValues: !diagramViewOptions.displayAllScaleValues);
  }

  @action
  onPointerUp(Offset pointer) {
    final fretPosition = diagramPainter.getFretPosition(pointer.dx, pointer.dy);
    if (fretPosition == null) {
      return;
    }

    log.i('Determined pointer touched fret position: $fretPosition');
    if (selectingRoot) {
      log.i("Toggling root");
      selectingRoot = false;
      _currentDiagram = currentDiagram.toggleRoot(fretPosition);
    } else {
      if (currentDiagram.hasNoteMarking(fretPosition)) {
        _currentDiagram = currentDiagram.removeNoteMarking(fretPosition);
      } else {
        _currentDiagram = currentDiagram.addNoteMarking(fretPosition);
      }
    }
  }
}
