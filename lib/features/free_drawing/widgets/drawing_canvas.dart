import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../controllers/drawing_controller.dart';
import '../models/drawing_stroke.dart';
import '../painters/stroke_geometry.dart';
import '../painters/stroke_painter.dart';
import 'sticker_layer.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({required this.controller, super.key});

  final DrawingController controller;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  ui.Image? _cachedImage;
  int _cachedStrokeCount = 0;
  int _cachedGeneration = 0;
  Size _lastSize = Size.zero;

  DrawingController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onCommittedChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onCommittedChange);
    _cachedImage?.dispose();
    super.dispose();
  }

  void _onCommittedChange() {
    if (_controller.cacheGeneration != _cachedGeneration ||
        _controller.strokes.length < _cachedStrokeCount) {
      _clearCache();
    }
    if (_lastSize != Size.zero) {
      _prepareCache(_lastSize);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _clearCache() {
    _cachedImage?.dispose();
    _cachedImage = null;
    _cachedStrokeCount = 0;
    _cachedGeneration = _controller.cacheGeneration;
  }

  Future<void> _prepareCache(Size size) async {
    final List<DrawingStroke> strokes = _controller.strokes;
    if (strokes.length <= DesignConstants.drawingFlattenThreshold ||
        _cachedStrokeCount > 0 ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }
    final int keepFrom =
        strokes.length - DesignConstants.drawingRetainedVectorStrokes;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    for (final DrawingStroke stroke in strokes.take(keepFrom)) {
      paintDrawingStroke(canvas, size, stroke);
    }
    final ui.Image image = await recorder.endRecording().toImage(
      size.width.ceil(),
      size.height.ceil(),
    );
    if (!mounted ||
        _controller.strokes.length != strokes.length ||
        _controller.cacheGeneration != _cachedGeneration) {
      image.dispose();
      return;
    }
    _cachedImage?.dispose();
    _cachedImage = image;
    _cachedStrokeCount = keepFrom;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        _lastSize = size;
        _prepareCache(size);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (DragStartDetails details) {
            _controller.beginStroke(
              normalizeDrawingPoint(details.localPosition, size),
            );
          },
          onPanUpdate: (DragUpdateDetails details) {
            _controller.updateStroke(
              normalizeDrawingPoint(details.localPosition, size),
            );
          },
          onPanEnd: (_) => _controller.endStroke(),
          child: RepaintBoundary(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ListenableBuilder(
                  listenable: _controller,
                  builder: (BuildContext context, Widget? child) {
                    final List<DrawingStroke> strokes = _controller.strokes;
                    final int vectorStart = _cachedStrokeCount <= strokes.length
                        ? _cachedStrokeCount
                        : 0;
                    return CustomPaint(
                      painter: StrokePainter(
                        strokes: strokes.skip(vectorStart).toList(),
                        cachedImage: vectorStart > 0 ? _cachedImage : null,
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<DrawingStroke?>(
                  valueListenable: _controller.liveStroke,
                  builder:
                      (
                        BuildContext context,
                        DrawingStroke? value,
                        Widget? child,
                      ) {
                        return CustomPaint(
                          painter: LiveStrokePainter(
                            stroke: value,
                            repaint: _controller.liveStroke,
                          ),
                        );
                      },
                ),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return StickerLayer(controller: _controller, size: size);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
