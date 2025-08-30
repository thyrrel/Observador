import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(currentTheme.name),
              trailing: DropdownButton<AppTheme>(
                value: currentTheme,
                onChanged: (AppTheme? theme) {
                  if (theme != null) themeProvider.setTheme(theme);
                },
                items: AppTheme.values.map((theme) {
                  return DropdownMenuItem(
                    value: theme,
                    child: Text(theme.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => themeProvider.nextTheme(),
              child: const Text('Alternar para próximo tema'),
            ),
          ],
        ),
      ),
    );
  }
}
