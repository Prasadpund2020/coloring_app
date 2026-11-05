import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/free_drawing/models/drawing_history.dart';
import 'package:little_doodle/features/free_drawing/models/drawing_stroke.dart';

DrawingStroke stroke(int value) {
  return DrawingStroke(
    points: <Offset>[Offset(value / 100, value / 100)],
    color: const Color(0xFFFF0000),
    width: 0.02,
    type: StrokeType.pen,
  );
}

void main() {
  test('commit, undo and redo preserve stroke order', () {
    final DrawingHistory history = DrawingHistory();
    final DrawingStroke first = stroke(1);
    final DrawingStroke second = stroke(2);

    history
      ..commit(first)
      ..commit(second);
    expect(history.strokes, <DrawingStroke>[first, second]);
    expect(history.undo(), second);
    expect(history.strokes, <DrawingStroke>[first]);
    expect(history.redo(), second);
    expect(history.strokes, <DrawingStroke>[first, second]);
  });

  test('a new commit clears redo history', () {
    final DrawingHistory history = DrawingHistory()
      ..commit(stroke(1))
      ..commit(stroke(2));
    history.undo();
    history.commit(stroke(3));

    expect(history.canRedo, isFalse);
    expect(history.strokes, hasLength(2));
    expect(history.strokes.last, stroke(3));
  });

  test('clear removes committed and redo strokes', () {
    final DrawingHistory history = DrawingHistory()
      ..commit(stroke(1))
      ..commit(stroke(2));
    history.undo();
    history.clear();

    expect(history.strokes, isEmpty);
    expect(history.redoStrokes, isEmpty);
  });

  test('history supports 1000 strokes', () {
    final DrawingHistory history = DrawingHistory();
    for (int index = 0; index < 1000; index++) {
      history.commit(stroke(index));
    }

    expect(history.strokes, hasLength(1000));
    for (int index = 0; index < 1000; index++) {
      history.undo();
    }
    expect(history.strokes, isEmpty);
    expect(history.redoStrokes, hasLength(1000));
  });
}
