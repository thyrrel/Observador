import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatelessWidget {
  final List<DeviceModel> devices;
  final Map<String, double> usage;

  const DashboardScreen({Key? key, required this.devices, required this.usage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalMbps = usage.values.fold(0, (prev, val) => prev + val);

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
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final d = devices[index];
                  double mbps = usage[d.ip] ?? 0;
                  return ListTile(
                    title
