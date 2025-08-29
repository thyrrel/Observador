import 'package:flutter/material.dart';
import '../services/ia_network_service.dart';
import '../services/router_service.dart';
import '../models/device_model.dart';

class DashboardPage extends StatefulWidget {
  final IANetworkService iaService;

  DashboardPage({required this.iaService});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<DeviceModel> devices = [];
  Map<String, double> trafficUsage = {};

  @override
  void initState() {
    super.initState();
    // Inicializar lista de dispositivos e tráfego
    devices = widget.iaService.devices;
    trafficUsage = {}; // Será preenchido com dados reais
  }

  @override
  Widget build(BuildContext context) {
    widget.iaService.updateDevices(devices);
    widget.iaService.analyzeTraffic(trafficUsage);

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
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
