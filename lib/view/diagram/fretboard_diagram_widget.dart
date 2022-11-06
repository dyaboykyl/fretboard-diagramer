import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/stores/diagramer_store.dart';
import 'package:fretboard_diagramer/utils.dart';
import 'package:fretboard_diagramer/view/diagram/fretboard_widget.dart';

class FretboardDiagramWidget extends StatefulWidget {
  final DiagramerStore store;
  final double size;

  const FretboardDiagramWidget({super.key, required this.store, required this.size});

  @override
  State<FretboardDiagramWidget> createState() => _FretboardDiagramState();
}

class _FretboardDiagramState extends State<FretboardDiagramWidget> {
  DiagramerStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    if (!store.diagramVisibile) {
      return const SizedBox.shrink();
    }

    return observer(() => Column(children: [
          ElevatedButton(
            onPressed: () => store.onTapSelectRoot(),
            child: const Text('Select Root'),
          ),
          Listener(
              onPointerUp: (event) {
                store.onPointerUp(event.localPosition);
              },
              child: FretboardWidget(store.currentDiagram, Size(400, 600))
              // child: CustomPaint(
              //   size: Size(widget.size, widget.size),
              //   painter: store.diagramPainter,
              // ),
              ),
          Text(store.currentDiagram.title),
          ElevatedButton(
              onPressed: () => store.toggleShowAllScaleValues(),
              child: Text(
                store.displayAllScaleValuesString,
              )),
        ]));
  }
}
