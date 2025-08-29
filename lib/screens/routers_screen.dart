import 'package:flutter/material.dart';
import '../services/router_service.dart';

class RoutersScreen extends StatefulWidget {
  final RouterService routerService;

  const RoutersScreen({super.key, required this.routerService});

  @override
  State<RoutersScreen> createState() => _RoutersScreenState();
}

class _RoutersScreenState extends State<RoutersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roteadores')),
      body: ListView.builder(
        itemCount: widget.routerService.routers.length,
        itemBuilder: (context, index) {
          final router = widget.routerService.routers[index];
          return Card(
            child: ListTile(
              title: Text('${router.brand} (${router.ip})'),
              subtitle: Text('Usuário: ${router.username}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'Conectar':
                      bool success = await widget.routerService.connect(router);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(success ? 'Conectado!' : 'Falha na conexão')),
                      );
                      break;
                    case 'Bloquear IP':
                      // Exemplo fixo, pode expandir para IP dinâmico
                      await widget.routerService.blockIP(router, '192.168.1.100');
                      break;
                    case 'Limitar IP':
                      await widget.routerService.limitIP(router, '192.168.1.100', 5);
                      break;
                    case 'Prioridade':
                      await widget.routerService.setHighPriority(router, '192.168.1.100');
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Conectar', child: Text('Conectar')),
                  const PopupMenuItem(value: 'Bloquear IP', child: Text('Bloquear IP')),
                  const PopupMenuItem(value: 'Limitar IP', child: Text('Limitar IP')),
                  const PopupMenuItem(value: 'Prioridade', child: Text('Prioridade')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
