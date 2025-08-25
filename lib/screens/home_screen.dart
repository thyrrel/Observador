import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/network_provider.dart';
import 'settings_screen.dart'; // Crie um settings_screen.dart básico depois

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador - Dispositivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegar para tela de configurações
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NetworkProvider>(
        builder: (context, networkProvider, _) {
          final devices = networkProvider.devices;
          if (devices.isEmpty) {
            return const Center(
              child: Text('Nenhum dispositivo encontrado.'),
            );
          }
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('${device.name} (${device.type})'),
                  subtitle: Text('IP: ${device.ip}  |  MAC: ${device.mac}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Bloquear':
                          networkProvider.blockIP(device.ip);
                          break;
                        case 'Limitar':
                          networkProvider.limitIP(device.ip);
                          break;
                        case 'Prioridade':
                          networkProvider.setHighPriority(device.ip);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Bloquear',
                        child: Text('Bloquear'),
                      ),
                      const PopupMenuItem(
                        value: 'Limitar',
                        child: Text('Limitar'),
                      ),
                      const PopupMenuItem(
                        value: 'Prioridade',
                        child: Text('Prioridade Alta'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar dispositivo de teste
          final device = DeviceModel(
            ip: '192.168.0.${DateTime.now().second}',
            mac: 'AA:BB:CC:DD:EE:${DateTime.now().second}',
            manufacturer: 'Teste',
            name: 'Dispositivo ${DateTime.now().second}',
            type: 'Smartphone',
          );
          Provider.of<NetworkProvider>(context, listen: false).addDevice(device);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
