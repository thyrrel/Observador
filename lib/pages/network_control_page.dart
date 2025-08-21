import 'package:flutter/material.dart';

class NetworkControlPage extends StatefulWidget {
  const NetworkControlPage({super.key});

  @override
  State<NetworkControlPage> createState() => _NetworkControlPageState();
}

class _NetworkControlPageState extends State<NetworkControlPage> {
  final Map<String, bool> _blocked = {};

  @override
  Widget build(BuildContext context) {
    final devices = ['192.168.1.120', '192.168.1.137', '192.168.1.166'];

    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Rede')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final ip = devices[index];
          final bloqueado = _blocked[ip] ?? false;
          return Card(
            child: ListTile(
              leading: Icon(
                bloqueado ? Icons.wifi_off : Icons.wifi,
                color: bloqueado ? Colors.red : Colors.green,
              ),
              title: Text('IP $ip'),
            subtitle: Text(bloqueado ? 'Bloqueado' : 'Liberado'),
          trailing: Switch(
            value: bloqueado,
              onChanged: (value) async {
               setState(() => _blocked[ip] = value);
  value
      ? await RouterService.blockIP(ip)
      : await RouterService.unblockIP(ip);
},

                  // aqui futuramente chamará o método real de bloqueio
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
