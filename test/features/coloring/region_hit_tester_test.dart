import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/coloring/models/coloring_page.dart';
import 'package:little_doodle/features/coloring/services/region_hit_tester.dart';
import 'package:path_drawing/path_drawing.dart';

void main() {
  final ColoringPage page = ColoringPage(
    id: 'test',
    category: 'Shapes',
    viewBox: const Size(100, 100),
    regions: <ColoringRegion>[
      ColoringRegion(
        id: 'bottom',
        path: parseSvgPathData('M0 0 L100 0 L100 100 L0 100 Z'),
      ),
      ColoringRegion(
        id: 'top',
        path: parseSvgPathData('M25 25 L75 25 L75 75 L25 75 Z'),
      ),
    ],
    outlines: <Path>[parseSvgPathData('M0 0 L100 100')],
  );
  const RegionHitTester tester = RegionHitTester();

  test('hits inside and prefers overlapping top region', () {
    expect(
      tester.hitTest(page, const Offset(50, 50), const Size(100, 100)),
      'top',
    );
    expect(
      tester.hitTest(page, const Offset(10, 10), const Size(100, 100)),
      'bottom',
    );
  });

  test('handles margins, boundaries and non-square tablet canvas', () {
    expect(
      tester.hitTest(page, const Offset(0, 0), const Size(200, 100)),
      isNull,
    );
    expect(
      tester.hitTest(page, const Offset(140, 90), const Size(200, 100)),
      'bottom',
    );
    expect(
      tester.hitTest(page, const Offset(50, 50), const Size(100, 200)),
      'bottom',
    );
    expect(
      tester.hitTest(page, const Offset(-1, 50), const Size(100, 100)),
      isNull,
    );
  });
}
