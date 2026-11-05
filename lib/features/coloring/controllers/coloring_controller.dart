import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../models/coloring_history.dart';
import '../models/coloring_page.dart';
import '../models/coloring_state.dart';
import '../models/fill_command.dart';
import '../services/region_hit_tester.dart';

class ColoringController extends ChangeNotifier {
  ColoringController({required this.page, required this.hitTester});

  final RegionHitTester hitTester;
  final ColoringHistory _history = ColoringHistory();
  ColoringPage page;
  ColoringState state = const ColoringState();
  Color selectedColor = const Color(0xFFFF8A80);

  bool get canUndo => _history.canUndo;
  bool get canRedo => _history.canRedo;

  void setSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void onTap(Offset localPosition, Size canvasSize) {
    final String? regionId = hitTester.hitTest(page, localPosition, canvasSize);
    if (regionId == null) {
      return;
    }
    final Color? oldColor = state.fills[regionId];
    if (oldColor == selectedColor) {
      return;
    }
    final FillCommand command = FillCommand(
      regionId: regionId,
      oldColor: oldColor,
      newColor: selectedColor,
    );
    _history.add(command);
    _apply(command);
    notifyListeners();
  }

  void undo() {
    final FillCommand? command = _history.undo();
    if (command == null) {
      return;
    }
    _apply(
      FillCommand(
        regionId: command.regionId,
        oldColor: command.newColor,
        newColor: command.oldColor,
      ),
    );
    notifyListeners();
  }

  void redo() {
    final FillCommand? command = _history.redo();
    if (command == null) {
      return;
    }
    _apply(command);
    notifyListeners();
  }

  void reset() {
    final List<FillCommand> commands = _history.reset();
    for (final FillCommand command in commands) {
      _apply(command);
    }
    if (commands.isNotEmpty) {
      notifyListeners();
    }
  }

  void _apply(FillCommand command) {
    final Map<String, Color> fills = Map<String, Color>.from(state.fills);
    _history.applyTo(fills, command);
    state = state.copyWith(fills: fills);
  }
}
