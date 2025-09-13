import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = AppThemes.lightTheme;
  bool _isDark = false;

  ThemeData get theme => _theme;
  bool get isDark => _isDark;

  void loadTheme({bool darkMode = false}) {
    _isDark = darkMode;
    _theme = darkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }

  void toggleTheme() {
    loadTheme(darkMode: !_isDark);
  }
}
