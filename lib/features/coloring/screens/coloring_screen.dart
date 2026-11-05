import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../controllers/coloring_controller.dart';
import '../models/coloring_page.dart';
import '../services/region_hit_tester.dart';
import '../widgets/coloring_canvas.dart';
import '../widgets/coloring_toolbar.dart';

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  ColoringController? _controller;

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
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
          ),
        ],
      ),
    );
  }
}
