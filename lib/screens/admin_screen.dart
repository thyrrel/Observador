// [Flutter] lib/screens/admin_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<AppTheme>(
          value: appState.theme,
          items: AppTheme.values.map((theme) {
            return DropdownMenuItem(
              value: theme,
              child: Text(theme.name),
            );
          }).toList(),
          onChanged: (newTheme) {
            if (newTheme != null) appState.setTheme(newTheme);
          },
        ),
      ),
    );
  }
}

// [Flutter] lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late RouterService routerService;
  late IAService iaService;
  List<DeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    routerService = Provider.of<RouterService>(context, listen: false);
    iaService = Provider.of<IAService>(context, listen: false);
    _loadDevices();
    _startTrafficMonitoring();
  }

  void _loadDevices() async {
    devices = await routerService.getDevices();
    setState(() {});
    iaService.analyzeDevices(devices);
  }

  void _startTrafficMonitoring() {
    routerService.monitorTraffic((usage) {
      iaService.analyzeTraffic(devices, usage);
    });
  }

  void _editDeviceName(DeviceModel device) async {
    TextEditingController controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome do dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                device.name = controller.text;
              });
              routerService.updateDevice(device);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Observador')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text('${device.type} • ${device.ip}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editDeviceName(device),
            ),
          );
        },
      ),
    );
  }
}

// [Flutter] lib/screens/device_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos da Rede')),
      body: networkProvider.devices.isEmpty
          ? const Center(child: Text('Nenhum dispositivo encontrado'))
          : ListView.builder(
              itemCount: networkProvider.devices.length,
              itemBuilder: (context, index) {
                final device = networkProvider.devices[index];
                return DeviceTile(device: device);
              },
            ),
    );
  }
}

// [Flutter] lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Visualizar dados',
              onTap: () => Navigator.pushNamed(context, '/dashboard'),
            ),
            _buildCard(
              icon: Icons.network_check,
              title: 'Network',
              subtitle: 'Controle de rede',
              onTap: () => Navigator.pushNamed(context, '/network'),
            ),
            _buildCard(
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              subtitle: 'Assistente IA',
              onTap: () => Navigator.pushNamed(context, '/ai_assistant'),
            ),
            _buildCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Configurações',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildCard(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'Painel Admin',
              onTap: () => Navigator.pushNamed(context, '/admin'),
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

// [Flutter] lib/screens/network_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Observador - Status da Rede"),
        centerTitle: true,
      ),
      body: networkProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => networkProvider.loadNetworkData(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (networkProvider.networkData.isEmpty)
                    const Center(child: Text("Nenhum dado carregado")),
                  ...networkProvider.networkData.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: entry.value is List
                            ? Text((entry.value as List).join(", "))
                            : Text(entry.value.toString()),
                        leading: const Icon(Icons.wifi),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

// [Flutter] lib/screens/routers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../services/router_service.dart';

class RoutersScreen extends StatelessWidget {
  const RoutersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final routerService = Provider.of<RouterService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roteadores da Rede'),
        centerTitle: true,
      ),
      body: networkProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => networkProvider.loadNetworkData(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: networkProvider.routers.length,
                itemBuilder: (context, index) {
                  final router = networkProvider.routers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(router.name),
                      subtitle: Text('IP: ${router.ip} • Modelo: ${router.model}'),
                      leading: const Icon(Icons.router),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => routerService.openRouterSettings(router),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// [Flutter] lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Tema do Aplicativo'),
              subtitle: Text(appState.theme.name),
              trailing: DropdownButton<AppTheme>(
                value: appState.theme,
                onChanged: (AppTheme? theme) {
                  if (theme != null) appState.setTheme(theme);
                },
                items: AppTheme.values.map((theme) {
                  return DropdownMenuItem(
                    value: theme,
                    child: Text(theme.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => appState.nextTheme(),
              child: const Text('Alternar para próximo tema'),
            ),
          ],
        ),
      ),
    );
  }
}
