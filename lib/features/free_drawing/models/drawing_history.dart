import 'drawing_stroke.dart';

class DrawingHistory {
  final List<DrawingStroke> _strokes = <DrawingStroke>[];
  final List<DrawingStroke> _redoStrokes = <DrawingStroke>[];

  List<DrawingStroke> get strokes => List<DrawingStroke>.unmodifiable(_strokes);
  List<DrawingStroke> get redoStrokes =>
      List<DrawingStroke>.unmodifiable(_redoStrokes);
  bool get canUndo => _strokes.isNotEmpty;
  bool get canRedo => _redoStrokes.isNotEmpty;

  void commit(DrawingStroke stroke) {
    _strokes.add(stroke);
    _redoStrokes.clear();
  }

  DrawingStroke? undo() {
    if (_strokes.isEmpty) {
      return null;
    }
    final DrawingStroke stroke = _strokes.removeLast();
    _redoStrokes.add(stroke);
    return stroke;
  }

  DrawingStroke? redo() {
    if (_redoStrokes.isEmpty) {
      return null;
    }
    final DrawingStroke stroke = _redoStrokes.removeLast();
    _strokes.add(stroke);
    return stroke;
  }

  void clear() {
    _strokes.clear();
    _redoStrokes.clear();
  }
}
