import 'package:flutter/material.dart';
// Imports de telas (substituir por implementações reais quando disponíveis)
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/network_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/admin_screen.dart';

void main() {
  runApp(const ObservadorApp());
}

class ObservadorApp extends StatelessWidget {
  const ObservadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/network': (context) => const NetworkScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/ai_assistant': (context) => const AiAssistantScreen(),
        '/admin': (context) => const AdminScreen(),
      },
    );
  }
}

// Placeholders para telas não implementadas ainda
// Substituir pelo código real das telas quando estiver disponível
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard Placeholder')),
    );
  }
}

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Control')),
      body: const Center(child: Text('Network Placeholder')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Placeholder')),
    );
  }
}

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: const Center(child: Text('AI Assistant Placeholder')),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: const Center(child: Text('Admin Placeholder')),
    );
  }
}
