import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/audio/child_feedback.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/settings/app_settings.dart';
import '../../gallery/models/artwork.dart';
import '../../gallery/services/artwork_exporter.dart';
import '../../gallery/services/artwork_repository.dart';
import '../controllers/coloring_controller.dart';
import '../models/coloring_page.dart';
import '../painters/coloring_painter.dart';
import '../services/region_hit_tester.dart';
import '../widgets/coloring_canvas.dart';
import '../widgets/coloring_toolbar.dart';

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen>
    with WidgetsBindingObserver {
  ColoringController? _controller;
  Future<ArtworkRepository>? _repository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) {
      return;
    }
    final ColoringPage? page =
        ModalRoute.of(context)?.settings.arguments as ColoringPage?;
    if (page != null) {
      _controller = ColoringController(
        page: page,
        hitTester: const RegionHitTester(),
      );
      _repository = ArtworkRepository.createDefault();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        _controller?.state.fills.isNotEmpty == true) {
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColoringController? controller = _controller;
    if (controller == null) {
      return const Scaffold(
        body: Center(child: Text('Oops! This picture could not be opened.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(controller.page.id)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(DesignConstants.pagePadding),
              child: ColoringCanvas(controller: controller),
            ),
          ),
          ColoringToolbar(
            controller: controller,
            onHome: () => Navigator.pop(context),
            onSave: _save,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final ColoringController? controller = _controller;
    final Future<ArtworkRepository>? repositoryFuture = _repository;
    if (controller == null || repositoryFuture == null) {
      return;
    }
    try {
    final DateTime now = DateTime.now().toUtc();
    final Artwork artwork = Artwork(
      id: '',
      type: ArtworkType.coloring,
      title: controller.page.id,
      createdAt: now,
      updatedAt: now,
      payload: <String, Object?>{
        'pageId': controller.page.id,
        'fills': controller.state.fills.map(
          (String id, Color color) =>
              MapEntry<String, int>(id, color.toARGB32()),
        ),
      },
    );
    const ArtworkExporter exporter = ArtworkExporter();
    final ColoringPainter painter = ColoringPainter(
      page: controller.page,
      fills: controller.state.fills,
    );
    final List<int> preview = await exporter.render(
      painter,
      width: 1080,
      height: 1080,
    );
    final List<int> thumbnail = await exporter.render(
      painter,
      width: 300,
      height: 300,
    );
    final result = await (await repositoryFuture).save(
      artwork,
      thumbnail: thumbnail,
      preview: preview,
    );
    if (!mounted) {
      return;
    }
    if (result.isSuccess) {
      try {
        final AppSettingsRepository settings = AppSettingsRepository(
          await SharedPreferences.getInstance(),
        );
        await ChildFeedback(settings).playSuccess();
      } catch (e) {
        debugPrint('Feedback failed: $e');
      }
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess ? 'Saved! Check My Artwork' : 'Oops! Could not save this picture.',
        ),
      ),
    );
    } catch (e) {
      debugPrint('Save failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oops! Could not save this picture.')),
        );
      }
    }
  }
}
