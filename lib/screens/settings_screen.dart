// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 settings_screen.dart - Tela de configurações do aplicativo         ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppTheme currentTheme = appState.theme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(currentTheme.name),
              trailing: DropdownButton<AppTheme>(
                value: currentTheme,
                onChanged: (AppTheme? selectedTheme) {
                  if (selectedTheme != null) {
                    appState.setTheme(selectedTheme);
                  }
                },
                items: AppTheme.values.map((AppTheme themeOption) {
                  return DropdownMenuItem<AppTheme>(
                    value: themeOption,
                    child: Text(themeOption.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                appState.nextTheme();
              },
              child: const Text('Alternar para próximo tema'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sugestões
// - 🧩 Extrair o Dropdown para um widget reutilizável (`ThemeSelectorWidget`)
// - 🛡️ Adicionar confirmação visual ao alternar tema
// - 🔤 Validar se `AppTheme.name` está sempre disponível
// - 🎨 Adicionar preview do tema selecionado
// - 📦 Usar `Consumer<AppState>` para rebuild mais eficiente

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
