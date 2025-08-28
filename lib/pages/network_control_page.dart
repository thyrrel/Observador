import 'package:flutter/material.dart';

class NetworkControlPage extends StatefulWidget {
  const NetworkControlPage({super.key});

  @override
  State<NetworkControlPage> createState() => _NetworkControlPageState();
}

class _NetworkControlPageState extends State<NetworkControlPage> {
  final RouterService routerService = RouterService();

  final List<String> devices = [
    '192.168.0.10',
    '192.168.0.11',
    '192.168.0.12',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Rede')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final ip = devices[index];
          return Card(
            child: ListTile(
              title: Text('Dispositivo: $ip'),
              subtitle: const Text('Ações disponíveis:'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Prioridade Alta':
                      routerService.setHighPriority(ip);
                      break;
                    case 'Bloquear':
                      routerService.blockIP(ip);
                      break;
                    case 'Limitar':
                      routerService.limitIP(ip);
                      break;
                  }
                  setState(() {}); // Atualiza UI se necessário
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Prioridade Alta', child: Text('Prioridade Alta')),
                  const PopupMenuItem(value: 'Bloquear', child: Text('Bloquear')),
                  const PopupMenuItem(value: 'Limitar', child: Text('Limitar')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Classe placeholder para simular métodos de RouterService
class RouterService {
  void setHighPriority(String ip) {
    debugPrint('Prioridade alta definida para $ip');
  }

  void blockIP(String ip) {
    debugPrint('IP $ip bloqueado');
  }

  void limitIP(String ip) {
    debugPrint('IP $ip limitado');
  }
}
