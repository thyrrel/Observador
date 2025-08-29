import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class NetworkControlPage extends StatelessWidget {
  final RouterService routerService;
  final IANetworkService iaService;

  NetworkControlPage({required this.routerService, required this.iaService});

  @override
  Widget build(BuildContext context) {
    var devices = iaService.devices;

    return Scaffold(
      appBar: AppBar(title: Text("Controle de Rede")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          var device = devices[index];
          return ListTile(
            title: Text('${device.name} (${device.type})'),
            subtitle: Text('MAC: ${device.mac}'),
            trailing: IconButton(
              icon: Icon(Icons.priority_high),
              onPressed: () {
                routerService.prioritizeDevice(device.mac, priority: 200);
                iaService.notify('Prioridade aplicada a ${device.name}');
              },
            ),
          );
        },
      ),
    );
  }
}
