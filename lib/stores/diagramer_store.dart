import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';
import 'package:fretboard_diagramer/models/fretboard.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';
import 'package:fretboard_diagramer/view/painter/diagram_painter.dart';
import 'package:mobx/mobx.dart';

part 'diagramer_store.g.dart';

final log = logger('DiagramerStore');

class DiagramerStore = _DiagramerStore with _$DiagramerStore;

abstract class _DiagramerStore with Store {
  @observable
  FretboardDiagram? _currentDiagram;

  @computed
  bool get diagramVisibile => _currentDiagram != null;

  @computed
  FretboardDiagram get currentDiagram => _currentDiagram ?? FretboardDiagram.empty();

  @computed
  DiagramPainter get diagramPainter => DiagramPainter(currentDiagram);

  @action
  onTapNewDiagram() {
    _currentDiagram = FretboardDiagram(
      fretboard: Fretboard(
        fretCount: 5,
      ),
      markings: List.empty(),
    );
  }

  @action
  onPointerUp(Offset pointer) {
    final fretPosition = diagramPainter.getFretPosition(pointer.dx, pointer.dy);
    if (fretPosition == null) {
      return;
    }

    log.i('Determined pointer touched fret position: $fretPosition');
    if (currentDiagram.hasNoteMarking(fretPosition)) {
      _currentDiagram = currentDiagram.removeNoteMarking(fretPosition);
    } else {
      _currentDiagram = currentDiagram.addNoteMarking(fretPosition);
    }
  }
}
