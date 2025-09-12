// /lib/page/device_details_page.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📋 DeviceDetailsPage - Tela de detalhes      ┃
// ┃ 🔧 Exibe dados, tráfego e ações do dispositivo ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/network_provider.dart';
import '../widgets/traffic_chart_widget.dart';

class DeviceDetailsPage extends StatelessWidget {
  final DeviceModel device;

  const DeviceDetailsPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context);
    final trafficHistory = provider._find(device.id)?.trafficHistory ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          IconButton(
            icon: Icon(
              provider.isBlocked(device.id) ? Icons.lock : Icons.lock_open,
              color: provider.isBlocked(device.id) ? Colors.red : Colors.green,
            ),
            tooltip: provider.isBlocked(device.id)
                ? 'Desbloquear dispositivo'
                : 'Bloquear dispositivo',
            onPressed: () {
              provider.toggleBlockDevice(device.id);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Informações básicas
            Text('IP: ${device.ip}', style: const TextStyle(fontSize: 16)),
            Text('MAC: ${device.mac}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // 📈 Gráfico de tráfego
            Expanded(
              child: TrafficChartWidget(history: trafficHistory),
            ),
          ],
        ),
      ),
    );
  }
}
