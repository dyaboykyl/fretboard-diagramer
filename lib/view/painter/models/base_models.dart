import 'package:data_class_annotation/data_class_annotation.dart';
import 'package:flutter/material.dart';
import 'package:fretboard_diagramer/logging/logging.dart';

part 'base_models.g.dart';

final log = logger('PaintModel');

abstract class Paintable {
  paint(Canvas canvas);
  Paintable scale(Space parentSpace);
}

abstract class Spaceable extends Paintable {
  Space space(Space space);

  @override
  Spaceable scale(Space parentSpace);
}

@dataClass
class Painting implements Paintable {
  final Spaceable paintable;
  final List<Paintable> children;

  Painting({required this.paintable, this.children = const []});

  @override
  paint(Canvas canvas) {
    for (var element in children) {
      element.paint(canvas);
    }
  }

  @override
  Paintable scale(Space parentSpace) {
    final newPaintable = paintable.scale(parentSpace);
    final space = paintable.space(parentSpace);
    return Painting(
      paintable: newPaintable,
      children: children.map((child) => child.scale(space)).toList(),
    );
  }

  @override
  String toString() => dataToString();
}

class PaintingCanvas {
  final Rectangle canvas;
  final Painting painting;
  final Color? background;

  PaintingCanvas(this.canvas, this.painting, {this.background});

  // Space get space =
}

@dataClass
class Rectangle implements Spaceable {
  final Point center;
  final Size size;
  final Color color;
  final bool fill;

  Point get topLeft => Point(center.x - size.width / 2, center.y - size.height / 2);
  Point get bottomRight => Point(center.x + size.width / 2, center.y + size.height / 2);

  Rectangle({required this.center, required this.size, this.color = Colors.black, this.fill = false});

  @override
  Space space(Space space) {
    return Space(topLeft.inSpace(space), bottomRight.inSpace(space));
  }

  @override
  Spaceable scale(Space parentSpace) {
    return copyWith(
        center: center.inSpace(parentSpace),
        size: Size(
          size.width * parentSpace.size.width,
          size.height * parentSpace.size.height,
        ));
  }

  @override
  paint(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;
    // ..color = background ?? Colors.transparent
    // ..fil
    canvas.drawRect(Rect.fromCenter(center: center.toOffset(), width: size.width, height: size.height), paint);
  }

  @override
  String toString() => dataToString();
}

// always between 0 and 1
@dataClass
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  const Point.center() : this(.5, .5);

  const Point.topLeft() : this(0, 0);

  Offset toOffset() => Offset(x, y);

  Point inSpace(Space space) {
    return Point(
      x * (space.bottomRight.x - space.topLeft.x) + space.topLeft.x,
      y * (space.bottomRight.y - space.topLeft.y) + space.topLeft.y,
    );
  }

  Point operator -(Point value) {
    return Point(x - value.x, y - value.y);
  }

  Point operator *(double value) {
    return Point(x * value, y * value);
  }

  @override
  String toString() => dataToString();
}

@dataClass
class Space {
  final Point topLeft;
  final Point bottomRight;

  Size get size => Size(bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);

  Space(this.topLeft, this.bottomRight);

  @override
  String toString() => dataToString();
}

@dataClass
class Line implements Paintable, Spaceable {
  final Point start;
  final Point end;
  final int thickness;
  final Color color;

  bool get isVertical => start.x == end.x;

  bool get isHorizontal => start.y == end.y;

  Line(this.start, this.end, {this.thickness = 5, this.color = Colors.black});

  Line.vertical({required double yStart, required double yEnd, required double x}) : this(Point(x, yStart), Point(x, yEnd));

  Line.horizontal({required double xStart, required double xEnd, required double y}) : this(Point(xStart, y), Point(xEnd, y));

  @override
  Space space(Space space) {
    return Space(start.inSpace(space), end.inSpace(space));
  }

  @override
  Spaceable scale(Space space) {
    return copyWith(
      start: start.inSpace(space),
      end: end.inSpace(space),
    );
  }

  @override
  paint(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness.toDouble();
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }

  @override
  String toString() => dataToString();
}

@dataClass
class Circle implements Paintable, Spaceable {
  final Point origin;
  final int radius;
  final Color color;

  Circle(this.origin, this.radius, {this.color = Colors.black});

  @override
  Space space(Space space) {
    final originInSpace = origin.inSpace(space);
    return Space(originInSpace, originInSpace); // TODO: fix
  }

  @override
  Spaceable scale(Space space) {
    return copyWith(origin: origin.inSpace(space));
  }

  @override
  paint(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(origin.toOffset(), radius.toDouble(), paint);
  }
}

@dataClass
class Text implements Paintable {
  final String text;
  final Color color;
  final double size;
  final Point center;

  Text(this.text, {this.size = 1, this.color = Colors.black, this.center = const Point.center()});

  @override
  Paintable scale(Space space) {
    return copyWith(center: center.inSpace(space));
  }

  @override
  paint(Canvas canvas) {
    final span = TextSpan(text: text, style: TextStyle(color: color, fontSize: size));
    final textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    final drawPosition = Offset(center.x - textPainter.width / 2, center.y - (textPainter.height / 2));
    textPainter.paint(canvas, drawPosition);
  }
}
