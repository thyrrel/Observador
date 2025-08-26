import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/network_service.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkService = Provider.of<NetworkService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos da Rede'),
      ),
      body: networkService.devices.isEmpty
          ? const Center(child: Text('Nenhum dispositivo encontrado'))
          : ListView.builder(
              itemCount: networkService.devices.length,
              itemBuilder: (context, index) {
                final device = networkService.devices[index];
                return DeviceTile(device: device);
              },
            ),
    );
  }
}
