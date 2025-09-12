// /tools/init_project.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🛠️ InitProject - Gerador de estrutura base   ┃
// ┃ 🔧 Cria arquivos ausentes com templates      ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';

void main() async {
  final templates = {
    'lib/models/device_model.dart': _deviceModel,
    'lib/services/auth_service.dart': _authService,
    'lib/services/biometric_auth_service.dart': _biometricAuth,
    'lib/services/bluetooth_service.dart': _bluetoothService,
    'lib/services/router_service.dart': _routerService,
    'lib/services/dashboard_service.dart': _dashboardService,
    'lib/services/device_service.dart': _deviceService,
  };

  for (final entry in templates.entries) {
    final file = File(entry.key);
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(entry.value);
      stdout.writeln('✅ Criado: ${entry.key}');
    } else {
      stdout.writeln('🟡 Já existe: ${entry.key}');
    }
  }

  stdout.writeln('\n🎉 Estrutura inicial pronta!');
}

// 📦 Templates de arquivos
const String _deviceModel = '''
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

const String _authService = '''
class AuthService {
  Future<bool> authenticate() async => true;
}
''';

const String _biometricAuth = '''
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

const String _bluetoothService = '''
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  Stream<List<ScanResult>> get scanResults => _flutterBlue.scanResults;

  void startScan() => _flutterBlue.startScan();
}
''';

const String _routerService = '''
class RouterService {
  Future<List<String>> getDeviceTraffic() async {
    return [];
  }
}
''';

const String _dashboardService = '''
class DashboardService {
  Future<double> get trafficMbps async => 0.0;
}
''';

const String _deviceService = '''
import 'package:observador/models/device_model.dart';
import 'package:observador/services/storage_service.dart';

class DeviceService {
  final StorageService storageService;

  DeviceService({required this.storageService});

  DeviceModel empty() => DeviceModel.empty();
}
''';
