import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/main.dart';
import 'package:vibe_ai/pages/theme_controller.dart';

void main() {
  testWidgets('Splash screen loads Music Library', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Music Library'), findsOneWidget);
  });
}
