import 'dart:ui';

Path strokeToPath(List<Offset> points, Size size) {
  final Path path = Path();
  if (points.isEmpty) {
    return path;
  }

  Offset scale(Offset point) =>
      Offset(point.dx * size.width, point.dy * size.height);
  final Offset first = scale(points.first);
  path.moveTo(first.dx, first.dy);
  if (points.length == 1) {
    path.addOval(Rect.fromCircle(center: first, radius: 0.01));
    return path;
  }
  if (points.length == 2) {
    final Offset second = scale(points[1]);
    path.lineTo(second.dx, second.dy);
    return path;
  }

  Offset previous = first;
  for (int index = 1; index < points.length - 1; index++) {
    final Offset current = scale(points[index]);
    final Offset next = scale(points[index + 1]);
    final Offset midpoint = Offset(
      (current.dx + next.dx) / 2,
      (current.dy + next.dy) / 2,
    );
    path.quadraticBezierTo(current.dx, current.dy, midpoint.dx, midpoint.dy);
    previous = current;
  }
  final Offset last = scale(points.last);
  path.quadraticBezierTo(previous.dx, previous.dy, last.dx, last.dy);
  return path;
}

bool isValidDrawingPoint(Offset point) =>
    point.dx.isFinite && point.dy.isFinite;

Offset normalizeDrawingPoint(Offset point, Size size) {
  if (size.width <= 0 || size.height <= 0) {
    return Offset.zero;
  }
  return Offset(point.dx / size.width, point.dy / size.height);
}
