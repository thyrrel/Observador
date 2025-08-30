// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'storage_service.dart';

enum AppTheme { Light, Dark, OLED, Matrix }

class ThemeService {
  final StorageService storage = StorageService();
  AppTheme _theme = AppTheme.Light;

  AppTheme get theme => _theme;

  Future<void> loadTheme() async {
    final value = await storage.read('theme');
    if (value != null) {
      _theme = AppTheme.values.firstWhere((e) => e.toString() == value, orElse: () => AppTheme.Light);
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    _theme = theme;
    await storage.write('theme', theme.toString());
  }

  ThemeData getThemeData() {
    switch (_theme) {
      case AppTheme.Dark:
        return ThemeData.dark().copyWith(primaryColor: Colors.blueGrey);
      case AppTheme.OLED:
        return ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black, primaryColor: Colors.black, textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)));
      case AppTheme.Matrix:
        return ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black, primaryColor: Colors.black, textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.greenAccent)));
      case AppTheme.Light:
      default:
        return ThemeData.light().copyWith(primaryColor: Colors.blue);
    }
  }
}
