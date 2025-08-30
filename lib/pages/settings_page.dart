// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dns_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final dnsProvider = context.watch<DNSProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Seção de Tema
            ListTile(
              title: const Text('Tema do Aplicativo'),
              trailing: DropdownButton<AppTheme>(
                value: appState.theme,
                onChanged: (theme) {
                  if (theme != null) appState.setTheme(theme);
                },
                items: AppTheme.values.map((theme) {
                  return DropdownMenuItem(
                    value: theme,
                    child: Text(theme.name),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Seção de DNS
            ListTile(
              title: const Text('DNS Primário'),
              subtitle: Text(dnsProvider.primaryDNS),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editDNS(context, dnsProvider, true),
              ),
            ),
            ListTile(
              title: const Text('DNS Secundário'),
              subtitle: Text(dnsProvider.secondaryDNS),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editDNS(context, dnsProvider, false),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => dnsProvider.resetDNS(),
              child: const Text('Resetar DNS para padrão'),
            ),
          ],
        ),
      ),
    );
  }

  void _editDNS(BuildContext context, DNSProvider provider, bool isPrimary) {
    final controller = TextEditingController(
      text: isPrimary ? provider.primaryDNS : provider.secondaryDNS,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isPrimary ? 'Editar DNS Primário' : 'Editar DNS Secundário'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Digite o servidor DNS'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (isPrimary) {
                  provider.setPrimaryDNS(controller.text);
                } else {
                  provider.setSecondaryDNS(controller.text);
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
