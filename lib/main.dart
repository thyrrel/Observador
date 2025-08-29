import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/routers_screen.dart';
import 'services/router_service.dart';

void main() {
  final routerService = RouterService();
  runApp(MyApp(routerService: routerService));
}

class MyApp extends StatelessWidget {
  final RouterService routerService;

  const MyApp({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(routerService: routerService),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final RouterService routerService;

  const HomeScreen({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen(routerService: routerService)),
              ),
              child: const Text('Dashboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RoutersScreen(routerService: routerService)),
              ),
              child: const Text('Roteadores'),
            ),
          ],
        ),
      ),
    );
  }
}
