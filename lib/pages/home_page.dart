// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import 'dashboard_page.dart';
import 'network_control_page.dart';
import 'ai_assistant_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador'),
      ),
      body: ListView(
        children: [
          _buildCard(
            icon: Icons.dashboard,
            title: 'Dashboard',
            subtitle: 'Visualize tráfego de rede',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          _buildCard(
            icon: Icons.router,
            title: 'Controle de Rede',
            subtitle: 'Bloquear ou limitar dispositivos',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NetworkControlPage()),
              );
            },
          ),
          _buildCard(
            icon: Icons.smart_toy,
            title: 'Assistente IA',
            subtitle: 'Gerencie sua IA pessoal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiAssistantPage()),
              );
            },
          ),
          _buildCard(
            icon: Icons.settings,
            title: 'Configurações',
            subtitle: 'Ajuste preferências do app',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
