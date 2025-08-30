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

  // Inicialização: carrega placeholders e tema
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

  // Carrega tema do SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('app_theme') ?? 'claro';
    _currentTheme = _stringToTheme(themeString);
  }

  // Salva tema
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
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
  // Define ou atualiza placeholder
  void setPlaceholder(String key, String value) {
    _placeholders[key] = value;
    notifyListeners();
  }

  // Retorna placeholder
  String getPlaceholder(String key, {String defaultValue = ''}) {
    return _placeholders[key] ?? defaultValue;
  }

  // Carrega placeholders de SharedPreferences
  Future<void> _loadPlaceholders() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('ph_'));
    for (final key in keys) {
      _placeholders[key.replaceFirst('ph_', '')] = prefs.getString(key) ?? '';
    }
  }

  // Salva todos os placeholders
  Future<void> savePlaceholders() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _placeholders.entries) {
      prefs.setString('ph_${entry.key}', entry.value);
    }
  }

  // ------------------ Reset / Depuração ------------------
  Future<void> clearPlaceholders() async {
    _placeholders.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('ph_')).toList();
    for (final key in keys) {
      prefs.remove(key);
    }
    notifyListeners();
  }
}
