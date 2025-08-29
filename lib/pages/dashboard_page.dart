import 'package:flutter/material.dart';
import '../services/ia_network_service.dart';
import '../models/device_model.dart';

class DashboardPage extends StatefulWidget {
  final IANetworkService iaService;

  const DashboardPage({super.key, required this.iaService});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<DeviceModel> devices = [];
  Map<String, double> trafficUsage = {}; // Mbps

  @override
  void initState() {
    super.initState();
    devices = widget.iaService.devices;
    trafficUsage = {};
    _fetchTraffic();
  }

  Future<void> _fetchTraffic() async {
    final updatedTraffic = await widget.iaService.fetchTraffic();
    setState(() {
      trafficUsage = updatedTraffic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: RefreshIndicator(
        onRefresh: _fetchTraffic,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            final mbps = trafficUsage[device.ip] ?? 0;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(
                  device.isBlocked ? Icons.lock : Icons.devices,
                  color: device.isBlocked
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
                title: Text('${device.name} (${device.type})'),
                subtitle: Text('Uso: ${mbps.toStringAsFixed(2)} Mbps'),
                trailing: IconButton(
                  icon: Icon(
                      device.isBlocked ? Icons.lock_open : Icons.lock),
                  tooltip: device.isBlocked ? "Desbloquear" : "Bloquear",
                  onPressed: () => _toggleBlock(device),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleBlock(DeviceModel device) async {
    final success = await widget.iaService.toggleDeviceBlock(device);
    if (success) {
      setState(() {
        device.isBlocked = !device.isBlocked;
      });
    }
  }
}
