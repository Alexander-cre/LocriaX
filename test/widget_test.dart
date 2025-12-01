import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_ai/main.dart';

void main() {
  testWidgets('Splash screen loads Vibe AI', (WidgetTester tester) async {
    await tester.pumpWidget(const VibeAIApp());

    expect(find.text('Vibe AI'), findsOneWidget);
  });
}
