import 'package:flutter/material.dart';

abstract final class DesignConstants {
  static const double minimumChildTarget = 64;
  static const double pagePadding = 20;
  static const double cardRadius = 24;
  static const double buttonRadius = 20;
  static const double tileGap = 12;
  static const Duration quickAnimation = Duration(milliseconds: 180);
  static const int drawingFlattenThreshold = 150;
  static const int drawingRetainedVectorStrokes = 50;
  static const double smallBrushWidth = 0.012;
  static const double mediumBrushWidth = 0.025;
  static const double largeBrushWidth = 0.05;

  static const Color ink = Color(0xFF243248);
  static const Color cream = Color(0xFFFFF8E8);
  static const Color sky = Color(0xFFE1F4FF);
  static const Color yellow = Color(0xFFFFD166);
  static const Color coral = Color(0xFFFF8A80);
  static const Color mint = Color(0xFF9BE3C2);
  static const Color lavender = Color(0xFFD8C4FF);
  static const List<Color> drawingPalette = <Color>[
    coral,
    yellow,
    mint,
    lavender,
    Color(0xFF80D8FF),
    Color(0xFFFFB74D),
    Color(0xFFE57373),
    Color(0xFF81C784),
    Color(0xFF9575CD),
    ink,
  ];
}
