import 'package:flutter/material.dart';
import '../services/ia_network_service.dart';
import 'dashboard_page.dart';

class HomePage extends StatelessWidget {
  final IANetworkService iaService;

  const HomePage({super.key, required this.iaService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao Observador',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardPage(iaService: iaService),
                  ),
                );
              },
              icon: const Icon(Icons.dashboard),
              label: const Text('Abrir Dashboard'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder para abrir AI Assistant
                Navigator.pushNamed(context, '/ai-assistant');
              },
              icon: const Icon(Icons.smart_toy),
              label: const Text('Abrir Assistente IA'),
            ),
          ],
        ),
      ),
    );
  }
}
