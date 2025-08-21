import 'package:flutter/material.dart';
import 'package:observador/services/db_helper.dart';
import 'package:observador/models/device_traffic.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<DeviceTraffic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await DBHelper().last24Hours();
    setState(() {
      _data = raw.map((e) => DeviceTraffic.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Agrega por IP
    final aggregated = <String, int>{};
    for (var d in _data) {
      aggregated[d.ip] = (aggregated[d.ip] ?? 0) + d.rxBytes + d.txBytes;
    }
    final chartData = aggregated.entries
        .map((e) => _ChartItem(e.key, e.value))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Tráfego total (últimas 24 h)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<_ChartItem, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartItem item, _) => item.ip,
                    yValueMapper: (_ChartItem item, _) => item.bytes,
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartItem {
  final String ip;
  final int bytes;
  _ChartItem(this.ip, this.bytes);
}
