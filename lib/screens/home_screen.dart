// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../services/auth_service.dart';

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
      body: StreamBuilder<List<String>>(
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
              return ListTile(
                leading: const Icon(Icons.wifi),
                title: Text(devices[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: Floating
