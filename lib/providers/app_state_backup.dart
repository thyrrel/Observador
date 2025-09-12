// /lib/providers/app_state.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 AppState - Estado global do tema visual    ┃
// ┃ 🎨 Gerencia tema + persistência via storage ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 🎨 Enum com os 4 temas disponíveis
enum AppTheme { Light, Dark, OLED, Matrix }

class AppState extends ChangeNotifier {
  AppTheme _theme = AppTheme.Light;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AppTheme get theme => _theme;

  /// 🎨 Retorna o ThemeData correspondente ao tema atual
  ThemeData get themeData {
    switch (_theme) {
      case AppTheme.Dark:
        return ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.blueGrey.shade700,
            secondary: Colors.cyan.shade300,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black87),
        );

      case AppTheme.OLED:
        return ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white70),
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        );

      case AppTheme.Matrix:
        return ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Colors.greenAccent,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.greenAccent),
            bodyMedium: TextStyle(color: Colors.greenAccent),
            bodySmall: TextStyle(color: Colors.greenAccent),
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        );

      case AppTheme.Light:
      default:
        return ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.lightBlue.shade200,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        );
    }
  }

  /// 📦 Carrega o tema salvo no armazenamento seguro
  Future<void> loadTheme() async {
    final value = await _storage.read(key: 'theme');
    if (value != null) {
      _theme = AppTheme.values.firstWhere(
        (e) => e.toString() == value,
        orElse: () => AppTheme.Light,
      );
    }
    notifyListeners();
  }

  /// 💾 Atualiza o tema e salva no armazenamento
  Future<void> setTheme(AppTheme newTheme) async {
    _theme = newTheme;
    await _storage.write(key: 'theme', value: newTheme.toString());
    notifyListeners();
  }
}
