// /lib/core/app_initializer.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🚀 AppInitializer - Inicialização do app     ┃
// ┃ 🐾 Inclui Watchdog para verificação híbrida ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/bluetooth_service.dart';
import '../../tools/watchdog.dart';

class AppInitializer {
  static Future<void> initialize() async {
    print('🚀 Inicializando Observador...\n');

    // 🔐 Autenticação
    await AuthService().authenticate();

    // 💾 Storage
    await StorageService().init();

    // 📡 Bluetooth
    await BluetoothService().startScan();

    // 🐾 Watchdog automático
    await Watchdog.run(auto: true);

    print('\n✅ App pronto para uso.');
  }
}
