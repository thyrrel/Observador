import 'package:flutter/material.dart';
import '../services/ia_network_service.dart';
import '../services/router_service.dart';
import 'dashboard_page.dart';

class HomePage extends StatelessWidget {
  final IANetworkService iaService;

  HomePage({required this.iaService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Observador')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardPage(iaService: iaService),
              ),
            );
          },
          child: Text('Abrir Dashboard'),
        ),
      ),
    );
  }
}
