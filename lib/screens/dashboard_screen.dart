import 'package:flutter/material.dart';
import '../services/ia_service.dart';
import '../services/router_service.dart';
import '../models/device_model.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  final IAService iaService;
  final RouterService routerService;

  const HomeScreen({required this.iaService, required this.routerService, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DeviceModel> devices = [];
  late Box deviceBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  void _initHive() async {
    deviceBox = await Hive.openBox('devices');
    _loadDevices();
  }

  void _loadDevices() {
    List stored = deviceBox.values.toList();
    setState(() {
      devices = stored.isNotEmpty ? stored.cast<DeviceModel>() : [];
    });
    widget.iaService.analyzeDevices(devices);
  }

  void _updateDeviceName(DeviceModel device, String newName) {
    setState(() {
      device.name = newName;
      deviceBox.put(device.mac, device);
    });
  }

  void _updateTraffic(Map<String, double> usage) {
    widget.iaService.analyzeTraffic(devices, usage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: TextField(
              controller: TextEditingController(text: device.name),
              decoration: InputDecoration(labelText: 'Nome do dispositivo'),
              onSubmitted: (value) => _updateDeviceName(device, value),
            ),
            subtitle: Text('${device.type} - ${device.ip}'),
            trailing: IconButton(
              icon: Icon(Icons.speed),
              onPressed: () {
                // Priorizar dispositivo via RouterService
                widget.routerService.prioritizeDevice(device.mac, priority: 200);
              },
            ),
          );
        },
      ),
    );
  }
}
