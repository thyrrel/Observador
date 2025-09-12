// /lib/pages/network_control_page.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🌐 NetworkControlPage - Controle de dispositivos ┃
// ┃ 🔧 Bloqueio, liberação e priorização via router ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class NetworkControlPage extends StatelessWidget {
  const NetworkControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routerService = context.read<RouterService>();
    final iaService = context.read<IANetworkService>();
    final devices = iaService.devices;

    return Scaffold(
      appBar: AppBar(title: const Text("🌐 Controle de Rede")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, index) {
          final device = devices[index];
          return _deviceTile(device, routerService, iaService);
        },
      ),
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃ 🔹 _deviceTile - Item visual de cada device  ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Widget _deviceTile(DeviceModel device, RouterService router, IANetworkService ia) {
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
            tooltip: isBlocked ? 'Desbloquear' : 'Bloquear',
            onPressed: () async {
              if (isBlocked) {
                await router.limitDevice(device.ip, device.mac, 1024); // exemplo de liberar
                ia.notify('🔓 ${device.name} desbloqueado');
              } else {
                await router.blockDevice(device.ip, device.mac);
                ia.notify('🔒 ${device.name} bloqueado');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.priority_high),
            tooltip: 'Priorizar dispositivo',
            onPressed: () async {
              await router.prioritizeDevice(device.ip, device.mac, priority: 200);
              ia.notify('🚀 Prioridade aplicada a ${device.name}');
            },
          ),
        ],
      ),
    );
  }
}
