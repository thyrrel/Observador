import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<NetworkProvider>(context).devices;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        children: devices.map((d) => ListTile(
          title: Text(d.ip),
          subtitle: Text('${d.manufacturer} | ${d.mac}'),
          trailing: Text(d.blocked ? 'Bloqueado' : 'Liberado'),
        )).toList(),
      ),
    );
  }
}
