import 'package:flutter/material.dart';

class AppThemes {
  // keys used in FlavorConfig.values.themeKey
  static const String niagara = 'niagara';
  static const String agritel = 'agritel';

  static ThemeData themeFor(String key) {
    switch (key) {
      case niagara:
        return ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(
            secondary: Colors.pinkAccent,
          ),
        );
      case agritel:
      default:
        return ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
          colorScheme:
          ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.orangeAccent),
        );
    }
  }
}