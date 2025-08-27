import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(ObservadorApp());
}

class ObservadorApp extends StatefulWidget {
  @override
  _ObservadorAppState createState() => _ObservadorAppState();
}

class _ObservadorAppState extends State<ObservadorApp> {
  bool _darkMode = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final dark = await storage.read(key: 'darkMode');
    setState(() => _darkMode = dark == 'true');
  }

  void _toggleTheme(bool darkMode) async {
    await storage.write(key: 'darkMode', value: darkMode.toString());
    setState(() => _darkMode = darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observador - Smart Home',
      theme: _darkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blueGrey[800],
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue[200]),
            ),
      home: AdminScreen(
        onThemeToggle: _toggleTheme,
        storage: storage,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final FlutterSecureStorage storage;

  const AdminScreen({required this.onThemeToggle, required this.storage, Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isLoading = true;
  bool isBluetoothScanning = false;
  bool darkMode = false;
  String wifiStatus = 'Verificando...';
  String bluetoothStatus = 'Verificando...';
  List<BluetoothDevice> bluetoothDevices = [];
  List<dynamic> devices = [];
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  FlutterBlue? flutterBlue;
  String accessToken = '';

  final List<String> services = ['Tuya', 'SmartThings', 'Philips Hue', 'Alexa', 'Google Home'];
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initConnectivity();
    _loadPreferences();
    _initBluetooth();
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    _stopBluetoothScan();
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    for (var service in services) {
      controllers['$service-clientId'] = TextEditingController();
      controllers['$service-clientSecret'] = TextEditingController();
    }
  }

  void _disposeControllers() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
  }

  Future<void> _initConnectivity() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      wifiStatus = result == ConnectivityResult.wifi
          ? 'Conectado ao Wi-Fi'
          : 'Sem conexão Wi-Fi (${result.toString().split('.').last})';
    });
  }

  Future<void> _initBluetooth() async {
    flutterBlue = FlutterBlue.instance;
    try {
      bool isAvailable = await flutterBlue!.isAvailable;
      if (!isAvailable) {
        setState(() => bluetoothStatus = 'Bluetooth não disponível');
        return;
      }

      bool isOn = await flutterBlue!.isOn;
      if (!isOn) {
        setState(() => bluetoothStatus = 'Bluetooth desligado');
        return;
      }

      setState(() => bluetoothStatus = 'Pronto para escanear');
      await _scanBluetoothDevices();
    } catch (e) {
      setState(() => bluetoothStatus = 'Erro no Bluetooth: ${e.toString()}');
    }
  }

  Future<void> _loadPreferences() async {
    final dark = await widget.storage.read(key: 'darkMode');
    setState(() => darkMode = dark == 'true');

    for (var service in services) {
      final clientId = await widget.storage.read(key: '$service-clientId') ?? '';
      final clientSecret = await widget.storage.read(key: '$service-clientSecret') ?? '';
      controllers['$service-clientId']?.text = clientId;
      controllers['$service-clientSecret']?.text = clientSecret;
    }

    if ((controllers['Tuya-clientId']?.text ?? '').isNotEmpty) {
      await _authenticateTuya();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveApiCredentials(String service) async {
    await widget.storage.write(key: '$service-clientId', value: controllers['$service-clientId']!.text);
    await widget.storage.write(key: '$service-clientSecret', value: controllers['$service-clientSecret']!.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credenciais de $service salvas com sucesso!'))
    );

    if (service == 'Tuya' && controllers['$service-clientId']!.text.isNotEmpty) {
      await _authenticateTuya();
    }
  }

  Future<void> _authenticateTuya() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://openapi.tuyaus.com/v1.0/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'client_id': controllers['Tuya-clientId']!.text,
          'secret': controllers['Tuya-clientSecret']!.text,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        accessToken = data['result']['access_token'] ?? '';
        await widget.storage.write(key: 'Tuya-token', value: accessToken);
        await _fetchDevices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha na autenticação: ${response.statusCode}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na autenticação: ${e.toString()}'))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchDevices() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://openapi.tuyaus.com/v1.0/devices'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => devices = data['result'] ?? []);
      }
    } catch (_) {}
    finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _scanBluetoothDevices() async {
    if (isBluetoothScanning) return;

    setState(() {
      isBluetoothScanning = true;
      bluetoothDevices.clear();
      bluetoothStatus = 'Escaneando...';
    });

    flutterBlue?.startScan(timeout: Duration(seconds: 10));

    flutterBlue?.scanResults.listen((results) {
      if (mounted) {
        setState(() => bluetoothDevices = results.map((r) => r.device).toList());
      }
    }, onDone: () {
      if (mounted) setState(() {
        isBluetoothScanning = false;
        bluetoothStatus = 'Escaneamento completo';
      });
    });
  }

  Future<void> _stopBluetoothScan() async {
    await flutterBlue?.stopScan();
    if (mounted) setState(() => isBluetoothScanning = false);
  }

  Future<void> _toggleDevice(String deviceId, bool currentState) async {
    setState(() {
      devices = devices.map((d) => d['id'] == deviceId ? {...d, 'state': !currentState} : d).toList();
    });

    try {
      final response = await http.post(
        Uri.parse('https://openapi.tuyaus.com/v1.0/devices/$deviceId/commands'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'commands': [{'code': 'switch_1', 'value': !currentState}]}),
      ).timeout(Duration(seconds: 5));

      if (response.statusCode != 200) _revertDeviceState(deviceId, currentState);
    }
