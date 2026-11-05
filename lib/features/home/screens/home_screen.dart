import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/child_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(DesignConstants.pagePadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const _MascotPlaceholder(),
                    const SizedBox(height: 12),
                    Text(
                      'Little Doodle World',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    ChildActionButton(
                      label: 'Colouring Book',
                      icon: Icons.palette,
                      color: DesignConstants.coral,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.coloringCategories,
                      ),
                    ),
                    const SizedBox(height: DesignConstants.tileGap),
                    ChildActionButton(
                      label: 'Free Drawing',
                      icon: Icons.brush,
                      color: DesignConstants.yellow,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.freeDrawing),
                    ),
                    const SizedBox(height: DesignConstants.tileGap),
                    const ChildActionButton(
                      label: 'My Artwork',
                      icon: Icons.photo_library,
                      color: DesignConstants.mint,
                      onPressed: _showComingSoon,
                    ),
                    const SizedBox(height: DesignConstants.tileGap),
                    const ChildActionButton(
                      label: 'Stickers',
                      icon: Icons.emoji_emotions,
                      color: DesignConstants.lavender,
                      onPressed: _showComingSoon,
                    ),
                    const SizedBox(height: DesignConstants.tileGap),
                    ChildActionButton(
                      label: 'Parent Area',
                      icon: Icons.lock,
                      color: DesignConstants.sky,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.parentArea),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static void _showComingSoon() {}
}

class _MascotPlaceholder extends StatelessWidget {
  const _MascotPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Temporary mascot placeholder',
      child: Container(
        width: 140,
        height: 140,
        decoration: const BoxDecoration(
          color: DesignConstants.yellow,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.face, size: 88, color: DesignConstants.ink),
        ),
      ),
    );
  }
}
