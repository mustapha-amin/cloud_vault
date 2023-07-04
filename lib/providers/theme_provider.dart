import 'package:cloud_vault/services/theme_prefs.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = ThemePreference.isDark();

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    ThemePreference.saveTheme(_isDark);
    notifyListeners();
  }
}
