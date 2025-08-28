import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart'; // Descomente se Syncfusion estiver instalado

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Placeholder para dados de tráfego
  final List<DeviceTraffic> trafficData = [
    DeviceTraffic(deviceName: 'Dispositivo A', rxBytes: 1000, txBytes: 500),
    DeviceTraffic(deviceName: 'Dispositivo B', rxBytes: 2000, txBytes: 1500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Gráficos serão exibidos aqui',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: trafficData.length,
                itemBuilder: (context, index) {
                  final device = trafficData[index];
                  return ListTile(
                    title: Text(device.deviceName),
                    subtitle: Text('RX: ${device.rxBytes} bytes | TX: ${device.txBytes} bytes'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe placeholder para tráfego de dispositivos
class DeviceTraffic {
  final String deviceName;
  final int rxBytes;
  final int txBytes;

  DeviceTraffic({
    required this.deviceName,
    required this.rxBytes,
    required this.txBytes,
  });
}
