import 'package:flutter/material.dart';

import '../../features/coloring/screens/coloring_categories_screen.dart';
import '../../features/free_drawing/screens/free_drawing_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/parent_area/screens/parent_area_screen.dart';
import '../../features/shared/screens/coming_soon_screen.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String coloringCategories = '/coloring';
  static const String freeDrawing = '/free-drawing';
  static const String parentArea = '/parent';
  static const String comingSoon = '/coming-soon';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case coloringCategories:
        return _page(const ColoringCategoriesScreen());
      case freeDrawing:
        return _page(const FreeDrawingScreen());
      case parentArea:
        return _page(const ParentAreaScreen());
      case comingSoon:
        return _page(const ComingSoonScreen());
      case home:
      default:
        return _page(const HomeScreen());
    }
  }

  static MaterialPageRoute<void> _page(Widget child) {
    return MaterialPageRoute<void>(builder: (_) => child);
  }
}
