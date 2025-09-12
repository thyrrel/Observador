// /tools/watchdog.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🐾 Watchdog - Monitoramento híbrido          ┃
// ┃ 🔧 Verifica serviços e aciona testes         ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';
import '../models/device_model.dart';
import '../services/bluetooth_service.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../test/test_seed.dart';

class Watchdog {
  static Future<void> run({bool auto = false}) async {
    stdout.writeln('🐾 Iniciando Watchdog...\n');

    _checkService('BluetoothService', () => BluetoothService().scanResults);
    _checkService('StorageService', () => StorageService().isReady);
    _checkService('AuthService', () => AuthService().authenticate());

    if (!auto) {
      stdout.writeln('\n🧪 Modo manual: acionando TestSeed...');
      final mockDevices = TestSeed.generateDevices(count: 3);
      for (final device in mockDevices) {
        stdout.writeln('🔧 Mock: ${device.name} (${device.ip})');
      }
    }

    stdout.writeln('\n✅ Watchdog finalizado.');
  }

  static void _checkService(String name, dynamic Function() check) {
    try {
      final result = check();
      stdout.writeln('✅ $name ativo: $result');
    } catch (e) {
      stdout.writeln('❌ $name falhou: $e');
    }
  }
}
