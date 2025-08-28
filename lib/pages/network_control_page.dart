// lib/pages/network_control_page.dart
import 'package:flutter/material.dart';
import '../services/router_service.dart';

class NetworkControlPage extends StatefulWidget {
  const NetworkControlPage({Key? key}) : super(key: key);

  @override
  _NetworkControlPageState createState() => _NetworkControlPageState();
}

class _NetworkControlPageState extends State<NetworkControlPage> {
  final RouterService _routerService = RouterService();
  bool _loading = true;
  List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _loading = true);
    _devices = await _routerService.getConnectedDevices();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Rede')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(device['name'] ?? 'Desconhecido'),
                    subtitle: Text(device['ip'] ?? ''),
                    trailing: Row(
                      mainAxis
