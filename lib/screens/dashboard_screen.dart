// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  final RouterService routerService;
  final IAService iaService;

  const DashboardScreen({
    Key? key,
    required this.routerService,
    required this.iaService,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DeviceModel> devices = [];
  Map<String, double> deviceUsage = {};

  @override
  void initState() {
    super.initState();
    _initDevices();
  }

  Future<void> _initDevices() async {
    // Obtém os dispositivos reais do RouterService
    devices = await widget.routerService.getDevices();
    for (var d in devices) {
      deviceUsage[d.ip] = 0;
    }
    _updateTraffic();
    // IA analisa dispositivos
    widget.iaService.analyzeDevices(devices);
  }

  Future<void> _updateTraffic() async {
    for (var d in devices) {
      double mbps = await widget.routerService.getDeviceTraffic(d.mac);
      deviceUsage[d.ip] = mbps;
    }
    // IA analisa o tráfego real e sugere ações
    widget.iaService.analyzeTraffic(devices, deviceUsage);
    setState(() {});
    // Atualiza continuamente a cada 5 segundos
    Future.delayed(const Duration(seconds: 5), _updateTraffic);
  }

  void _prioritizeDevice(DeviceModel device) async {
    await widget.routerService.prioritizeDevice(device.mac, priority: 200);
  }

  void _blockDevice(DeviceModel device) async {
    await widget.routerService.blockDevice(device.mac);
  }

  void _limitDevice(DeviceModel device, double limitMbps) async {
    await widget.routerService.limitDevice(device.mac, limitMbps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Rede')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          var device = devices[index];
          double usage = deviceUsage[device.ip] ?? 0;
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(device.name),
              subtitle: Text('${device.type} • ${device.ip} • ${usage.toStringAsFixed(1)} Mbps'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Priorizar':
                      _prioritizeDevice(device);
                      break;
                    case 'Bloquear':
                      _blockDevice(device);
                      break;
                    case 'Limitar':
                      _limitDevice(device, 10.0);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Priorizar', child: Text('Priorizar')),
                  const PopupMenuItem(value: 'Bloquear', child: Text('Bloquear')),
                  const PopupMenuItem(value: 'Limitar', child: Text('Limitar 10 Mbps')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
