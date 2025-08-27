import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/tuya_service.dart';
import '../services/bluetooth_service.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isLoading = true;
  late TuyaService tuyaService;
  late BluetoothService bluetoothService;

  @override
  void initState() {
    super.initState();
    tuyaService = TuyaService();
    bluetoothService = BluetoothService();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await tuyaService.loadCredentials();
    await bluetoothService.initBluetooth();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Observador - Smart Home'),
        actions: [
          Switch(
            value: appState.darkMode,
            onChanged: (val) => appState.toggleTheme(val),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tuyaService.buildDeviceList(),
                  SizedBox(height: 16),
                  bluetoothService.buildBluetoothPanel(),
                  SizedBox(height: 16),
                  ...tuyaService.buildApiEditor(context),
                ],
              ),
            ),
    );
  }
}
