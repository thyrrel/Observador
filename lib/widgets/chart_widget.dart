// /lib/widgets/chart_widget.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📈 ChartWidget - Gráfico de tráfego por device ┃
// ┃ 🔧 Visualiza consumo em barras horizontais   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = context.watch<NetworkProvider>().devices;

    if (devices.isEmpty) {
      return const Center(child: Text('Sem dados para exibir.'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: devices.map((d) => d.trafficMbps).reduce((a, b) => a > b ? a : b) + 2,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index >= devices.length) return const SizedBox();
                return Text(devices[index].name, style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        barGroups: List.generate(devices.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: devices[i].trafficMbps,
                color: Colors.blueAccent,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}
