import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Certifique-se de adicionar no pubspec.yaml
import '../models/device_traffic.dart';
import '../services/db_helper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<DeviceTraffic> deviceTraffic = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _loadData();
  }
