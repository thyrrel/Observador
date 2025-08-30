// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            title: const Text('Tema do Aplicativo'),
            subtitle: Text(_themeLabel(theme)),
            trailing: DropdownButton<AppTheme>(
              value: theme,
              onChanged: (newTheme) {
                if (newTheme != null) {
                  appState.setTheme(newTheme);
                }
              },
              items: AppTheme.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(_themeLabel(mode)),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _themeLabel(AppTheme mode) {
    switch (mode) {
      case AppTheme.Light:
        return 'Claro';
      case AppTheme.Dark:
        return 'Escuro';
      case AppTheme.OLED:
        return 'OLED';
      case AppTheme.Matrix:
        return 'Matrix';
      default:
        return '';
    }
  }
}
