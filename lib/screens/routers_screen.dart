// [Flutter] lib/screens/routers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../services/router_service.dart';

class RoutersScreen extends StatelessWidget {
  const RoutersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final routerService = Provider.of<RouterService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roteadores da Rede'),
        centerTitle: true,
      ),
      body: networkProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => networkProvider.loadNetworkData(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: networkProvider.routers.length,
                itemBuilder: (context, index) {
                  final router = networkProvider.routers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(router.name),
                      subtitle: Text('IP: ${router.ip} • Modelo: ${router.model}'),
                      leading: const Icon(Icons.router),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          routerService.openRouterSettings(router);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// [Flutter] lib/screens/settings_screen.dart
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(appState.theme.name),
              trailing: DropdownButton<AppTheme>(
                value: appState.theme,
                onChanged: (AppTheme? theme) {
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
