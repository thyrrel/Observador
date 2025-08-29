import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/device_model.dart';
import '../services/ia_service.dart';
import '../services/router_service.dart';

class DashboardScreen extends StatefulWidget {
  final IAService iaService;
  final RouterService routerService;

  const DashboardScreen({required this.iaService, required this.routerService, Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<DeviceModel> deviceBox;
  List<DeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    deviceBox = Hive.box<DeviceModel>('devices');
    devices = deviceBox.values.toList();
    _listenTraffic();
  }

  void _listenTraffic() {
    // Atualização contínua simulando tráfego real (substituir por dados reais)
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        devices = deviceBox.values.toList();
        widget.iaService.analyzeTraffic(devices, _getTrafficMap());
      });
      _listenTraffic();
    });
  }

  Map<String, double> _getTrafficMap() {
    Map<String, double> usage = {};
    for (var d in devices) {
      usage[d.ip] = (d.traffic ?? 0) + (5 + (devices.indexOf(d) * 3)); // exemplo
    }
    return usage;
  }

  void _editDevice(DeviceModel device) async {
    TextEditingController nameController = TextEditingController(text: device.name);
    TextEditingController typeController = TextEditingController(text: device.type);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar dispositivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Tipo')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                device.name = nameController.text;
                device.type = typeController.text;
                device.save();
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Salvar')),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(DeviceModel device) {
    double traffic = device.traffic ?? 0;
    return ListTile(
      title: Text(device.name),
      subtitle: Text('${device.type} • IP: ${device.ip} • Tráfego: ${traffic.toStringAsFixed(1)} Mbps'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editDevice(device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    devices = deviceBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Dispositivos')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) => _buildDeviceTile(devices[index]),
      ),
    );
  }
}
