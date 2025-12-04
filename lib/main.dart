import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'package:vibe_ai/screens/main_tabs.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MainTabs(), // ✅ Launch MainTabs with bottom nav
    );
  }
}
