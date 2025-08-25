import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.refreshDevices,
        child: ListView.builder(
          itemCount: provider.devices.length,
          itemBuilder: (context, index) {
            final device = provider.devices[index];
            return ListTile(
              title: Text(device.ip),
              subtitle: Text('${device.manufacturer} | ${device.mac}'),
              trailing: Switch(
                value: device.blocked,
                onChanged: (_) => provider.toggleBlock(device),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.dashboard),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        },
      ),
    );
  }
}
