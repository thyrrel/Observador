import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late RouterService routerService;
  late IAService iaService;
  List<DeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    routerService = Provider.of<RouterService>(context, listen: false);
    iaService = Provider.of<IAService>(context, listen: false);

    _loadDevices();
    _startTrafficMonitoring();
  }

  void _loadDevices() async {
    devices = await routerService.getDevices(); // Tráfego real
    setState(() {});
    iaService.analyzeDevices(devices);
  }

  void _startTrafficMonitoring() {
    routerService.monitorTraffic((usage) {
      iaService.analyzeTraffic(devices, usage);
    });
  }

  void _editDeviceName(DeviceModel device) async {
    TextEditingController controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome do dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                device.name = controller.text;
              });
              routerService.updateDevice(device);
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
        itemBuilder: (_, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text('${device.type} • ${device.ip}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editDeviceName(device),
            ),
          );
        },
      ),
    );
  }
}
