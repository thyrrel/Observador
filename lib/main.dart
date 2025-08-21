import 'pages/home_page.dart';   // adicione essa linha no topo
 'package:flutter/material.dart';

void main() {
  runApp(const ObservadorApp());
}

class ObservadorApp extends StatelessWidget {
  const ObservadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hub Observador')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Card(
            icon: Icons.speed,
            title: 'Dashboard de Banda',
            subtitle: 'Veja quem está usando a rede agora',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Placeholder())),
          ),
          _Card(
            icon: Icons.network_check,
            title: 'Controle de Rede',
            subtitle: 'Bloqueie ou dê prioridade',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Placeholder())),
          ),
          _Card(
            icon: Icons.assistant,
            title: 'Assistente IA',
            subtitle: 'Sugestões automáticas',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Placeholder())),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _Card(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
