# Testing

Phase 1 widget coverage includes 320x640, 411x891, and 800x1280 layouts, plus
navigation from the home screen to colouring categories. Run `flutter test` to
execute the suite.

Phase 2 also covers tap dots, normalized coordinate validation, path smoothing,
pen/eraser history, redo clearing, clear, 1,000 strokes, and drawing-screen
gesture navigation.

Phase 3 adds the asset validator. Run `dart run tools/validate_coloring_assets.dart`
before committing SVG changes. It validates all three current pages and rejects
invalid XML, wrong viewBoxes, forbidden SVG content, duplicate IDs, open paths,
and oversized files.
