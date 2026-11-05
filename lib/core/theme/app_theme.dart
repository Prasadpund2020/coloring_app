import 'package:flutter/material.dart';

import '../constants/design_constants.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final ColorScheme colors =
        ColorScheme.fromSeed(
          seedColor: DesignConstants.coral,
          brightness: Brightness.light,
        ).copyWith(
          primary: DesignConstants.coral,
          secondary: DesignConstants.mint,
          surface: DesignConstants.cream,
          onSurface: DesignConstants.ink,
        );

    return ThemeData(
      colorScheme: colors,
      scaffoldBackgroundColor: DesignConstants.cream,
      fontFamily: 'Fredoka',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: DesignConstants.ink,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: DesignConstants.ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: DesignConstants.ink,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignConstants.cream,
        foregroundColor: DesignConstants.ink,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignConstants.buttonRadius),
          ),
        ),
      ),
    );
  }
}
