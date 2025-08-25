import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService _networkService = NetworkService();
  late RouterService _routerService;
  late IAService _iaService;
  final FlutterTts _flutterTts = FlutterTts();

  List<DeviceModel> devices = [];
  Map<String, double> usageMbps = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();

    // Configurar RouterService (substitua IP e token reais)
    _routerService = RouterService(routerIP: '192.168.0.1', token: 'SEU_TOKEN');

    // Configurar IAService com TTS
    _iaService = IAService(
      voiceCallback: (message) async {
        print("IA Alert: $message");
        await _flutterTts.speak(message);
      },
    );

    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => loading = true);

    String? gateway = await _networkService.getGatewayIP();
    if (gateway != null) {
      String subnet = gateway.substring(0, gateway.lastIndexOf('.'));
      devices = await _networkService.scanNetwork(subnet);

      // Simulação de uso de banda (em Mbps)
      for (var device in devices) {
        usageMbps[device.ip] = (5 + (50 * (device.mac.hashCode % 10) / 10));
      }

      // IA analisa dispositivos suspeitos e consumo
      _iaService.analyzeDevices(devices);
      _iaService.analyzeTraffic(devices, usageMbps);
    }

    setState(() => loading = false);
  }

  Future<void> _toggleBlock(DeviceModel device) async {
    bool success = false;
    if (device.isBlocked) {
      success = await _routerService.unblockDevice(device.mac);
    } else {
      success = await _routerService.blockDevice(device.mac);
    }

    if (success) {
      setState(() {
        device.isBlocked = !device.isBlocked;
      });
      _iaService
          ._notifyVoice('${device.name} foi ${device.isBlocked ? "bloqueado" : "desbloqueado"}');
    } else {
      _iaService._notifyVoice('Falha ao alterar status de ${device.name}');
    }
  }

  Future<void> _renameDevice(DeviceModel device) async {
    TextEditingController controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Renomear dispositivo"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  device.name = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Salvar")),
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador - Home')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDevices,
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final d = devices[index];
                  return ListTile(
                    leading: Icon(d.isBlocked ? Icons.lock : Icons.lock_open,
                        color: d.isBlocked ? Colors.red : Colors.green),
                    title: Text('${d.name} (${d.type})'),
                    subtitle: Text('${d.ip} | ${d.mac} | ${d.manufacturer}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('${usageMbps[d.ip]?.toStringAsFixed(1)} Mbps'),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _renameDevice(d),
                      ),
                      IconButton(
                        icon: Icon(d.isBlocked ? Icons.lock_open : Icons.lock),
                        onPressed: () => _toggleBlock(d),
                      ),
                    ]),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool vpnStarted = await _routerService.startVPN();
          _iaService._notifyVoice(
              vpnStarted ? "VPN iniciada com sucesso" : "Falha ao iniciar VPN");
        },
        child: const Icon(Icons.vpn_lock),
        tooltip: 'Iniciar VPN',
      ),
    );
  }
}
