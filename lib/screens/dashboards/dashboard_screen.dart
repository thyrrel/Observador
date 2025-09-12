// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 DashboardScreen - Visualização e navegação por dispositivos ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../providers/app_state.dart';
import '../models/device_model.dart';
import 'device_dashboard_screen.dart'; // Mini-dashboard por dispositivo

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
    _refreshDevices();
    _startTrafficMonitoring();
  }

  void _refreshDevices() async {
    final result = await routerService.getDevices();
    if (!mounted) return;
    setState(() => devices = result);
    iaService.analyzeDevices(devices);
  }

  void _startTrafficMonitoring() {
    routerService.monitorTraffic((usage) {
      iaService.analyzeTraffic(devices, usage);
      if (mounted) setState(() {});
    });
  }

  Future<void> _editDeviceName(DeviceModel device) async {
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
              routerService.updateDevice(device);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(DeviceModel device, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(device.name, style: theme.textTheme.bodyLarge),
        subtitle: Text('${device.type} • ${device.ip}', style: theme.textTheme.bodyMedium),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          color: theme.colorScheme.secondary,
          onPressed: () => _editDeviceName(device),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeviceDashboardScreen(device: device),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).themeData;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Observador')),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: devices.isEmpty
          ? Center(
              child: Text(
                'Nenhum dispositivo encontrado',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (_, index) => _buildDeviceTile(devices[index], theme),
            ),
    );
  }
}
