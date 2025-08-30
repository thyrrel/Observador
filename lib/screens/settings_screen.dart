import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(appState.theme.name),
              trailing: DropdownButton<AppTheme>(
                value: appState.theme,
                onChanged: (AppTheme? newTheme) {
                  if (newTheme != null) appState.setTheme(newTheme);
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
              onPressed: () => appState.nextTheme(),
              child: const Text('Alternar para próximo tema'),
            ),
          ],
        ),
      ),
    );
  }
}
