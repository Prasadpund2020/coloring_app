import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';

class ParentAreaScreen extends StatelessWidget {
  const ParentAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Area')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.pagePadding),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.lock, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Parent Area locked',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A parent gate will be added in Phase 6.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
