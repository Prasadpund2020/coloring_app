import 'package:flutter/material.dart';

import '../models/coloring_page.dart';

class ColoringPainter extends CustomPainter {
  const ColoringPainter({
    required this.page,
    required this.fills,
    super.repaint,
  });

  final ColoringPage page;
  final Map<String, Color> fills;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final double scale = _scale(size);
    final Offset offset = Offset(
      (size.width - page.viewBox.width * scale) / 2,
      (size.height - page.viewBox.height * scale) / 2,
    );
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);
    for (final ColoringRegion region in page.regions) {
      final Color color = fills[region.id] ?? Colors.white;
      canvas.drawPath(region.path, Paint()..color = color);
    }
    final Paint outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 / scale
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    for (final Path outline in page.outlines) {
      canvas.drawPath(outline, outlinePaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(ColoringPainter oldDelegate) =>
      !identical(page, oldDelegate.page) ||
      !identical(fills, oldDelegate.fills);

  double _scale(Size size) {
    final double widthScale = size.width / page.viewBox.width;
    final double heightScale = size.height / page.viewBox.height;
    return widthScale < heightScale ? widthScale : heightScale;
  }
}
