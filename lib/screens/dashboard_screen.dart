import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatelessWidget {
  final List<DeviceModel> devices;
  final Map<String, double> usage;

  const DashboardScreen({Key? key, required this.devices, required this.usage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalMbps = usage.values.fold(0, (prev, val) => prev + val);

    // Ordenar dispositivos por consumo
    List<DeviceModel> sorted = List.from(devices);
    sorted.sort((a, b) => (usage[b.ip] ?? 0).compareTo(usage[a.ip] ?? 0));

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Rede')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Uso total de banda: ${totalMbps.toStringAsFixed(2)} Mbps', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final d = sorted[index];
                  double mbps = usage[d.ip] ?? 0;
                  return Card(
                    child: ListTile(
                      title: Text(d.name),
                      subtitle: Text('${d.ip} - ${d.manufacturer}'),
                      trailing: Text('${mbps.toStringAsFixed(2)} Mbps'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, _) {
                          int idx = value.toInt();
                          if (idx < sorted.length) return Text(sorted[idx].name, style: const TextStyle(fontSize: 10));
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    sorted.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [BarChartRodData(toY: usage[sorted[i].ip] ?? 0, color: Colors.blue)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
