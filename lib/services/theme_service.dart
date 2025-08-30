// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService {
  final StorageService _storageService = StorageService();

  Future<void> saveTheme(ThemeMode mode) async {
    await _storageService.write('theme', mode.toString());
  }

  Future<ThemeMode> loadTheme() async {
    final value = await _storageService.read('theme');
    if (value == ThemeMode.dark.toString()) return ThemeMode.dark;
    if (value == ThemeMode.light.toString()) return ThemeMode.light;
    return ThemeMode.system;
  }
}
