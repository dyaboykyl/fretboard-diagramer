import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/utils.dart';
import 'package:fretboard_diagramer/view/staff/positioning.dart';
import 'package:fretboard_diagramer/view/staff/staff_painter.dart';
import 'package:fretboard_diagramer/view/staff/staff_widget_store.dart';
import 'package:touchable/touchable.dart';

class StaffWidget extends StatelessWidget {
  final StaffWidgetStore store;

  const StaffWidget(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    return observer(() {
      store.figure;
      return CanvasTouchDetector(
        builder: (context) => CustomPaint(
          painter: StaffPainter(context, StaffPainterPositioning(figure: store.figure, size: store.size)),
          size: store.size,
        ),
        gesturesToOverride: const [GestureType.onTapDown, GestureType.onHover],
      );
    });
  }
}
