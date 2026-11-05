import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:little_doodle/app.dart';
import 'package:little_doodle/features/free_drawing/widgets/drawing_canvas.dart';

void main() {
  testWidgets('home fits a small phone', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(const LittleDoodleApp());

    expect(find.text('Little Doodle World'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('home fits a tablet', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1280));
    await tester.pumpWidget(const LittleDoodleApp());

    expect(find.text('Colouring Book'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('colouring categories open from home', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 891));
    await tester.pumpWidget(const LittleDoodleApp());

    await tester.tap(find.text('Colouring Book'));
    await tester.pumpAndSettle();

    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Nature'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('category lists a real cached coloring page', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 891));
    await tester.pumpWidget(const LittleDoodleApp());

    await tester.tap(find.text('Colouring Book'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Animals'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('fish'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('free drawing records a gesture and exposes controls', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 891));
    await tester.pumpWidget(const LittleDoodleApp());

    await tester.tap(find.text('Free Drawing'));
    await tester.pumpAndSettle();
    expect(find.byType(DrawingCanvas), findsOneWidget);
    expect(find.bySemanticsLabel('Undo'), findsOneWidget);

    await tester.drag(find.byType(DrawingCanvas), const Offset(80, 80));
    await tester.pump();
    expect(find.bySemanticsLabel('Undo'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('parent area is protected by a parent check', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 891));
    await tester.pumpWidget(const LittleDoodleApp());

    await tester.tap(find.text('Parent Area'));
    await tester.pumpAndSettle();

    expect(find.text('Grown-ups only'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });
}
