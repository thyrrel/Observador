// lib/main.dart
import 'package:flutter/material.dart';
import 'services/agent_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador - Agent Final',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AgentService _agent = AgentService.instance;
  String _log = 'Pronto.';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Conecta logger do agent à UI
    _agent.setLogger((msg) {
      // atualizar estado com pequenas otimizações
      if (mounted) {
        setState(() {
          _log = msg;
        });
      }
      // também printa no console
      // ignore: avoid_print
      print(msg);
    });

    // Inicia automaticamente na primeira execução (opcional)
    _agent.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Garante parada limpa ao descartar a tela principal
    _agent.dispose();
    super.dispose();
  }

  // Se desejar, pare o agente quando o app for suspenso; aqui apenas exemplo:
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      // Não reinicia automaticamente — apenas solicita parada
      if (_agent.isRunning) _agent.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador — Agent Final')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Status: ${_agent.isRunning ? "Executando" : "Parado"}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Agente'),
              onPressed: _agent.isRunning ? null : () => _agent.start(),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Text('Parar Agente'),
              onPressed: _agent.isRunning ? () => _agent.stop() : null,
            ),
            const SizedBox(height: 20),
            const Text('Último log:'),
            const SizedBox(height: 6),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_log, style: const TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
