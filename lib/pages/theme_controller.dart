import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  /// This is the actual state used globally
  static ValueNotifier<bool> isDark = ValueNotifier(true);

  /// Optional getter
  bool get isDarkMode => isDark.value;

  /// Toggle theme function
  void toggleTheme() {
    isDark.value = !isDark.value;
    notifyListeners();
  }
}
