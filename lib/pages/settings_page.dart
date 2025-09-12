// /lib/pages/settings_page.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ ⚙️ SettingsPage - Preferências do usuário     ┃
// ┃ 🎨 Seleção de tema via ThemeManager global   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final currentTheme = themeManager.currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Configurações'),
        backgroundColor: themeManager.themeData.primaryColor,
      ),
      backgroundColor: themeManager.themeData.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('🎨 Tema do Aplicativo'),
              subtitle: Text(_label(currentTheme)),
              trailing: DropdownButton<AppTheme>(
                value: currentTheme,
                onChanged: (AppTheme? newTheme) {
                  if (newTheme != null) {
                    themeManager.setTheme(newTheme);
                  }
                },
                items: AppTheme.values.map((theme) {
                  return DropdownMenuItem(
                    value: theme,
                    child: Text(_label(theme)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.shuffle),
              label: const Text('Alternar para próximo tema'),
              onPressed: () => themeManager.nextTheme(),
            ),
          ],
        ),
      ),
    );
  }

  String _label(AppTheme theme) {
    switch (theme) {
      case AppTheme.Light:
        return '☀️ Claro';
      case AppTheme.Dark:
        return '🌙 Escuro';
      case AppTheme.OLED:
        return '🖤 OLED';
      case AppTheme.Matrix:
        return '🧪 Matrix';
    }
  }
}
