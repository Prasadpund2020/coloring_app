import 'package:flutter_test/flutter_test.dart';

import 'package:little_doodle/core/constants/design_constants.dart';
import 'package:little_doodle/features/free_drawing/controllers/drawing_controller.dart';

void main() {
  test('stickers are normalized, selectable, resizable and clamped', () {
    final DrawingController controller = DrawingController();

    expect(controller.addSticker('star'), isTrue);
    expect(controller.stickers.single.center.dx, 0.5);
    controller.moveSticker(controller.stickers.single.id, const Offset(2, -1));
    expect(controller.stickers.single.center.dx, 0.9);
    expect(controller.stickers.single.center.dy, 0.1);
    controller.resizeSelectedSticker(1);
    expect(
      controller.stickers.single.scale,
      DesignConstants.maximumStickerScale,
    );
    controller.deleteSelectedSticker();
    expect(controller.stickers, isEmpty);
    controller.dispose();
  });

  test('sticker count is capped', () {
    final DrawingController controller = DrawingController();
    for (int index = 0; index < DesignConstants.maximumStickers; index++) {
      expect(controller.addSticker('star'), isTrue);
    }

    expect(controller.addSticker('star'), isFalse);
    expect(controller.stickers, hasLength(DesignConstants.maximumStickers));
    controller.dispose();
  });
}
