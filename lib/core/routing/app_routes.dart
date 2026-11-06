import 'package:flutter/material.dart';

import '../../features/coloring/screens/coloring_categories_screen.dart';
import '../../features/coloring/screens/coloring_screen.dart';
import '../../features/free_drawing/screens/free_drawing_screen.dart';
import '../../features/gallery/screens/gallery_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/parent_area/screens/parent_gate_screen.dart';
import '../../features/shared/screens/coming_soon_screen.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String coloringCategories = '/coloring';
  static const String coloring = '/coloring-page';
  static const String freeDrawing = '/free-drawing';
  static const String gallery = '/gallery';
  static const String parentArea = '/parent';
  static const String comingSoon = '/coming-soon';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case coloringCategories:
        return _page(settings, const ColoringCategoriesScreen());
      case coloring:
        return _page(settings, const ColoringScreen());
      case freeDrawing:
        return _page(settings, const FreeDrawingScreen());
      case gallery:
        return _page(settings, const GalleryScreen());
      case parentArea:
        return _page(settings, const ParentGateScreen());
      case comingSoon:
        return _page(settings, const ComingSoonScreen());
      case home:
      default:
        return _page(settings, const HomeScreen());
    }
  }

  static MaterialPageRoute<void> _page(RouteSettings settings, Widget child) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => child,
    );
  }
}
