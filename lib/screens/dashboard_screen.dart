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
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DeviceModel> devices = [];
  Map<String, double> traffic = {};

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    widget.iaService.startMonitoring(interval: Duration(seconds: 5));
    Timer.periodic(Duration(seconds: 5), (_) async {
      await _updateDevices();
    });
  }

  Future<void> _updateDevices() async {
    List<DeviceModel> devs = await widget.routerService.getDevices();
    Map<String, double> traf = {};
    for (var d in devs) {
      traf[d.mac] = await widget.routerService.getDeviceTraffic(d.mac);
    }
    setState(() {
      devices = devs;
      traffic = traf;
    });
  }

  void _blockDevice(DeviceModel d) async {
    await widget.iaService.blockDevice(d);
    await _updateDevices();
  }

  void _limitDevice(DeviceModel d, double mbps) async {
    await widget.iaService.limitDevice(d, mbps);
    await _updateDevices();
  }

  void _prioritizeDevice(DeviceModel d, int priority) async {
    await widget.iaService.prioritizeDevice(d, priority);
    await _updateDevices();
  }

  Widget _buildDeviceTile(DeviceModel d) {
    double mbps = traffic[d.mac] ?? 0;
    return Card(
      child: ListTile(
        title: Text(d.name),
        subtitle: Text('${d.type} - ${d.manufacturer}\nBanda: ${mbps.toStringAsFixed(2)} Mbps'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'Bloquear':
                _blockDevice(d);
                break;
              case 'Limitar':
                _limitDevice(d, 20); // exemplo fixo
                break;
              case 'Priorizar':
                _prioritizeDevice(d, 200); // exemplo fixo
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'Bloquear', child: Text('Bloquear')),
            PopupMenuItem(value: 'Limitar', child: Text('Limitar 20 Mbps')),
            PopupMenuItem(value: 'Priorizar', child: Text('Priorizar 200')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard de Rede'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateDevices,
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            return _buildDeviceTile(devices[index]);
          },
        ),
      ),
    );
  }
}
