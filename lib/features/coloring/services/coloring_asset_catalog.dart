import '../models/coloring_asset.dart';

class ColoringAssetCatalog {
  const ColoringAssetCatalog();

  List<ColoringAsset> assetsFor(String category) {
    return _assets
        .where((ColoringAsset asset) => asset.category == category)
        .toList(growable: false);
  }

  static const List<ColoringAsset> _assets = <ColoringAsset>[
    ColoringAsset(
      id: 'cartoon_bunny',
      category: 'Cartoons',
      assetPath: 'assets/coloring/cartoon_bunny.svg',
    ),
    ColoringAsset(
      id: 'cartoon_robot',
      category: 'Cartoons',
      assetPath: 'assets/coloring/cartoon_robot.svg',
    ),
    ColoringAsset(
      id: 'cartoon_monster',
      category: 'Cartoons',
      assetPath: 'assets/coloring/cartoon_monster.svg',
    ),
    ColoringAsset(
      id: 'fish',
      category: 'Animals',
      assetPath: 'assets/coloring/fish.svg',
    ),
    ColoringAsset(
      id: 'flower',
      category: 'Nature',
      assetPath: 'assets/coloring/flower.svg',
    ),
    ColoringAsset(
      id: 'house',
      category: 'Vehicles',
      assetPath: 'assets/coloring/house.svg',
    ),
  ];
}
