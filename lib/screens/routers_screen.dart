// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 routers_screen.dart - Tela que exibe os roteadores da rede         ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/network_provider.dart';
import '../services/router_service.dart';

class RoutersScreen extends StatelessWidget {
  const RoutersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkProvider networkProvider = Provider.of<NetworkProvider>(context);
    final RouterService routerService = Provider.of<RouterService>(context);

    final bool isLoading = networkProvider.loading;
    final List<Router> routers = networkProvider.routers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roteadores da Rede'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await networkProvider.loadNetworkData();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routers.length,
                itemBuilder: (BuildContext context, int index) {
                  final Router router = routers[index];

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

// Sugestões
// - 🧩 Extrair o widget `ListTile` para uma função privada (`_buildRouterTile`)
// - 🛡️ Adicionar tratamento de erro em `loadNetworkData()`
// - 🔤 Validar se `router.name`, `router.ip` ou `router.model` podem ser nulos
// - 📦 Usar `Consumer` para otimizar rebuilds
// - 🎨 Adicionar ícones dinâmicos conforme status do roteador

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
