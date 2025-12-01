import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';
import 'screens/main_tabs.dart'; // <-- create this file next

void main() {
  runApp(const VibeAIApp());
}

class VibeAIApp extends StatelessWidget {
  const VibeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vibe AI",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

