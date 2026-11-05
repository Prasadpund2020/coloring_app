import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../controllers/drawing_controller.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/drawing_toolbar.dart';

class FreeDrawingScreen extends StatefulWidget {
  const FreeDrawingScreen({super.key});

  @override
  State<FreeDrawingScreen> createState() => _FreeDrawingScreenState();
}

class _FreeDrawingScreenState extends State<FreeDrawingScreen> {
  late final DrawingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DrawingController()..addListener(_refreshToolbar);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshToolbar)
      ..dispose();
    super.dispose();
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
          ),
        ],
      ),
    );
  }
}
