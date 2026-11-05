import 'dart:ui';

import '../models/coloring_page.dart';

class RegionHitTester {
  const RegionHitTester();

  String? hitTest(ColoringPage page, Offset localPosition, Size canvasSize) {
    if (canvasSize.width <= 0 ||
        canvasSize.height <= 0 ||
        localPosition.dx < 0 ||
        localPosition.dy < 0 ||
        localPosition.dx > canvasSize.width ||
        localPosition.dy > canvasSize.height) {
      return null;
    }
    final double scale = _scale(page, canvasSize);
    final double offsetX = (canvasSize.width - page.viewBox.width * scale) / 2;
    final double offsetY =
        (canvasSize.height - page.viewBox.height * scale) / 2;
    final Offset point = Offset(
      (localPosition.dx - offsetX) / scale,
      (localPosition.dy - offsetY) / scale,
    );
    if (point.dx < 0 ||
        point.dy < 0 ||
        point.dx > page.viewBox.width ||
        point.dy > page.viewBox.height) {
      return null;
    }
    for (final ColoringRegion region in page.regions.reversed) {
      if (region.path.contains(point) ||
          region.path.getBounds().inflate(0.01).contains(point)) {
        return region.id;
      }
    }
    return null;
  }

  static double _scale(ColoringPage page, Size canvasSize) {
    final double widthScale = canvasSize.width / page.viewBox.width;
    final double heightScale = canvasSize.height / page.viewBox.height;
    return widthScale < heightScale ? widthScale : heightScale;
  }
}
