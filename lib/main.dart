import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/router_service.dart';
import 'services/ia_service.dart';
import 'services/ia_network_service.dart';
import 'screens/dashboard_screen.dart';
import 'models/device_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização dos serviços
  final routerService = RouterService();
  final iaService = IAService(
    voiceCallback: (msg) => print('IA: $msg'),
    routerService: routerService,
  );
  final iaNetworkService = IANetworkService();

  runApp(
    MultiProvider(
      providers: [
        Provider<RouterService>.value(value: routerService),
        Provider<IAService>.value(value: iaService),
        Provider<IANetworkService>.value(value: iaNetworkService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }
}
