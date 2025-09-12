// /lib/providers/theme_provider.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🎨 ThemeProvider - Alternância entre temas claro/escuro ┃
// ┃ 🔄 Reativo via ChangeNotifier para uso com Provider ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  /// 🔄 Alterna entre tema claro e escuro
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// 🎨 Retorna o ThemeData correspondente
  ThemeData get themeData => _isDark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);
}
