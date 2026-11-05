import 'dart:ui';

class ColoringRegion {
  const ColoringRegion({required this.id, required this.path});

  final String id;
  final Path path;
}

class ColoringPage {
  const ColoringPage({
    required this.id,
    required this.category,
    required this.viewBox,
    required this.regions,
    required this.outlines,
  });

  final String id;
  final String category;
  final Size viewBox;
  final List<ColoringRegion> regions;
  final List<Path> outlines;
}
