import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/audio/child_feedback.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/settings/app_settings.dart';
import '../../gallery/models/artwork.dart';
import '../../gallery/services/artwork_exporter.dart';
import '../../gallery/services/artwork_repository.dart';
import '../controllers/drawing_controller.dart';
import '../models/sticker.dart';
import '../painters/stroke_painter.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/drawing_toolbar.dart';

class FreeDrawingScreen extends StatefulWidget {
  const FreeDrawingScreen({super.key});

  @override
  State<FreeDrawingScreen> createState() => _FreeDrawingScreenState();
}

class _FreeDrawingScreenState extends State<FreeDrawingScreen>
    with WidgetsBindingObserver {
  late final DrawingController _controller;
  late final Future<ArtworkRepository> _repository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = DrawingController()..addListener(_refreshToolbar);
    _repository = ArtworkRepository.createDefault();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller
      ..removeListener(_refreshToolbar)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _controller.strokes.isNotEmpty) {
      _save();
    }
  }

  void _refreshToolbar() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free Drawing')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignConstants.cardRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: DrawingCanvas(controller: _controller),
            ),
          ),
          DrawingToolbar(
            controller: _controller,
            onHome: () => Navigator.pop(context),
            onSave: _save,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final DateTime now = DateTime.now().toUtc();
    final Artwork artwork = Artwork(
      id: '',
      type: ArtworkType.drawing,
      title: 'My drawing',
      createdAt: now,
      updatedAt: now,
      payload: <String, Object?>{
        'strokes': _controller.strokes
            .map(
              (stroke) => strokeToJson(
                points: stroke.points,
                color: stroke.color,
                width: stroke.width,
                type: stroke.type.name,
              ),
            )
            .toList(),
        'stickers': _controller.stickers
            .map(
              (Sticker sticker) => <String, Object?>{
                'assetId': sticker.assetId,
                'center': <double>[sticker.center.dx, sticker.center.dy],
                'scale': sticker.scale,
                'rotation': 0,
              },
            )
            .toList(),
      },
    );
    const ArtworkExporter exporter = ArtworkExporter();
    final List<int> preview = await exporter.render(
      StrokePainter(strokes: _controller.strokes),
      width: 1080,
      height: 1080,
    );
    final List<int> thumbnail = await exporter.render(
      StrokePainter(strokes: _controller.strokes),
      width: 300,
      height: 300,
    );
    final result = await (await _repository).save(
      artwork,
      thumbnail: thumbnail,
      preview: preview,
    );
    if (!mounted) {
      return;
    }
    final AppSettingsRepository settings = AppSettingsRepository(
      await SharedPreferences.getInstance(),
    );
    await ChildFeedback(settings).playSuccess();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess ? 'Saved!' : 'Oops! Could not save this picture.',
        ),
      ),
    );
  }
}
