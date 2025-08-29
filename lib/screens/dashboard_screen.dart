import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';

class DashboardScreen extends StatelessWidget {
  final RouterService routerService;
  final IANetworkService iaService;
  final Map<String, double> deviceTraffic;

  const DashboardScreen({
    super.key,
    required this.routerService,
    required this.iaService,
    required this.deviceTraffic,
  });

  @override
  Widget build(BuildContext context) {
    final devices = routerService.connectedDevices;

    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final d = devices[index];
        final traffic = deviceTraffic[d.ip] ?? 0;
        return ListTile(
          title: Text("${d.name} (${d.type})"),
          subtitle: Text("IP: ${d.ip} | Trafego: ${traffic.toStringAsFixed(2)} Mbps"),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _renameDeviceDialog(context, d),
          ),
        );
      },
    );
  }

  void _renameDeviceDialog(BuildContext context, device) {
    final controller = TextEditingController(text: device.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Renomear dispositivo"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              iaService.renameDevice(device.mac, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ],
      ),
    );
  }
}
