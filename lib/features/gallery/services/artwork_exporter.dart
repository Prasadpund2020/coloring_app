import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ArtworkExporter {
  const ArtworkExporter();

  Future<Uint8List> render(
    CustomPainter painter, {
    required int width,
    required int height,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    painter.paint(canvas, Size(width.toDouble(), height.toDouble()));
    final ui.Image image = await recorder.endRecording().toImage(width, height);
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    image.dispose();
    if (data == null) {
      throw StateError('PNG encoding returned no data');
    }
    return data.buffer.asUint8List();
  }
}
