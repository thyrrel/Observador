// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ia_network_service.dart';
import '../services/router_service.dart';
import '../providers/app_state.dart';
import '../providers/dns_provider.dart';
import 'dashboard_page.dart';
import 'network_control_page.dart';
import 'ai_assistant_page.dart';
import 'settings_page.dart';
import 'admin_page.dart'; // se existir

class HomePage extends StatelessWidget {
  final IANetworkService iaService;
  final RouterService routerService;

  const HomePage({super.key, required this.iaService, required this.routerService});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final dnsProvider = context.watch<DNSProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Observador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Visualizar dados',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(iaService: iaService),
                ),
              ),
            ),
            _buildCard(
              icon: Icons.network_check,
              title: 'Network',
              subtitle: 'Controle de rede',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NetworkControlPage(routerService: routerService, iaService: iaService),
                ),
              ),
            ),
            _buildCard(
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              subtitle: 'Assistente IA',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiAssistantPage()),
              ),
            ),
            _buildCard(
              icon: Icons.settings,
              title: 'Configurações',
              subtitle: 'Ajustes e DNS',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
            _buildCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'Painel Administrativo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blue),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
