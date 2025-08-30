import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppState>(context).themeData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador Home'),
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(
              context: context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Visualizar dados',
              route: '/dashboard',
              theme: theme,
            ),
            _buildCard(
              context: context,
              icon: Icons.network_check,
              title: 'Network',
              subtitle: 'Controle de rede',
              route: '/network',
              theme: theme,
            ),
            _buildCard(
              context: context,
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              subtitle: 'Assistente IA',
              route: '/ai_assistant',
              theme: theme,
            ),
            _buildCard(
              context: context,
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Configurações',
              route: '/settings',
              theme: theme,
            ),
            _buildCard(
              context: context,
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'Painel Admin',
              route: '/admin',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required ThemeData theme,
  }) {
    return Card(
      color: theme.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.secondary),
              const SizedBox(height: 12),
              Text(title,
                  style: theme.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle, style: theme.textTheme.bodyText2),
            ],
          ),
        ),
      ),
    );
  }
}
