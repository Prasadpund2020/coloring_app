import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../controllers/drawing_controller.dart';

class DrawingToolbar extends StatelessWidget {
  const DrawingToolbar({
    required this.controller,
    required this.onHome,
    super.key,
  });

  final DrawingController controller;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          _ToolbarButton(icon: Icons.home, label: 'Home', onPressed: onHome),
          _ToolbarButton(
            icon: Icons.undo,
            label: 'Undo',
            onPressed: controller.canUndo ? controller.undo : null,
          ),
          _ToolbarButton(
            icon: Icons.redo,
            label: 'Redo',
            onPressed: controller.canRedo ? controller.redo : null,
          ),
          _ToolbarButton(
            icon: Icons.delete_outline,
            label: 'Clear',
            onPressed: controller.canUndo ? () => _confirmClear(context) : null,
          ),
          _ToolbarButton(
            icon: controller.isEraser ? Icons.brush : Icons.cleaning_services,
            label: controller.isEraser ? 'Brush' : 'Eraser',
            onPressed: controller.toggleEraser,
          ),
          for (final (String assetId, String label) in <(String, String)>[
            ('star', 'Star sticker'),
            ('heart', 'Heart sticker'),
            ('sun', 'Sun sticker'),
            ('rainbow', 'Rainbow sticker'),
          ])
            _ToolbarButton(
              icon: Icons.emoji_emotions,
              label: label,
              onPressed: () => controller.addSticker(assetId),
            ),
          _ToolbarButton(
            icon: Icons.remove,
            label: 'Make sticker smaller',
            onPressed: controller.selectedStickerId == null
                ? null
                : () => controller.resizeSelectedSticker(-0.02),
          ),
          _ToolbarButton(
            icon: Icons.add,
            label: 'Make sticker larger',
            onPressed: controller.selectedStickerId == null
                ? null
                : () => controller.resizeSelectedSticker(0.02),
          ),
          _ToolbarButton(
            icon: Icons.delete,
            label: 'Delete sticker',
            onPressed: controller.selectedStickerId == null
                ? null
                : controller.deleteSelectedSticker,
          ),
          for (final Color color in DesignConstants.drawingPalette)
            _ColorButton(
              color: color,
              selected: !controller.isEraser && controller.color == color,
              onPressed: () => controller.setColor(color),
            ),
          for (final (String label, double width, double radius)
              in <(String, double, double)>[
                ('Small brush', DesignConstants.smallBrushWidth, 10),
                ('Medium brush', DesignConstants.mediumBrushWidth, 16),
                ('Large brush', DesignConstants.largeBrushWidth, 22),
              ])
            _BrushButton(
              label: label,
              width: width,
              radius: radius,
              selected: controller.brushWidth == width,
              onPressed: () => controller.setBrushWidth(width),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final bool? shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear drawing?'),
        content: const Text('Your drawing will be cleared.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (shouldClear == true) {
      controller.clear();
    }
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 28,
          constraints: const BoxConstraints(
            minWidth: DesignConstants.minimumChildTarget,
            minHeight: DesignConstants.minimumChildTarget,
          ),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.color,
    required this.selected,
    required this.onPressed,
  });

  final Color color;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Color swatch',
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: DesignConstants.minimumChildTarget,
            height: DesignConstants.minimumChildTarget,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? DesignConstants.ink : Colors.white,
                width: selected ? 4 : 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrushButton extends StatelessWidget {
  const _BrushButton({
    required this.label,
    required this.width,
    required this.radius,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final double width;
  final double radius;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: DesignConstants.minimumChildTarget,
            height: DesignConstants.minimumChildTarget,
            decoration: BoxDecoration(
              color: selected ? DesignConstants.sky : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: const BoxDecoration(
                  color: DesignConstants.ink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
