import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/router_service.dart';
import 'services/ia_network_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RouterService routerService = RouterService();
  late final IANetworkService iaService;

  MyApp({super.key}) {
    iaService = IANetworkService(
      routerService: routerService,
      voiceCallback: (msg) {
        // Aqui pode ser TTS ou print simples
        print("IA: $msg");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData.dark(),
      home: HomeScreen(
        routerService: routerService,
        iaService: iaService,
      ),
    );
  }
}
