import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/free_drawing/controllers/drawing_controller.dart';
import 'package:little_doodle/features/free_drawing/models/drawing_stroke.dart';

void main() {
  test('controller commits a tap as a dot', () {
    final DrawingController controller = DrawingController();
    controller
      ..beginStroke(const Offset(0.5, 0.5))
      ..endStroke();

    expect(controller.strokes, hasLength(1));
    expect(controller.strokes.single.points, hasLength(1));
    expect(controller.strokes.single.type, StrokeType.pen);
    controller.dispose();
  });

  test('controller ignores invalid points and supports undo', () {
    final DrawingController controller = DrawingController();
    controller
      ..beginStroke(const Offset(double.nan, 0.5))
      ..endStroke();
    expect(controller.strokes, isEmpty);

    controller
      ..beginStroke(const Offset(0.5, 0.5))
      ..updateStroke(const Offset(0.6, 0.6))
      ..endStroke()
      ..undo();
    expect(controller.strokes, isEmpty);
    controller.dispose();
  });
}
