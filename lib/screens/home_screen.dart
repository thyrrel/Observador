import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';
import '../services/router_service.dart';
import '../services/ia_service.dart';
import '../services/wifi_credentials_service.dart';
import '../services/router_credentials_service.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NetworkService _networkService;
  late RouterService _routerService;
  late IAService _iaService;
  late WifiCredentialsService _wifiService;
  late RouterCredentialsService _routerCredService;

  List<DeviceModel> devices = [];
  Map<String, double> usage = {}; // IP -> Mbps
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _networkService = NetworkService();
    _wifiService = WifiCredentialsService();
    _routerCredService = RouterCredentialsService();
    _iaService = IAService(
      voiceCallback: _voiceAlert,
      routerService: _routerService, // injeção para QoS e VPN
    );
    _initRouter();
    _scanDevices();
  }

  Future<void> _initRouter() async {
    _routerService = RouterService(
      routerIP: '192.168.0.1', // gateway real
      username: 'admin',
      password: 'admin',
    );
    await _routerService.detectRouter();
    await _routerService.login();
  }

  Future<void> _scanDevices() async {
    setState(() => loading = true);
    devices = await _networkService.scanNetwork('192.168.0'); // subnet real
    usage = await _routerService.getTrafficUsage();
    _iaService.analyzeDevices(devices);
    _iaService.analyzeTraffic(devices, usage);
    setState(() => loading = false);
  }

  void _voiceAlert(String msg) {
    // Aqui pode integrar TTS ou assistente de voz
    print('ALERTA: $msg');
  }

  Future<void> _toggleBlock(DeviceModel device) async {
    if (device.isBlocked) {
      await _routerService.unblockDevice(device.mac);
    } else {
      await _routerService.blockDevice(device.mac);
    }
    setState(() => device.isBlocked = !device.isBlocked);
  }

  Future<void> _renameDevice(DeviceModel device) async {
    TextEditingController controller = TextEditingController(text: device.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Renomear dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () {
                setState(() => device.name = controller.text);
                Navigator.pop(context);
              },
              child: const Text('Salvar')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ],
      ),
    );
  }

  Future<void> _prioritizeDevice(DeviceModel device) async {
    await _routerService.prioritizeDevice(device.mac, priority: 200);
    _voiceAlert('${device.name} agora está com prioridade de banda aplicada.');
  }

  Future<void> _connectVPN(DeviceModel device) async {
    await _routerService.connectVPNForDevice(device.mac);
    _voiceAlert('VPN ativada para ${device.name}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observador - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DashboardScreen(devices: devices, usage: usage)));
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final d = devices[index];
                return ListTile(
                  title: Text(d.name),
                  subtitle: Text('${d.ip} - ${d.manufacturer} (${d.type})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(d.isBlocked ? Icons.lock : Icons.lock_open),
                        onPressed: () => _toggleBlock(d),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _renameDevice(d),
                      ),
                      IconButton(
                        icon: const Icon(Icons.speed),
                        tooltip: 'Priorizar Banda',
                        onPressed: () => _prioritizeDevice(d),
                      ),
                      IconButton(
                        icon: const Icon(Icons.vpn_lock),
                        tooltip: 'Ativar VPN',
                        onPressed: () => _connectVPN(d),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDevices,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
