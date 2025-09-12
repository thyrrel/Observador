// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🛠️ AdminScreen - Tela de seleção de tema do app ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<AppTheme>(
          value: appState.theme,
          items: AppTheme.values.map((theme) {
            return DropdownMenuItem(
              value: theme,
              child: Text(theme.name),
            );
          }).toList(),
          onChanged: (newTheme) {
            if (newTheme != null) appState.setTheme(newTheme);
          },
        ),
      ),
    );
  }
}
