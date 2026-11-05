# Architecture

Phase 1 uses a small Flutter app shell. `main.dart` performs bootstrap and locks
portrait orientation; `app.dart` owns `MaterialApp`; routes are centralized in
`core/routing/app_routes.dart`. Shared design values and widgets live under
`core/`. Feature screens live under their feature folders and currently contain
only navigation placeholders.

The temporary mascot uses Flutter shapes so no network or asset dependency is
needed. Drawing, colouring data, persistence, and parent gating are intentionally
reserved for later phases.

Phase 2 drawing strokes store normalized coordinates and are rendered through
separate committed and live `CustomPainter` layers inside a `RepaintBoundary`.
After 150 committed strokes, the canvas rasterizes older strokes with
`PictureRecorder` and retains the newest 50 as vectors. Undo and redo invalidate
the cache, so the complete vector history remains available to the controller
while the active painter stays bounded.

Phase 3 parses authored SVG pages into region paths and outline paths. Touch
coordinates use the same uniform scale and letterbox offset as painting.
Regions are tested in reverse order so overlapping foreground regions win;
outlines are painted after fills.

Phase 4 uses a small asset catalog and a static in-memory page cache. Category
lists load only the visible card's SVG and reuse its parsed page when reopened.
Stickers are independent normalized overlays on the free-drawing canvas; their
positions are clamped to a safe inset so they cannot be dragged fully off-canvas.

Phase 5 stores each artwork in a private application-documents folder with
atomic temporary-file writes. JSON is versioned and tolerant of unknown fields;
corrupt entries are skipped. Preview images are rendered with
`PictureRecorder` at 1080px and 300px.

Phase 6 stores parent preferences locally with `shared_preferences`. Child
feedback uses Flutter's built-in system click sound, and the parent area is
protected by an arithmetic gate before settings are shown.
