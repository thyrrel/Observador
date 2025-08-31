// File: iniciador.dart
import 'dart:io';
import 'package:flutter/material.dart';

/// Inicializador que cria arquivos ausentes e ajusta dependências
class Iniciador {
  static final Iniciador _instance = Iniciador._internal();
  factory Iniciador() => _instance;

  final Map<String, String> _templates = {
    'lib/models/device_model.dart': _deviceModel,
    'lib/services/auth_service.dart': _authService,
    'lib/services/biometric_auth_service.dart': _biometricAuth,
    'lib/services/bluetooth_service.dart': _bluetoothService,
    'lib/services/router_service.dart': _routerService,
    'lib/services/dashboard_service.dart': _dashboardService,
    'lib/services/device_service.dart': _deviceService,
  };

  Iniciador._internal() {
    _createMissingFiles();
  }

  Future<void> _createMissingFiles() async {
    for (final entry in _templates.entries) {
      final file = File(entry.key);
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(entry.value);
        debugPrint('✅ Criado: ${entry.key}');
      }
    }
  }

  static const String _deviceModel = '''
class DeviceModel {
  final String id;
  final String name;
  final String ip;
  final String type;
  final double trafficMbps;

  DeviceModel({
    required this.id,
    required this.name,
    required this.ip,
    required this.type,
    required this.trafficMbps,
  });

  factory DeviceModel.empty() => DeviceModel(
        id: '',
        name: '',
        ip: '',
        type: '',
        trafficMbps: 0.0,
      );
}
''';

  static const String _authService = '''
class AuthService {
  Future<bool> authenticate() async => true;
}
''';

  static const String _biometricAuth = '''
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    return await _localAuth.authenticate(
      localizedReason: 'Autentique-se para continuar',
    );
  }
}
''';

  static const String _bluetoothService = '''
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  Stream<List<ScanResult>> get scanResults => _flutterBlue.scanResults;

  void startScan() => _flutterBlue.startScan();
}
''';

  static const String _routerService = '''
class RouterService {
  Future<List<String>> getDeviceTraffic() async {
    return [];
  }
}
''';

  static const String _dashboardService = '''
class DashboardService {
  Future<double> get trafficMbps async => 0.0;
}
''';

  static const String _deviceService = '''
import 'package:observador/models/device_model.dart';
import 'package:observador/services/storage_service.dart';

class DeviceService {
  final StorageService storageService;

  DeviceService({required this.storageService});

  DeviceModel empty() => DeviceModel.empty();
}
''';

  void runAppWithInit() {
    runApp(const MaterialApp(
      title: 'Observador',
      home: Scaffold(body: Center(child: Text('Iniciado'))),
    ));
  }
}

void main() {
  Iniciador().runAppWithInit();
}
