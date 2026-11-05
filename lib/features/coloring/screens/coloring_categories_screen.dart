import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/design_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/category_tile.dart';
import '../models/coloring_asset.dart';
import '../models/coloring_page.dart';
import '../painters/coloring_painter.dart';
import '../services/coloring_asset_catalog.dart';
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
    final List<ColoringAsset> assets = const ColoringAssetCatalog().assetsFor(
      category,
    );
    if (assets.isEmpty) {
      await Navigator.pushNamed(context, AppRoutes.comingSoon);
      return;
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => _AssetListScreen(assets: assets)),
    );
  }
}

class _AssetListScreen extends StatelessWidget {
  const _AssetListScreen({required this.assets});

  final List<ColoringAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(assets.first.category)),
      body: ListView.builder(
        padding: const EdgeInsets.all(DesignConstants.pagePadding),
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          final ColoringAsset asset = assets[index];
          return _AssetCard(asset: asset);
        },
      ),
    );
  }
}

class _AssetCard extends StatefulWidget {
  const _AssetCard({required this.asset});

  final ColoringAsset asset;

  @override
  State<_AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<_AssetCard> {
  static final Map<String, ColoringPage> _pageCache = <String, ColoringPage>{};
  Future<ColoringPage?>? _pageFuture;

  @override
  void initState() {
    super.initState();
    _pageFuture = _loadPage();
  }

  Future<ColoringPage?> _loadPage() async {
    final ColoringPage? cached = _pageCache[widget.asset.id];
    if (cached != null) {
      return cached;
    }
    try {
      final String svg = await rootBundle.loadString(widget.asset.assetPath);
      final result = SvgPageParser().parse(
        svg,
        pageId: widget.asset.id,
        category: widget.asset.category,
      );
      if (result.isSuccess && result.value != null) {
        _pageCache[widget.asset.id] = result.value!;
        return result.value;
      }
    } on FlutterError {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ColoringPage?>(
      future: _pageFuture,
      builder: (BuildContext context, AsyncSnapshot<ColoringPage?> snapshot) {
        final ColoringPage? page = snapshot.data;
        return Card(
          margin: const EdgeInsets.only(bottom: DesignConstants.tileGap),
          child: InkWell(
            onTap: page == null
                ? null
                : () => Navigator.pushNamed(
                    context,
                    AppRoutes.coloring,
                    arguments: page,
                  ),
            borderRadius: BorderRadius.circular(DesignConstants.cardRadius),
            child: SizedBox(
              height: 180,
              child: page == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomPaint(
                            painter: ColoringPainter(
                              page: page,
                              fills: const <String, Color>{},
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.asset.id,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
