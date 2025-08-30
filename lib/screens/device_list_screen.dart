import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos da Rede'),
      ),
      body: Consumer<DeviceProvider>(
        builder: (_, provider, __) {
          final devices = provider.devices;

          if (devices.isEmpty) {
            return const Center(child: Text('Nenhum dispositivo encontrado'));
          }

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return DeviceTile(device: device);
            },
          );
        },
      ),
    );
  }
}
