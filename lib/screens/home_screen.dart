import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: Center(
        child: provider.loading
            ? const CircularProgressIndicator()
            : provider.networkData.isEmpty
                ? ElevatedButton(
                    onPressed: () => provider.loadNetworkData(),
                    child: const Text('Carregar Rede'),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text('Status: ${provider.networkData['status']}'),
                      Text('Wi-Fi: ${provider.networkData['wifiName']}'),
                      Text('IP: ${provider.networkData['ip']}'),
                      Text('Gateway: ${provider.networkData['gateway']}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => provider.loadNetworkData(),
                        child: const Text('Atualizar'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
