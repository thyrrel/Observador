// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../services/auth_service.dart';
import '../models/device_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NetworkService _networkService;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _networkService = NetworkService();
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }

  Future<void> _authenticateUser() async {
    bool authenticated = await _authService.authenticate();
    if (!authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha na autenticação')),
      );
    }
  }

  void _toggleBlock(DeviceModel device) {
    setState(() {
      device.isBlocked = !device.isBlocked;
    });
    // Aqui você pode integrar API do roteador para bloquear/desbloquear
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fingerprint),
            onPressed: _authenticateUser,
          ),
        ],
      ),
      body: StreamBuilder<List<DeviceModel>>(
        stream: _networkService.devicesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final devices = snapshot.data!;
          if (devices.isEmpty) {
            return const Center(child: Text('Nenhum dispositivo conectado'));
          }
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                leading: Icon(
                  device.isBlocked ? Icons.lock : Icons.wifi,
                  color: device.isBlocked ? Colors.red : Colors.green,
                ),
                title: Text(device.name),
                subtitle: Text('IP: ${device.ip}'),
                trailing: IconButton(
                  icon: Icon(
                    device.isBlocked ? Icons.lock_open : Icons.lock,
                    color: device.isBlocked ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () => _toggleBlock(device),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _networkService.scanNetwork();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
