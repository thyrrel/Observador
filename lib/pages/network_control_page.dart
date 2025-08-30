// lib/pages/network_control_page.dart
import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class NetworkControlPage extends StatelessWidget {
  final RouterService routerService;
  final IANetworkService iaService;

  const NetworkControlPage({
    super.key,
    required this.routerService,
    required this.iaService,
  });

  void _prioritizeDevice(BuildContext context, DeviceModel device) {
    routerService.prioritizeDevice(device.mac, priority: 200);
    iaService.notify('Prioridade aplicada a ${device.name}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dispositivo ${device.name} priorizado."),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devices = iaService.devices;

    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Rede")),
      body: devices.isEmpty
          ? const Center(
              child: Text(
                "Nenhum dispositivo encontrado",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.devices, color: Colors.blue[600]),
                    title: Text('${device.name} (${device.type})'),
                    subtitle: Text('MAC: ${device.mac}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.priority_high, color: Colors.orange),
                      tooltip: "Dar prioridade",
                      onPressed: () => _prioritizeDevice(context, device),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
