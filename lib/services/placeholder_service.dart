// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 placeholder_service.dart - Gerenciador de placeholders e tema persistente ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeType { claro, escuro, oled, matrix }

class PlaceholderService extends ChangeNotifier {
  // Singleton
  static final PlaceholderService _instance = PlaceholderService._internal();
  factory PlaceholderService() => _instance;
  PlaceholderService._internal();

  // Map de placeholders por categoria
  final Map<String, String> _placeholders = {};

  // Tema atual
  AppThemeType _currentTheme = AppThemeType.claro;
  AppThemeType get currentTheme => _currentTheme;

  // ------------------ Inicialização ------------------
  Future<void> initialize() async {
    await _loadTheme();
    await _loadPlaceholders();
  }

  // ------------------ Tema ------------------
  Future<void> setTheme(AppThemeType theme) async {
    _currentTheme = theme;
    await _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String themeString = prefs.getString('app_theme') ?? 'claro';
    _currentTheme = _stringToTheme(themeString);
  }

  Future<void> _saveTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('app_theme', _themeToString(_currentTheme));
  }

  AppThemeType _stringToTheme(String value) {
    switch (value) {
      case 'escuro':
        return AppThemeType.escuro;
      case 'oled':
        return AppThemeType.oled;
      case 'matrix':
        return AppThemeType.matrix;
      default:
        return AppThemeType.claro;
    }
  }

  String _themeToString(AppThemeType theme) {
    return theme.toString().split('.').last;
  }

  // ------------------ Placeholders ------------------
  void setPlaceholder(String key, String value) {
    _placeholders[key] = value;
    notifyListeners();
  }

  String getPlaceholder(String key, {String defaultValue = ''}) {
    return _placeholders[key] ?? defaultValue;
  }

  Future<void> _loadPlaceholders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Iterable<String> keys = prefs.getKeys().where((k) => k.startsWith('ph_'));
    for (final String key in keys) {
      _placeholders[key.replaceFirst('ph_', '')] = prefs.getString(key) ?? '';
    }
  }

  Future<void> savePlaceholders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (final MapEntry<String, String> entry in _placeholders.entries) {
      prefs.setString('ph_${entry.key}', entry.value);
    }
  }

  // ------------------ Reset / Depuração ------------------
  Future<void> clearPlaceholders() async {
    _placeholders.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> keys = prefs.getKeys().where((k) => k.startsWith('ph_')).toList();
    for (final String key in keys) {
      prefs.remove(key);
    }
    notifyListeners();
  }
}

// Sugestões
// - 🛡️ Adicionar verificação de integridade nos valores salvos (ex: evitar valores nulos)
// - 🔤 Permitir agrupamento de placeholders por contexto (ex: tela, módulo, idioma)
// - 📦 Expor stream ou ValueNotifier para integração com widgets reativos
// - 🧩 Criar método `resetTheme()` para restaurar tema padrão
// - 🎨 Integrar com animações de transição de tema para UX aprimorada

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
