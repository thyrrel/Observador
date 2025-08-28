// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_helper.dart';
import '../providers/network_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Certifique-se de adicionar no pubspec.yaml

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<DeviceTraffic> devicesTraffic;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    devicesTraffic = [];
    loadTrafficData();
  }

  Future<void> loadTrafficData() async {
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    final db = DBHelper();

    // Carregar tráfego real do banco
    final trafficData = await db.last7Days(); // Certifique-se que DBHelper tem last7Days implementado corretamente
    setState(() {
      devicesTraffic = trafficData.map((data) {
        final device = networkProvider.getDeviceByMac(data.mac);
        return DeviceTraffic(
          name: device?.name ?? data.mac,
          rxBytes: data.rxBytes,
          txBytes: data.txBytes,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            ColumnSeries<DeviceTraffic, String>(
              dataSource: devicesTraffic,
              xValueMapper: (DeviceTraffic dt, _) => dt.name,
              yValueMapper: (DeviceTraffic dt, _) => dt.rxBytes,
              name: 'Recebido (Bytes)',
              color: Colors.blue,
            ),
            ColumnSeries<DeviceTraffic, String>(
              dataSource: devicesTraffic,
              xValueMapper: (DeviceTraffic dt, _) => dt.name,
              yValueMapper: (DeviceTraffic dt, _) => dt.txBytes,
              name: 'Enviado (Bytes)',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceTraffic {
  final String name;
  final int rxBytes;
  final int txBytes;

  DeviceTraffic({
    required this.name,
    required this.rxBytes,
    required this.txBytes,
  });
}
