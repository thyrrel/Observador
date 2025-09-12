// /lib/pages/home_screen.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🏠 HomeScreen - Tela inicial com rotas nomeadas ┃
// ┃ 🔧 Acesso rápido aos módulos principais       ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛰️ Observador Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _moduleCard(
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Visualizar dados',
              route: '/dashboard',
              context: context,
            ),
            _moduleCard(
              icon: Icons.network_check,
              title: 'Network',
              subtitle: 'Controle de rede',
              route: '/network',
              context: context,
            ),
            _moduleCard(
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              subtitle: 'Assistente IA',
              route: '/ai-assistant',
              context: context,
            ),
            _moduleCard(
              icon: Icons.settings,
              title: 'Configurações',
              subtitle: 'Ajustes e preferências',
              route: '/settings',
              context: context,
            ),
            _moduleCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'Painel Administrativo',
              route: '/admin',
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃ 🔹 _moduleCard - Card visual com navegação   ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Widget _moduleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blueAccent),
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
