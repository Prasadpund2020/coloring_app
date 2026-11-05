import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/design_constants.dart';
import 'parent_area_screen.dart';

class ParentGateScreen extends StatefulWidget {
  const ParentGateScreen({super.key});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  late int _firstNumber;
  late int _secondNumber;
  late int _answer;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _newQuestion() {
    final Random random = Random();
    _firstNumber = 2 + random.nextInt(8);
    _secondNumber = 2 + random.nextInt(8);
    _answer = _firstNumber + _secondNumber;
  }

  void _checkAnswer() {
    if (int.tryParse(_answerController.text.trim()) == _answer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const ParentAreaScreen(),
        ),
      );
      return;
    }
    _answerController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('That answer was not quite right.')),
    );
    setState(_newQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Check')),
      body: Center(
        child: SingleChildScrollView(
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
                    'Grown-ups only',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('What is $_firstNumber + $_secondNumber?'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _answerController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _checkAnswer(),
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: const Text('Continue'),
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
