import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  // This holds the dark mode state
  static ValueNotifier<bool> isDark = ValueNotifier(true);

  bool get isDarkMode => isDark.value;

  void toggleTheme() {
    isDark.value = !isDark.value;
    notifyListeners();
  }

  // Proper dark theme
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

  // Proper light theme
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
}
