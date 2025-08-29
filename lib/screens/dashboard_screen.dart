import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  final RouterService routerService;
  final IANetworkService iaService;

  const DashboardScreen({required this.routerService, required this.iaService, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    _initializeDevices();
  }

  Future<void> _initializeDevices() async {
    // Exemplo para um roteador TP-Link, pode ser iterado para múltiplos
    await widget.iaService.integrateRouter('tplink', '192.168.0.1');
    setState(() {
      devices = widget.iaService.devices;
    });
  }

  Future<void> _renameDevice(DeviceModel device) async {
    final controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Renomear Dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await widget.iaService.renameDevice(device.mac, controller.text);
              setState(() {
                devices = widget.iaService.devices;
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Observador')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text('${device.type} - ${device.ip}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _renameDevice(device),
            ),
          );
        },
      ),
    );
  }
}
