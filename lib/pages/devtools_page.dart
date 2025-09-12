// /lib/pages/devtools_page.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧪 DevToolsPage - Utilitários de desenvolvimento ┃
// ┃ 🔧 Aciona scripts internos para testes/debug ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../test/test_seed.dart';
import '../../tools/watchdog.dart';
import '../../tools/cleanup.dart'; // Se quiser integrar

class DevToolsPage extends StatelessWidget {
  const DevToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧪 DevTools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔧 Utilitários disponíveis:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            _toolButton(
              label: '🐾 Rodar Watchdog',
              onPressed: () async => await Watchdog.run(),
            ),

            _toolButton(
              label: '🌱 Popular com TestSeed',
              onPressed: () {
                final provider = Provider.of<NetworkProvider>(context, listen: false);
                final seed = TestSeed.generateDevices(count: 5);
                for (final device in seed) {
                  provider.addDevice(device);
                }
              },
            ),

            _toolButton(
              label: '🧹 Rodar Cleanup',
              onPressed: () {
                // Aqui você pode chamar Cleanup.run() se quiser integrar
                print('🧹 Cleanup acionado (placeholder)');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolButton({required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.build),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
