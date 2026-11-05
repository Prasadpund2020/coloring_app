import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/drawing_stroke.dart';
import 'stroke_geometry.dart';

class StrokePainter extends CustomPainter {
  const StrokePainter({required this.strokes, this.cachedImage, super.repaint});

  final List<DrawingStroke> strokes;
  final ui.Image? cachedImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (cachedImage != null) {
      canvas.drawImage(cachedImage!, Offset.zero, Paint());
    }
    for (final DrawingStroke stroke in strokes) {
      paintDrawingStroke(canvas, size, stroke);
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) =>
      !identical(strokes, oldDelegate.strokes);
}

class LiveStrokePainter extends CustomPainter {
  const LiveStrokePainter({required this.stroke, required Listenable repaint})
    : super(repaint: repaint);

  final DrawingStroke? stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final DrawingStroke? currentStroke = stroke;
    if (currentStroke != null) {
      paintDrawingStroke(canvas, size, currentStroke);
    }
  }

  @override
  bool shouldRepaint(LiveStrokePainter oldDelegate) =>
      !identical(stroke, oldDelegate.stroke);
}

void paintDrawingStroke(Canvas canvas, Size size, DrawingStroke stroke) {
  if (stroke.points.isEmpty) {
    return;
  }
  final Paint paint = Paint()
    ..color = stroke.color
    ..strokeWidth = stroke.width * size.width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..blendMode = stroke.type == StrokeType.eraser
        ? BlendMode.clear
        : BlendMode.srcOver;

  if (stroke.type == StrokeType.eraser) {
    canvas.saveLayer(Offset.zero & size, Paint());
  }
  if (stroke.points.length == 1) {
    final Offset point = Offset(
      stroke.points.first.dx * size.width,
      stroke.points.first.dy * size.height,
    );
    canvas.drawCircle(
      point,
      paint.strokeWidth / 2,
      paint..style = PaintingStyle.fill,
    );
  } else {
    canvas.drawPath(strokeToPath(stroke.points, size), paint);
  }
  if (stroke.type == StrokeType.eraser) {
    canvas.restore();
  }
}
