// /lib/pages/dashboard_page.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📊 DashboardPage - Painel de tráfego         ┃
// ┃ 🔧 Visualiza estatísticas da rede            ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../widgets/chart_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = context.watch<NetworkProvider>().devices;
    final totalTraffic = devices.fold<double>(0, (sum, d) => sum + d.trafficMbps);

    return Scaffold(
      appBar: AppBar(title: const Text('📊 Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _statTile('Dispositivos conectados', devices.length.toString()),
            _statTile('Tráfego total (Mbps)', totalTraffic.toStringAsFixed(2)),
            const SizedBox(height: 24),
            const Expanded(child: ChartWidget()), // 👈 Gráfico visual
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
