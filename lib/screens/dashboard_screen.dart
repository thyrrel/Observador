import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';
import '../services/ia_service.dart';
import '../services/router_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NetworkService _networkService = NetworkService();
  final IAService _iaService = IAService(
    voiceCallback: (message) => print("Voz IA: $message"), // integrar TTS
  );

  List<DeviceModel> devices = [];
  Map<String, double> usageMbps = {}; // Consumo por IP
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => loading = true);

    // Detecta gateway e dispositivos
    String? gateway = await _networkService.getGatewayIP();
    if (gateway != null) {
      String subnet = gateway.substring(0, gateway.lastIndexOf('.'));
      devices = await _networkService.scanNetwork(subnet);

      // Simulação de consumo por dispositivo (em Mbps)
      for (var device in devices) {
        usageMbps[device.ip] = (5 + (50 * (device.mac.hashCode % 10) / 10));
      }

      // IA analisa dispositivos suspeitos e consumo
      _iaService.analyzeDevices(devices);
      _iaService.analyzeTraffic(devices, usageMbps);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador - Dashboard')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Dispositivos conectados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final d = devices[index];
                      return ListTile(
                        title: Text('${d.name} (${d.type})'),
                        subtitle: Text('${d.ip} | ${d.mac} | ${d.manufacturer}'),
                        trailing: Text('${usageMbps[d.ip]?.toStringAsFixed(1)} Mbps'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Consumo de Rede (Top 5)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 200,
                    child: charts.BarChart(
                      [
                        charts.Series<DeviceModel, String>(
                          id: 'Consumo',
                          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (DeviceModel d, _) => d.name,
                          measureFn: (DeviceModel d, _) => usageMbps[d.ip],
                          data: devices..sort((a,b) => (usageMbps[b.ip] ?? 0).compareTo(usageMbps[a.ip] ?? 0)),
                        )
                      ],
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Atividades suspeitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _iaService.analyzeDevices(devices).length,
                    itemBuilder: (context, index) {
                      final suspicious = _iaService.analyzeDevices(devices)[index];
                      return ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: Text(suspicious.name),
                        subtitle: Text('${suspicious.ip} | ${suspicious.mac}'),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
