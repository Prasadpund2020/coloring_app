import 'dart:ui';

class ColoringState {
  const ColoringState({this.fills = const <String, Color>{}});

  final Map<String, Color> fills;

  ColoringState copyWith({Map<String, Color>? fills}) {
    return ColoringState(
      fills: Map<String, Color>.unmodifiable(fills ?? this.fills),
    );
  }
}
