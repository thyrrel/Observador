// /lib/providers/device_manager.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📡 DeviceManager - Gerencia dispositivos de rede ┃
// ┃ 🔧 Bloqueio, liberação, priorização e feedback ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/foundation.dart';
import '../models/device_model.dart';

/// 🔔 Callback para notificação visual
typedef DeviceNotification = void Function(String msg);

class DeviceManager extends ChangeNotifier {
  final DeviceNotification? notifyCallback;

  List<NetworkDevice> _devices = [];
  List<NetworkDevice> get devices => _devices;

  DeviceManager({this.notifyCallback});

  /// 📦 Inicializa a lista de dispositivos
  void loadDevices(List<NetworkDevice> initialDevices) {
    _devices = initialDevices;
    notifyListeners();
  }

  /// 🔄 Atualiza lista após varredura ou alteração
  void updateDevices(List<NetworkDevice> updatedDevices) {
    _devices = updatedDevices;
    notifyListeners();
  }

  /// 🔐 Alterna bloqueio/liberação de dispositivo
  Future<void> toggleBlockDevice(NetworkDevice device) async {
    if (device.blocked) {
      await _limitDevice(device, 1024); // exemplo de liberação com limite
      device.blocked = false;
      notifyCallback?.call('🔓 ${device.name} desbloqueado');
    } else {
      await _blockDevice(device);
      device.blocked = true;
      notifyCallback?.call('🔒 ${device.name} bloqueado');
    }
    notifyListeners();
  }

  /// 🚀 Prioriza dispositivo com QoS
  Future<void> prioritizeDevice(NetworkDevice device, {int priority = 200}) async {
    // Aqui chamaria a função real do roteador
    notifyCallback?.call('🚀 ${device.name} priorizado com QoS $priority');
  }

  /// 🧪 Simulação de bloqueio
  Future<void> _blockDevice(NetworkDevice device) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// 🧪 Simulação de limitação
  Future<void> _limitDevice(NetworkDevice device, int kbps) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 NetworkDevice - Modelo de dispositivo de rede ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
class NetworkDevice {
  String ip;
  String mac;
  String name;
  String type;
  bool blocked;

  NetworkDevice({
    required this.ip,
    required this.mac,
    required this.name,
    required this.type,
    this.blocked = false,
  });
}
