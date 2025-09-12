// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📈 DeviceDashboardScreen - Painel com gráfico de tráfego ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DeviceDashboardScreen extends StatelessWidget {
  final DeviceModel device;

  const DeviceDashboardScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(device, theme),
          const SizedBox(height: 12),
          _buildTrafficCard(device, theme),
          const SizedBox(height: 12),
          _buildTrafficChartCard(device),
          const SizedBox(height: 12),
          _buildActionsCard(device, theme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(DeviceModel d, ThemeData theme) {
    return Card(
      child: ListTile(
        title: Text('Informações Técnicas', style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IP: ${d.ip}'),
            Text('MAC: ${d.mac}'),
            Text('Porta: ${d.port ?? "N/A"}'),
            Text('Fabricante: ${d.manufacturer}'),
            Text('Tipo: ${d.type}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficCard(DeviceModel d, ThemeData theme) {
    return Card(
      child: ListTile(
        title: Text('Tráfego de Rede', style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recebido: ${d.rxBytes} bytes'),
            Text('Enviado: ${d.txBytes} bytes'),
            Text('Última atividade: ${d.lastSeen ?? "Desconhecida"}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficChartCard(DeviceModel d) {
    // Simulação de dados de tráfego por hora
    final List<int> hourlyRx = List.generate(24, (i) => (i * 1000 + i * i * 50) % 5000);
    final List<int> hourlyTx = List.generate(24, (i) => (i * 800 + i * 30) % 4000);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gráfico de Uso por Horário', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _TrafficChartPainter(hourlyRx, hourlyTx),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Picos destacados em vermelho (RX) e laranja (TX)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(DeviceModel d, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Ações'),
            subtitle: const Text('Controle direto do dispositivo'),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.block),
                label: const Text('Bloquear'),
                onPressed: () {
                  // TODO: Implementar bloqueio
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.speed),
                label: const Text('Limitar Banda'),
                onPressed: () {
                  // TODO: Implementar limite
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.priority_high),
                label: const Text('Priorizar'),
                onPressed: () {
                  // TODO: Implementar priorização
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrafficChartPainter extends CustomPainter {
  final List<int> rx;
  final List<int> tx;

  _TrafficChartPainter(this.rx, this.tx);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRx = Paint()..color = Colors.red..strokeWidth = 2;
    final paintTx = Paint()..color = Colors.orange..strokeWidth = 2;
    final maxRx = rx.reduce((a, b) => a > b ? a : b);
    final maxTx = tx.reduce((a, b) => a > b ? a : b);
    final maxY = (maxRx > maxTx ? maxRx : maxTx).toDouble();

    for (int i = 0; i < rx.length - 1; i++) {
      final x1 = i * size.width / 24;
      final x2 = (i + 1) * size.width / 24;
      final y1Rx = size.height - (rx[i] / maxY * size.height);
      final y2Rx = size.height - (rx[i + 1] / maxY * size.height);
      final y1Tx = size.height - (tx[i] / maxY * size.height);
      final y2Tx = size.height - (tx[i + 1] / maxY * size.height);

      canvas.drawLine(Offset(x1, y1Rx), Offset(x2, y2Rx), paintRx);
      canvas.drawLine(Offset(x1, y1Tx), Offset(x2, y2Tx), paintTx);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
