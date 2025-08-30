// [Flutter] lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ia_network_service.dart';
import '../services/router_service.dart';
import '../models/device_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final iaService = Provider.of<IANetworkService>(context);
    final routerService = Provider.of<RouterService>(context);

    final devices = iaService.devices;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          final mbpsDownload = device.rxBytes / 1024 / 1024; // MB
          final mbpsUpload = device.txBytes / 1024 / 1024; // MB

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text('${device.name} (${device.type})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MAC: ${device.mac}'),
                  Text('Download: ${mbpsDownload.toStringAsFixed(2)} MB'),
                  Text('Upload: ${mbpsUpload.toStringAsFixed(2)} MB'),
                  Text('Bloqueado: ${device.blocked ? "Sim" : "Não"}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(device.blocked ? Icons.lock : Icons.lock_open),
                    color: device.blocked ? Colors.red : Colors.green,
                    onPressed: () async {
                      if (device.blocked) {
                        await routerService.limitDevice(device.ip, device.mac, 1024);
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
            ),
          );
        },
      ),
    );
  }
}
