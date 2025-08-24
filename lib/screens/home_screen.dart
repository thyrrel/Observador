import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService _networkService = NetworkService();
  List<DeviceModel> devices = [];
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    _scanNetwork();
  }

  Future<void> _scanNetwork() async {
    setState(() => scanning = true);
    String? gateway = await _networkService.getGatewayIP();
    if (gateway != null) {
      String subnet = gateway.substring(0, gateway.lastIndexOf('.'));
      devices = await _networkService.scanNetwork(subnet);
    }
    setState(() => scanning = false);
  }

  void _editDeviceName(DeviceModel device) {
    TextEditingController controller = TextEditingController(text: device.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear dispositivo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => device.name = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observador - Dispositivos')),
      body: scanning
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text('${device.ip} | ${device.mac} | ${device.manufacturer}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editDeviceName(device),
                  ),
                );
              },
            ),
    );
  }
}
