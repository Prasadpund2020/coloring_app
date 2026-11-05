import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../controllers/coloring_controller.dart';

class ColoringToolbar extends StatelessWidget {
  const ColoringToolbar({
    required this.controller,
    required this.onHome,
    super.key,
  });

  final ColoringController controller;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          _ToolButton(icon: Icons.home, label: 'Home', onPressed: onHome),
          _ToolButton(
            icon: Icons.undo,
            label: 'Undo',
            onPressed: controller.canUndo ? controller.undo : null,
          ),
          _ToolButton(
            icon: Icons.redo,
            label: 'Redo',
            onPressed: controller.canRedo ? controller.redo : null,
          ),
          _ToolButton(
            icon: Icons.restart_alt,
            label: 'Reset',
            onPressed: controller.canUndo ? controller.reset : null,
          ),
          for (final Color color in DesignConstants.drawingPalette)
            Semantics(
              button: true,
              label: 'Color swatch',
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => controller.setSelectedColor(color),
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    width: DesignConstants.minimumChildTarget,
                    height: DesignConstants.minimumChildTarget,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.selectedColor == color
                            ? DesignConstants.ink
                            : Colors.white,
                        width: controller.selectedColor == color ? 4 : 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
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
