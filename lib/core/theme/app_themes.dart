import 'package:flutter/material.dart';
import '../flavor/flavor_config.dart';

class AppThemes {
  static ThemeData get lightTheme {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.agritel:
        return _agritelLightTheme;
      case Flavor.niagara:
        return _niagaraLightTheme;
    }
  }

  static ThemeData get darkTheme {
    switch (FlavorConfig.instance.flavor) {
      case Flavor.agritel:
        return _agritelDarkTheme;
      case Flavor.niagara:
        return _niagaraDarkTheme;
    }
  }

  // Agritel Theme Variants
  static final ThemeData _agritelLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    appBarTheme: AppBarTheme(backgroundColor: Colors.green[600]),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
    ),
  );

  static final ThemeData _agritelDarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(primary: Colors.green),
  );

  // Niagara Theme Variants
  static final ThemeData _niagaraLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(backgroundColor: Colors.blue[600]),
  );

  static final ThemeData _niagaraDarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(primary: Colors.blue),
  );
}
