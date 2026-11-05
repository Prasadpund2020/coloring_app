import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/coloring/controllers/coloring_controller.dart';
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
        id: 'one',
        path: parseSvgPathData('M0 0 L100 0 L100 100 L0 100 Z'),
      ),
    ],
    outlines: <Path>[parseSvgPathData('M0 0 L100 100')],
  );

  test('same color does not add a history entry', () {
    final ColoringController controller = ColoringController(
      page: page,
      hitTester: const RegionHitTester(),
    );
    controller
      ..onTap(const Offset(50, 50), const Size(100, 100))
      ..onTap(const Offset(50, 50), const Size(100, 100));
    expect(controller.canUndo, isTrue);
    controller.undo();
    expect(controller.canUndo, isFalse);
    controller.dispose();
  });

  test('fills can be undone, redone and reset', () {
    final ColoringController controller = ColoringController(
      page: page,
      hitTester: const RegionHitTester(),
    );
    controller.onTap(const Offset(50, 50), const Size(100, 100));
    expect(controller.state.fills, isNotEmpty);
    controller.undo();
    expect(controller.state.fills, isEmpty);
    controller.redo();
    expect(controller.state.fills, isNotEmpty);
    controller.reset();
    expect(controller.state.fills, isEmpty);
    controller.dispose();
  });
}
