import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentTheme = appState.theme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: appState.themeData.primaryColor,
      ),
      backgroundColor: appState.themeData.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(currentTheme.name),
              trailing: DropdownButton<AppTheme>(
                value: currentTheme,
                onChanged: (AppTheme? newTheme) {
                  if (newTheme != null) {
                    appState.setTheme(newTheme);
                  }
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
              onPressed: () {
                // Alterna para o próximo tema da lista
                int nextIndex = (currentTheme.index + 1) % AppTheme.values.length;
                appState.setTheme(AppTheme.values[nextIndex]);
              },
              child: const Text('Alternar para próximo tema'),
            ),
          ],
        ),
      ),
    );
  }
}
