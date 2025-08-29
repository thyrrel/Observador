// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  final RouterService routerService;
  final List<DeviceModel> devices;

  const DashboardScreen({Key? key, required this.routerService, required this.devices})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, double> deviceUsage = {};

  @override
  void initState() {
    super.initState();
    _simulateUsage(); // Simulação inicial (substituir por dados reais)
  }

  void _simulateUsage() {
    for (var d in widget.devices) {
      deviceUsage[d.ip] = 5.0; // 5 Mbps inicial
    }
  }

  void _prioritizeDevice(DeviceModel device) async {
    await widget.routerService.prioritizeDevice(device.mac, priority: 200);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prioridade aplicada a ${device.name}')));
  }

  void _blockDevice(DeviceModel device) async {
    await widget.routerService.blockDevice(device.mac);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${device.name} bloqueado')));
  }

  void _limitDevice(DeviceModel device) async {
    await widget.routerService.limitDevice(device.mac, 10.0);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${device.name} limitado a 10 Mbps')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Rede')),
      body: ListView.builder(
        itemCount: widget.devices.length,
        itemBuilder: (context, index) {
          var device = widget.devices[index];
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
                      _limitDevice(device);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Priorizar', child: Text('Priorizar')),
                  const PopupMenuItem(value: 'Bloquear', child: Text('Bloquear')),
                  const PopupMenuItem(value: 'Limitar', child: Text('Limitar')),
                ],
              ),
            ),
          );
        },
      ),
    );
