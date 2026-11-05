import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../../core/constants/design_constants.dart';
import '../models/drawing_history.dart';
import '../models/drawing_stroke.dart';

class DrawingController extends ChangeNotifier {
  DrawingController()
    : _history = DrawingHistory(),
      liveStroke = ValueNotifier<DrawingStroke?>(null);

  final DrawingHistory _history;
  final ValueNotifier<DrawingStroke?> liveStroke;
  Color color = DesignConstants.coral;
  double brushWidth = DesignConstants.mediumBrushWidth;
  bool isEraser = false;
  bool _isDrawing = false;
  int _cacheGeneration = 0;

  List<DrawingStroke> get strokes => _history.strokes;
  bool get canUndo => _history.canUndo;
  bool get canRedo => _history.canRedo;
  bool get isDrawing => _isDrawing;
  int get cacheGeneration => _cacheGeneration;

  void setColor(Color nextColor) {
    color = nextColor;
    isEraser = false;
    notifyListeners();
  }

  void setBrushWidth(double nextWidth) {
    brushWidth = nextWidth;
    notifyListeners();
  }

  void toggleEraser() {
    isEraser = !isEraser;
    notifyListeners();
  }

  void beginStroke(Offset point) {
    if (!isValidPoint(point)) {
      return;
    }
    _isDrawing = true;
    liveStroke.value = DrawingStroke(
      points: <Offset>[point],
      color: color,
      width: brushWidth,
      type: isEraser ? StrokeType.eraser : StrokeType.pen,
    );
  }

  void updateStroke(Offset point) {
    if (!_isDrawing || !isValidPoint(point)) {
      return;
    }
    final DrawingStroke? current = liveStroke.value;
    if (current == null) {
      return;
    }
    liveStroke.value = current.copyWith(
      points: <Offset>[...current.points, point],
    );
  }

  void endStroke() {
    final DrawingStroke? current = liveStroke.value;
    if (!_isDrawing || current == null) {
      return;
    }
    _history.commit(current);
    _isDrawing = false;
    liveStroke.value = null;
    notifyListeners();
  }

  void undo() {
    if (_history.undo() != null) {
      _cacheGeneration++;
      notifyListeners();
    }
  }

  void redo() {
    if (_history.redo() != null) {
      _cacheGeneration++;
      notifyListeners();
    }
  }

  void clear() {
    if (!canUndo && !canRedo) {
      return;
    }
    _history.clear();
    _cacheGeneration++;
    notifyListeners();
  }

  bool isValidPoint(Offset point) =>
      point.dx.isFinite &&
      point.dy.isFinite &&
      point.dx >= -0.02 &&
      point.dx <= 1.02 &&
      point.dy >= -0.02 &&
      point.dy <= 1.02;

  @override
  void dispose() {
    liveStroke.dispose();
    super.dispose();
  }
}
