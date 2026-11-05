import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:little_doodle/app.dart';

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
}
