// lib/providers/device_manager.dart
import 'package:flutter/foundation.dart';
import '../models/device_model.dart';

typedef DeviceNotification = void Function(String msg);

class DeviceManager extends ChangeNotifier {
  final DeviceNotification? notifyCallback;

  List<NetworkDevice> _devices = [];
  List<NetworkDevice> get devices => _devices;

  DeviceManager({this.notifyCallback});

  /// Inicializa a lista de dispositivos
  void loadDevices(List<NetworkDevice> initialDevices) {
    _devices = initialDevices;
    notifyListeners();
  }

  /// Atualiza dispositivos (ex: após varredura de rede)
  void updateDevices(List<NetworkDevice> updatedDevices) {
    _devices = updatedDevices;
    notifyListeners();
  }

  /// Bloqueia ou libera dispositivo
  Future<void> toggleBlockDevice(NetworkDevice device) async {
    if (device.blocked) {
      // Exemplo: liberar com limite mínimo
      await _limitDevice(device, 1024);
      device.blocked = false;
      notifyCallback?.call('Dispositivo ${device.name} desbloqueado');
    } else {
      await _blockDevice(device);
      device.blocked = true;
      notifyCallback?.call('Dispositivo ${device.name} bloqueado');
    }
    notifyListeners();
  }

  /// Prioriza dispositivo
  Future<void> prioritizeDevice(NetworkDevice device, {int priority = 200}) async {
    // Aqui chamaria a função real do roteador
    notifyCallback?.call('Dispositivo ${device.name} priorizado com QoS $priority');
  }

  /// Simulação de bloqueio
  Future<void> _blockDevice(NetworkDevice device) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Simulação de limitação de dispositivo
  Future<void> _limitDevice(NetworkDevice device, int kbps) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

// Modelo de exemplo de dispositivo
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
