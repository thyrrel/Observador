import 'package:flutter/material.dart';
import 'services/router_service.dart';
import 'services/ia_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(ObservadorApp());
}

class ObservadorApp extends StatefulWidget {
  @override
  State<ObservadorApp> createState() => _ObservadorAppState();
}

class _ObservadorAppState extends State<ObservadorApp> {
  late RouterService routerService;
  late IAService iaService;

  @override
  void initState() {
    super.initState();
    routerService = RouterService();
    iaService = IAService(
      routerService: routerService,
      voiceCallback: (msg) {
        // Aqui você pode usar TTS ou log
        print('IA: $msg');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        iaService: iaService,
        routerService: routerService,
      ),
    );
  }
}
