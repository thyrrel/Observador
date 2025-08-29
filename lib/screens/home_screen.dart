import 'package:flutter/material.dart';
import '../services/router_service.dart';
import '../services/ia_network_service.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final RouterService routerService;
  final IANetworkService iaService;

  const HomeScreen({super.key, required this.routerService, required this.iaService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> deviceTraffic = {};

  @override
  void initState() {
    super.initState();
    _initNetworkMonitoring();
  }

  void _initNetworkMonitoring() async {
    await widget.iaService.syncRouters([
      {'brand': 'TPLink', 'ip': '192.168.0.1', 'username': 'admin', 'password': 'admin'},
      {'brand': 'Huawei', 'ip': '192.168.1.1', 'username': 'admin', 'password': 'admin'},
      {'brand': 'Xiaomi', 'ip': '192.168.31.1', 'username': 'admin', 'password': 'admin'},
      {'brand': 'Asus', 'ip': '192.168.50.1', 'username': 'admin', 'password': 'admin'},
    ]);
  }

  void _updateTraffic(Map<String, double> usage) {
    setState(() {
      deviceTraffic = usage;
    });
    widget.iaService.analyzeTraffic(usage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Observador")),
      body: DashboardScreen(
        routerService: widget.routerService,
        iaService: widget.iaService,
        deviceTraffic: deviceTraffic,
      ),
    );
  }
}
