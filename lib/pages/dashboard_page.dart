import 'package:flutter/material.dart';
import '../services/ia_network_service.dart';
import '../services/router_service.dart';
import '../models/device_model.dart';

class DashboardPage extends StatelessWidget {
  final IANetworkService iaService;

  const DashboardPage({super.key, required this.iaService});

  @override
  Widget build(BuildContext context) {
    var devices = iaService.devices;
    Map<String, double> trafficUsage = {}; // preencher com dados reais se disponível

    iaService.updateDevices(devices);
    iaService.analyzeTraffic(trafficUsage);

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          var device = devices[index];
          double mbps = trafficUsage[device.ip] ?? 0;
          return ListTile(
            title: Text('${device.name} (${device.type})'),
            subtitle: Text('Uso: $mbps Mbps'),
          );
        },
      ),
    );
  }
}
