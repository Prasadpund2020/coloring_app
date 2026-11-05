import 'package:flutter/material.dart';

import '../controllers/coloring_controller.dart';
import '../painters/coloring_painter.dart';

class ColoringCanvas extends StatelessWidget {
  const ColoringCanvas({required this.controller, super.key});

  final ColoringController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (TapUpDetails details) =>
              controller.onTap(details.localPosition, size),
          child: ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: ColoringPainter(
                  page: controller.page,
                  fills: controller.state.fills,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        );
      },
    );
  }
}
