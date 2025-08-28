import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'network_control_page.dart';
import 'ai_assistant_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildCard(
            icon: Icons.dashboard,
            title: 'Dashboard',
            subtitle: 'Visualizar estatísticas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            },
          ),
          _buildCard(
            icon: Icons.network_wifi,
            title: 'Controle de Rede',
            subtitle: 'Gerenciar dispositivos conectados',
            onTap: ()
