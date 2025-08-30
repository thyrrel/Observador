// [Flutter] lib/pages/network_control_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class NetworkControlPage extends StatelessWidget {
  const NetworkControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routerService = Provider.of<RouterService>(context);
    final iaService = Provider.of<IANetworkService>(context);

    final devices = iaService.devices;

    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Rede")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          final isBlocked = device.blocked;

          return ListTile(
            title: Text('${device.name} (${device.type})'),
            subtitle: Text('MAC: ${device.mac}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isBlocked ? Icons.lock : Icons.lock_open),
                  color: isBlocked ? Colors.red : Colors.green,
                  onPressed: () async {
                    if (isBlocked) {
                      await routerService.limitDevice(device.ip, device.mac, 1024); // exemplo de liberar
                      iaService.notify('Desbloqueio aplicado a ${device.name}');
                    } else {
                      await routerService.blockDevice(device.ip, device.mac);
                      iaService.notify('Bloqueio aplicado a ${device.name}');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.priority_high),
                  onPressed: () async {
                    await routerService.prioritizeDevice(device.ip, device.mac, priority: 200);
                    iaService.notify('Prioridade aplicada a ${device.name}');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
