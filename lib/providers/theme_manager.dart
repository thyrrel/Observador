// lib/providers/theme_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppTheme { Light, Dark, OLED, Matrix }

class ThemeManager extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.Light;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.Dark:
        return ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[800],
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
        );
      case AppTheme.OLED:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
        );
      case AppTheme.Matrix:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent),
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.greenAccent)),
        );
      case AppTheme.Light:
      default:
        return ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue[200]),
        );
    }
  }

  /// Carrega o tema salvo
  Future<void> loadTheme() async {
    final value = await _storage.read(key: 'app_theme');
    if (value != null) {
      _currentTheme = AppTheme.values.firstWhere(
        (e) => e.toString() == value,
        orElse: () => AppTheme.Light,
      );
    }
    notifyListeners();
  }

  /// Salva e aplica um novo tema
  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    await _storage.write(key: 'app_theme', value: theme.toString());
    notifyListeners();
  }

  /// Alterna para o próximo tema na lista
  Future<void> nextTheme() async {
    int nextIndex = (_currentTheme.index + 1) % AppTheme.values.length;
    await setTheme(AppTheme.values[nextIndex]);
  }
}
