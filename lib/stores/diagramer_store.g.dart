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

  late final _$currentDiagramAtom =
      Atom(name: '_DiagramerStore.currentDiagram', context: context);

  @override
  FretboardDiagram? get currentDiagram {
    _$currentDiagramAtom.reportRead();
    return super.currentDiagram;
  }

  @override
  set currentDiagram(FretboardDiagram? value) {
    _$currentDiagramAtom.reportWrite(value, super.currentDiagram, () {
      super.currentDiagram = value;
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
  String toString() {
    return '''
currentDiagram: ${currentDiagram},
diagramVisibile: ${diagramVisibile}
    ''';
  }
}
