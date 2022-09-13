// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagramer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DiagramerStore on _DiagramerStore, Store {
  Computed<bool>? _$diagramVisibileComputed;

  @override
  bool get diagramVisibile =>
      (_$diagramVisibileComputed ??= Computed<bool>(() => super.diagramVisibile,
              name: '_DiagramerStore.diagramVisibile'))
          .value;
  Computed<FretboardDiagram>? _$currentDiagramComputed;

  @override
  FretboardDiagram get currentDiagram => (_$currentDiagramComputed ??=
          Computed<FretboardDiagram>(() => super.currentDiagram,
              name: '_DiagramerStore.currentDiagram'))
      .value;
  Computed<DiagramPainter>? _$diagramPainterComputed;

  @override
  DiagramPainter get diagramPainter => (_$diagramPainterComputed ??=
          Computed<DiagramPainter>(() => super.diagramPainter,
              name: '_DiagramerStore.diagramPainter'))
      .value;

  late final _$_currentDiagramAtom =
      Atom(name: '_DiagramerStore._currentDiagram', context: context);

  @override
  FretboardDiagram? get _currentDiagram {
    _$_currentDiagramAtom.reportRead();
    return super._currentDiagram;
  }

  @override
  set _currentDiagram(FretboardDiagram? value) {
    _$_currentDiagramAtom.reportWrite(value, super._currentDiagram, () {
      super._currentDiagram = value;
    });
  }

  late final _$_DiagramerStoreActionController =
      ActionController(name: '_DiagramerStore', context: context);

  @override
  dynamic onTapNewDiagram() {
    final _$actionInfo = _$_DiagramerStoreActionController.startAction(
        name: '_DiagramerStore.onTapNewDiagram');
    try {
      return super.onTapNewDiagram();
    } finally {
      _$_DiagramerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onPointerUp(Offset pointer) {
    final _$actionInfo = _$_DiagramerStoreActionController.startAction(
        name: '_DiagramerStore.onPointerUp');
    try {
      return super.onPointerUp(pointer);
    } finally {
      _$_DiagramerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
diagramVisibile: ${diagramVisibile},
currentDiagram: ${currentDiagram},
diagramPainter: ${diagramPainter}
    ''';
  }
}
