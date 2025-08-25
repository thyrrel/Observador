import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../models/device_model.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<NetworkProvider>(
        builder: (context, network, child) {
          final devices = network.devices;
          if (devices.isEmpty) {
            return const Center(child: Text('Nenhum dispositivo conectado'));
          }
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text('${device.ip} - ${device.mac}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.lock),
                      onPressed: () => network.blockIP(device.ip),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () => network.setHighPriority(device.ip),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Exemplo: adicionar dispositivo fictício
          final newDevice = DeviceModel(
            ip: '192.168.0.100',
            mac: 'AA:BB:CC:DD:EE:FF',
            name: 'Dispositivo Fictício',
            type: 'Smart',
            manufacturer: 'Fabricante X',
          );
          Provider.of<NetworkProvider>(context, listen: false)
              .addDevice(newDevice);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
