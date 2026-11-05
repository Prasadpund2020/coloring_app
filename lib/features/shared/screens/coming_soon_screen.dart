import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture coming soon')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.pagePadding),
          child: Text(
            'More colouring pictures are coming soon!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
