import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/category_tile.dart';

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
            onTap: () => Navigator.pushNamed(context, AppRoutes.comingSoon),
          );
        },
      ),
    );
  }
}
