import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData oled = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.greenAccent,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.greenAccent),
    ),
  );

  /// Tema Matrix (efeito de letrinhas + blur)
  static final ThemeData matrix = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.green,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.green, fontFamily: 'Courier'),
    ),
  );
}

class ThemeService extends ChangeNotifier {
  ThemeData _themeData = AppThemes.light;
  ThemeData get theme => _themeData;

  void setTheme(String themeName) {
    switch (themeName) {
      case "dark":
        _themeData = AppThemes.dark;
        break;
      case "oled":
        _themeData = AppThemes.oled;
        break;
      case "matrix":
        _themeData = AppThemes.matrix;
        break;
      default:
        _themeData = AppThemes.light;
    }
    notifyListeners();
  }
}
