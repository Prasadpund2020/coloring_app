import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/design_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/category_tile.dart';
import '../services/svg_page_parser.dart';

class ColoringCategoriesScreen extends StatelessWidget {
  const ColoringCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<(String, IconData, Color)> categories =
        <(String, IconData, Color)>[
          ('Animals', Icons.pets, DesignConstants.coral),
          ('Fruits', Icons.apple, DesignConstants.yellow),
          ('Vehicles', Icons.directions_car, DesignConstants.sky),
          ('Shapes', Icons.category, DesignConstants.lavender),
          ('Nature', Icons.local_florist, DesignConstants.mint),
        ];

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a picture')),
      body: GridView.builder(
        padding: const EdgeInsets.all(DesignConstants.pagePadding),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisExtent: 150,
          crossAxisSpacing: DesignConstants.tileGap,
          mainAxisSpacing: DesignConstants.tileGap,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final (String label, IconData icon, Color color) = categories[index];
          return CategoryTile(
            label: label,
            icon: icon,
            color: color,
            onTap: () => _openCategory(context, label),
          );
        },
      ),
    );
  }

  Future<void> _openCategory(BuildContext context, String category) async {
    final Map<String, String> assets = <String, String>{
      'Animals': 'assets/coloring/fish.svg',
      'Fruits': 'assets/coloring/flower.svg',
      'Vehicles': 'assets/coloring/house.svg',
      'Shapes': 'assets/coloring/flower.svg',
      'Nature': 'assets/coloring/flower.svg',
    };
    try {
      final String svg = await rootBundle.loadString(assets[category]!);
      final result = SvgPageParser().parse(
        svg,
        pageId: category,
        category: category,
      );
      if (!context.mounted) {
        return;
      }
      if (result.isSuccess && result.value != null) {
        await Navigator.pushNamed(
          context,
          AppRoutes.coloring,
          arguments: result.value,
        );
      } else {
        await Navigator.pushNamed(context, AppRoutes.comingSoon);
      }
    } on FlutterError {
      if (context.mounted) {
        await Navigator.pushNamed(context, AppRoutes.comingSoon);
      }
    }
  }
}
