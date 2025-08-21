import 'package:flutter/material.dart';
import 'package:observador/services/router_service.dart';

class NetworkControlPage extends StatefulWidget {
  const NetworkControlPage({super.key});

  @override
  State<NetworkControlPage> createState() => _NetworkControlPageState();
}

class _NetworkControlPageState extends State<NetworkControlPage> {
  final devices = ['192.168.1.120', '192.168.1.137', '192.168.1.166'];
  final _limits = <String, int?>{}; // kbit ou null = sem limite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QoS & Controle')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final ip = devices[i];
          final limit = _limits[ip];
          return Card(
            child: ExpansionTile(
              title: Text('IP $ip'),
              children: [
                ListTile(
                  leading: const Icon(Icons.bolt),
                  title: const Text('Dar prioridade alta'),
                  onTap: () async {
                    await RouterService.setHighPriority(ip);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Prioridade alta para $ip')));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.speed),
                  title: const Text('Limitar banda'),
                  subtitle: limit == null
                      ? null
                      : Text('${limit} kbit/s'),
                  onTap: () => _showLimitDialog(ip),
                ),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Bloquear'),
                  onTap: () async {
                    await RouterService.blockIP(ip);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$ip bloqueado')));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLimitDialog(String ip) {
    final ctrl = TextEditingController(text: _limits[ip]?.toString() ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Limite para $ip (kbit/s)'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '512'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final kbit = int.tryParse(ctrl.text) ?? 0;
              if (kbit > 0) {
                await RouterService.limitIP(ip, kbit);
                setState(() => _limits[ip] = kbit);
              }
              Navigator.pop(context);
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}
