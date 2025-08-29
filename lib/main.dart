import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/router_service.dart';
import 'services/ia_network_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  final routerService = RouterService();
  final iaService = IANetworkService(
    voiceCallback: (msg) => print('IA: $msg'),
    routerService: routerService,
  );

  await iaService.initHive();

  runApp(MyApp(routerService: routerService, iaService: iaService));
}

class MyApp extends StatelessWidget {
  final RouterService routerService;
  final IANetworkService iaService;

  const MyApp({required this.routerService, required this.iaService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardScreen(routerService: routerService, iaService: iaService),
    );
  }
}
