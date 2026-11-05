import 'dart:ui';

import 'fill_command.dart';

class ColoringHistory {
  final List<FillCommand> _commands = <FillCommand>[];
  final List<FillCommand> _redoCommands = <FillCommand>[];

  bool get canUndo => _commands.isNotEmpty;
  bool get canRedo => _redoCommands.isNotEmpty;

  void add(FillCommand command) {
    _commands.add(command);
    _redoCommands.clear();
  }

  FillCommand? undo() {
    if (_commands.isEmpty) {
      return null;
    }
    final FillCommand command = _commands.removeLast();
    _redoCommands.add(command);
    return command;
  }

  FillCommand? redo() {
    if (_redoCommands.isEmpty) {
      return null;
    }
    final FillCommand command = _redoCommands.removeLast();
    _commands.add(command);
    return command;
  }

  List<FillCommand> reset() {
    final List<FillCommand> resetCommands = <FillCommand>[];
    for (final FillCommand command in _commands.reversed) {
      if (command.newColor != null) {
        resetCommands.add(
          FillCommand(
            regionId: command.regionId,
            oldColor: command.newColor,
            newColor: null,
          ),
        );
      }
    }
    _commands.addAll(resetCommands);
    _redoCommands.clear();
    return resetCommands;
  }

  void applyTo(Map<String, Color> fills, FillCommand command) {
    final Color? color = command.newColor;
    if (color == null) {
      fills.remove(command.regionId);
    } else {
      fills[command.regionId] = color;
    }
  }
}
