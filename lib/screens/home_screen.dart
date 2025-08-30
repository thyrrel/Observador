import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).themeData;

    return Scaffold(
      appBar: AppBar(title: const Text('Observador Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Visualizar dados',
              routeName: '/dashboard',
            ),
            _buildCard(
              context,
              icon: Icons.network_check,
              title: 'Network',
              subtitle: 'Controle de rede',
              routeName: '/network',
            ),
            _buildCard(
              context,
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              subtitle: 'Assistente IA',
              routeName: '/ai_assistant',
            ),
            _buildCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Configurações',
              routeName: '/settings',
            ),
            _buildCard(
              context,
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'Painel Admin',
              routeName: '/admin',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String routeName,
  }) {
    final theme = Provider.of<AppState>(context).themeData;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.secondary),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyText1?.color)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodyText2?.color ?? Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
