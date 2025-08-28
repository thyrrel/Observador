// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/device_service.dart';
import '../models/device_traffic.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DeviceService _deviceService = DeviceService();
  bool _loading = true;
  List<DeviceTraffic> _trafficData = [];

  @override
  void initState() {
    super.initState();
    _loadTrafficData();
  }

  Future<void> _loadTrafficData() async {
    setState(() => _loading = true);
    _trafficData = await _deviceService.getTrafficDataLast7Days();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                ColumnSeries<DeviceTraffic, String>(
                  dataSource: _trafficData,
                  xValueMapper: (DeviceTraffic data, _) => data.day,
                  yValueMapper: (DeviceTraffic data, _) => data.rxBytes,
                  name: 'Download',
                  color: Colors.blue,
                ),
                ColumnSeries<DeviceTraffic, String>(
                  dataSource: _trafficData,
                  xValueMapper: (DeviceTraffic data, _) => data.day,
                  yValueMapper: (DeviceTraffic data, _) => data.txBytes,
                  name: 'Upload',
                  color: Colors.green,
                ),
              ],
            ),
    );
  }
}
