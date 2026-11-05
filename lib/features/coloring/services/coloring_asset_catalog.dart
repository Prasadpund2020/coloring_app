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
