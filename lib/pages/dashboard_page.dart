import 'package:flutter/material.dart';
import 'package:observador/models/device_traffic.dart';
import 'package:observador/services/db_helper.dart';
import 'package:observador/services/pdf_report.dart';
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
    final raw = await DBHelper().last7Days();
    setState(() => _data = raw.map((e) => DeviceTraffic.fromMap(e)).toList());
  }

  /// Agrega consumo total por IP (RX + TX em MB)
  List<_ChartItem> _chartData() {
    final map = <String, double>{};
    for (final d in _data) {
      map[d.ip] = (map[d.ip] ?? 0) + (d.rxBytes + d.txBytes) / 1024 / 1024;
    }
    return map.entries.map((e) => _ChartItem(e.key, e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chart = _chartData();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('PDF'),
        onPressed: () async {
          await PdfReport.generateAndShare();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Consumo por IP (últimos 7 dias)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  ColumnSeries<_ChartItem, String>(
                    dataSource: chart,
                    xValueMapper: (_ChartItem item, _) => item.ip,
                    yValueMapper: (_ChartItem item, _) => item.mb,
                    name: 'MB',
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Detalhes por IP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...chart.map((e) => ListTile(
                  title: Text(e.ip),
                  subtitle: Text('${e.mb.toStringAsFixed(2)} MB'),
                  trailing: const Icon(Icons.info_outline),
                )),
          ],
        ),
      ),
    );
  }
}

class _ChartItem {
  final String ip;
  final double mb;
  _ChartItem(this.ip, this.mb);
}
