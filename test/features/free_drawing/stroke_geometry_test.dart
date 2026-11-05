import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/free_drawing/painters/stroke_geometry.dart';

void main() {
  const Size canvas = Size(100, 200);

  test('empty points produce an empty path', () {
    expect(strokeToPath(<Offset>[], canvas).computeMetrics().length, 0);
  });

  test('one point produces a dot path', () {
    expect(
      strokeToPath(<Offset>[
        const Offset(0.5, 0.5),
      ], canvas).computeMetrics().isNotEmpty,
      isTrue,
    );
  });

  test('two points produce a line', () {
    expect(
      strokeToPath(<Offset>[
        const Offset(0, 0),
        const Offset(1, 1),
      ], canvas).computeMetrics().length,
      greaterThan(0),
    );
  });

  test('many points produce a smoothed path', () {
    final List<Offset> points = List<Offset>.generate(
      50,
      (int index) => Offset(index / 50, (index % 5) / 5),
    );
    expect(
      strokeToPath(points, canvas).computeMetrics().length,
      greaterThan(0),
    );
  });

  test('invalid coordinates are rejected', () {
    expect(isValidDrawingPoint(const Offset(double.nan, 0)), isFalse);
    expect(isValidDrawingPoint(const Offset(0, double.infinity)), isFalse);
    expect(isValidDrawingPoint(const Offset(0.5, 0.5)), isTrue);
  });
}
