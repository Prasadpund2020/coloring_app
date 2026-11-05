import 'dart:ui';

enum StrokeType { pen, eraser }

class DrawingStroke {
  DrawingStroke({
    required List<Offset> points,
    required this.color,
    required this.width,
    required this.type,
  }) : points = List<Offset>.unmodifiable(points);

  final List<Offset> points;
  final Color color;
  final double width;
  final StrokeType type;

  DrawingStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? width,
    StrokeType? type,
  }) {
    return DrawingStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      width: width ?? this.width,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! DrawingStroke ||
        color != other.color ||
        width != other.width ||
        type != other.type ||
        points.length != other.points.length) {
      return false;
    }
    for (int index = 0; index < points.length; index++) {
      if (points[index] != other.points[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(color, width, type, Object.hashAll(points));
}
