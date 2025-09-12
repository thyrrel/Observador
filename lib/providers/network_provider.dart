// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧠 NetworkProvider - Gerenciador de rede      ┃
// ┃ 🔧 Controle de dispositivos e tráfego         ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/device_traffic.dart';
import '../models/network_device.dart';

class NetworkProvider extends ChangeNotifier {
  final List<NetworkDevice> _devices = [];

  // 📦 Lista pública de dispositivos
  List<NetworkDevice> get devices => List.unmodifiable(_devices);

  // ➕ Adiciona novo dispositivo
  void addDevice(DeviceModel model) {
    if (_devices.any((d) => d.device.id == model.id)) return;
    _devices.add(NetworkDevice(device: model));
    notifyListeners();
  }

  // 🗑️ Remove dispositivo por ID
  void removeDevice(String id) {
    _devices.removeWhere((d) => d.device.id == id);
    notifyListeners();
  }

  // 🔍 Busca dispositivo por ID
  NetworkDevice? _find(String id) =>
      _devices.firstWhere((d) => d.device.id == id, orElse: () => null);

  // 🔒 Verifica se está bloqueado
  bool isBlocked(String id) => _find(id)?.isBlocked ?? false;

  // 🔁 Alterna bloqueio
  void toggleBlockDevice(String id) {
    final index = _devices.indexWhere((d) => d.device.id == id);
    if (index == -1) return;

    final current = _devices[index];
    final updated = current.device.copyWith(
      name: current.device.name.contains('[bloqueado]')
          ? current.device.name.replaceAll('[bloqueado]', '').trim()
          : '${current.device.name} [bloqueado]',
    );

    _devices[index] = NetworkDevice(
      device: updated,
      trafficHistory: current.trafficHistory,
    );

    notifyListeners();
  }

  // 📊 Adiciona tráfego ao dispositivo
  void addTraffic(String id, DeviceTraffic traffic) {
    final device = _find(id);
    if (device == null) return;
    device.addTraffic(traffic);
    notifyListeners();
  }

  // 📈 Retorna tráfego agregado
  DeviceTraffic getTraffic(String id) {
    final device = _find(id);
    if (device == null) {
      return DeviceTraffic(day: 'N/A', rxBytes: 0, txBytes: 0);
    }
    return DeviceTraffic(
      day: 'total',
      rxBytes: device.totalRx,
      txBytes: device.totalTx,
    );
  }
}
