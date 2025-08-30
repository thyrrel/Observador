// lib/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppThemeMode _themeMode = AppThemeMode.system;
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await _themeService.load();
    setState(() {
      _themeMode = mode ?? AppThemeMode.system;
    });
  }

  Future<void> _saveTheme(AppThemeMode mode) async {
    await _themeService.save(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            title: const Text('Tema do Aplicativo'),
            subtitle: Text(_themeMode.label),
            trailing: DropdownButton<AppThemeMode>(
              value: _themeMode,
              onChanged: (mode) async {
                if (mode != null) {
                  setState(() => _themeMode = mode);
                  await _saveTheme(mode);
                }
              },
              items: AppThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.label),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔑 Enum personalizado para os 4 temas
enum AppThemeMode { system, light, dark, oled, matrix }

extension AppThemeModeExtension on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.system:
        return "Sistema";
      case AppThemeMode.light:
        return "Claro";
      case AppThemeMode.dark:
        return "Escuro";
      case AppThemeMode.oled:
        return "OLED";
      case AppThemeMode.matrix:
        return "Matrix";
    }
  }
}

/// 🔑 Serviço para salvar e carregar preferências
class ThemeService {
  Future<AppThemeMode?> load() async {
    // Aqui pode carregar do SharedPreferences (simulado)
    return AppThemeMode.system;
  }

  Future<void> save(AppThemeMode mode) async {
    // Aqui pode salvar no SharedPreferences (simulado)
    debugPrint('Tema salvo: ${mode.label}');
  }
}
