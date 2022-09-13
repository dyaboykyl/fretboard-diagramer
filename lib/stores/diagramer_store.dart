import 'package:fretboard_diagramer/models/fretboard.dart';
import 'package:fretboard_diagramer/models/fretboard_diagram.dart';
import 'package:mobx/mobx.dart';

part 'diagramer_store.g.dart';

class DiagramerStore = _DiagramerStore with _$DiagramerStore;

abstract class _DiagramerStore with Store {
  @observable
  FretboardDiagram? currentDiagram;

  @computed
  bool get diagramVisibile => currentDiagram != null;

  @action
  onTapNewDiagram() {
    currentDiagram = FretboardDiagram(
      fretboard: Fretboard(
        fretCount: 5,
      ),
      markings: List.empty(),
    );
  }
}
