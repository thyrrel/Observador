import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import '../services/network_service.dart';
import '../providers/network_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NetworkService _networkService;
  String _statusText = "Checando conexão...";

  @override
  void initState() {
    super.initState();
    _networkService = NetworkService();

    // Inicia monitoramento contínuo
    _networkService.startMonitoring();
    _networkService.initBackgroundFetch();

    // Escuta mudanças de conexão
    _networkService.connectionStream.listen((connected) {
      setState(() {
        _statusText = connected ? "Conectado à Internet" : "Sem conexão";
      });

      // Notificação quando houver mudança
      NotificationService().showNotification(
        "Status de Rede",
        _statusText,
      );
    });

    // Autenticação biométrica ao abrir o app
    AuthService().authenticate();
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
      ),
      body: Center(
        child: Text(
          _statusText,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
