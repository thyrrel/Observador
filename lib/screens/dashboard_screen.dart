import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../providers/app_state.dart';
import '../models/device_model.dart';
import '../services/router_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late RouterService routerService;
  List<DeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    routerService = RouterService(); // Pode ser substituído por provider se necessário
    _loadDevices();
  }

  void _loadDevices() async {
    final provider = Provider.of<DeviceProvider>(context, listen: false);
    devices = provider.devices;
    setState(() {});
  }

  void _editDeviceName(DeviceModel device) async {
    final controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome do dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => device.name = controller.text);
              Provider.of<DeviceProvider>(context, listen: false)
                  .toggleBlockDevice(device); // Atualiza provider
              routerService.updateDevice(device); // Persistência
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(DeviceModel device) {
    IconData icon;
    switch (device.type.toLowerCase()) {
      case 'phone':
        icon = Icons.smartphone;
        break;
      case 'laptop':
        icon = Icons.laptop;
        break;
      case 'printer':
        icon = Icons.print;
        break;
      default:
        icon = Icons.devices;
    }

    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(device.name),
      subtitle: Text('${device.type} • ${device.ip}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editDeviceName(device),
          ),
          Switch(
            value: device.isBlocked,
            onChanged: (val) {
              Provider.of<DeviceProvider>(context, listen: false)
                  .toggleBlockDevice(device);
              setState(() => device.isBlocked = val);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Observador'),
        backgroundColor: appState.themeData.primaryColor,
      ),
      body: Consumer<DeviceProvider>(
        builder: (_, provider, __) {
          devices = provider.devices;
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (_, index) => _buildDeviceTile(devices[index]),
          );
        },
      ),
    );
  }
}
