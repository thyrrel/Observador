import 'package:flutter/material.dart';
import '../services/router_service.dart';

class DashboardScreen extends StatefulWidget {
  final RouterService routerService;

  const DashboardScreen({super.key, required this.routerService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> activeIPs = [];
  bool scanning = false;

  void scanNetwork() async {
    setState(() => scanning = true);
    final ips = await widget.routerService.scanNetwork('192.168.1');
    setState(() {
      activeIPs = ips;
      scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanning ? null : scanNetwork,
            child: Text(scanning ? 'Escaneando...' : 'Escanear Rede'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activeIPs.length,
              itemBuilder: (context, index) {
                final ip = activeIPs[index];
                return ListTile(
                  title: Text(ip),
                  subtitle: Text('Dispositivo ativo'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
