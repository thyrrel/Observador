// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 NetworkProvider - Gerenciador de rede     ┃
// ┃ 🔧 Provider para dispositivos monitorados    ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/foundation.dart';
import '../models/device_model.dart';

class NetworkProvider with ChangeNotifier {
  final List<NetworkDevice> _devices = [];

  // 🔍 Lista imutável de dispositivos
  List<NetworkDevice> get devices => List.unmodifiable(_devices);

  // ➕ Adiciona um novo dispositivo à rede
  void addDevice(NetworkDevice device) {
    _devices.add(device);
    notifyListeners();
  }

  // ➖ Remove dispositivo pelo ID
  void removeDevice(String id) {
    _devices.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  // 🔁 Alterna status de bloqueio
  void toggleBlockDevice(String id) {
    final device = _devices.firstWhere(
      (d) => d.id == id,
      orElse: () => throw Exception("Device not found"),
    );
    device.blocked = !device.blocked;
    notifyListeners();
  }
}
