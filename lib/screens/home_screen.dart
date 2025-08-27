import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../services/network_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador - Dispositivos na Rede'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.refreshNetwork(),
          )
        ],
      ),
      body: provider.devices.isEmpty
          ? const Center(child: Text('Nenhum dispositivo detectado'))
          : ListView.builder(
              itemCount: provider.devices.length,
              itemBuilder: (context, index) {
                final device = provider.devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text('IP: ${device.ip}\nMAC: ${device.mac}'),
                  trailing: IconButton(
                    icon: Icon(device.blocked ? Icons.lock : Icons.lock_open),
                    onPressed: () => provider.toggleBlock(device),
                  ),
                );
              },
            ),
    );
  }
}
