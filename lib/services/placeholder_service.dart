import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { claro, escuro, oled, matrix }

class ThemeService with ChangeNotifier {
  static const String _themeKey = "app_theme";
  AppTheme _currentTheme = AppTheme.claro;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.escuro:
        return ThemeData.dark();
      case AppTheme.oled:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          backgroundColor: Colors.black,
          primaryColor: Colors.white,
          textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        );
      case AppTheme.matrix:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.greenAccent,
          textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.greenAccent,
                displayColor: Colors.greenAccent,
              ),
        );
      case AppTheme.claro:
      default:
        return ThemeData.light();
    }
  }

  ThemeService() {
    _loadTheme();
  }

  void setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeKey, theme.index);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < AppTheme.values.length) {
      _currentTheme = AppTheme.values[themeIndex];
      notifyListeners();
    }
  }
}
