import 'package:flutter/material.dart';

import '../controllers/drawing_controller.dart';
import '../models/sticker.dart';

class StickerLayer extends StatelessWidget {
  const StickerLayer({required this.controller, required this.size, super.key});

  final DrawingController controller;
  final Size size;

  static const Map<String, String> stickerSymbols = <String, String>{
    'star': '⭐',
    'heart': '❤️',
    'sun': '☀️',
    'rainbow': '🌈',
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: controller.stickers.map((Sticker sticker) {
        final double dimension = sticker.scale * size.width;
        return Positioned(
          left: sticker.center.dx * size.width - dimension / 2,
          top: sticker.center.dy * size.height - dimension / 2,
          width: dimension,
          height: dimension,
          child: GestureDetector(
            onTap: () => controller.selectSticker(sticker.id),
            onPanUpdate: (DragUpdateDetails details) {
              controller.moveSticker(
                sticker.id,
                Offset(
                  sticker.center.dx + details.delta.dx / size.width,
                  sticker.center.dy + details.delta.dy / size.height,
                ),
              );
            },
            child: Semantics(
              label: '${sticker.assetId} sticker',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: controller.selectedStickerId == sticker.id
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: FittedBox(
                  child: Text(
                    stickerSymbols[sticker.assetId] ?? '✨',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
