// lib/providers/device_provider.dart
import 'package:flutter/foundation.dart';
import '../services/network_service.dart';
import '../models/network_device.dart';

class DeviceProvider extends ChangeNotifier {
  final NetworkService _networkService;
  List<NetworkDevice> _devices = [];

  DeviceProvider(this._networkService) {
    _devices = _networkService.devices;
    _networkService.addListener(_updateDevices);
  }

  List<NetworkDevice> get devices => _devices;

  /// Atualiza lista de dispositivos quando o serviço de rede muda
  void _updateDevices() {
    _devices = _networkService.devices;
    notifyListeners();
  }

  /// Alterna bloqueio do dispositivo
  Future<void> toggleBlockDevice(NetworkDevice device) async {
    await _networkService.toggleBlock(device);
    _updateDevices();
  }

  /// Aplica limite de tráfego (em KB/s)
  Future<void> setDeviceLimit(NetworkDevice device, int limitKbps) async {
    await _networkService.setLimit(device, limitKbps);
    _updateDevices();
  }

  /// Prioriza o dispositivo com peso de prioridade
  Future<void> prioritizeDevice(NetworkDevice device, {int priority = 100}) async {
    await _networkService.setPriority(device, priority);
    _updateDevices();
  }

  @override
  void dispose() {
    _networkService.removeListener(_updateDevices);
    super.dispose();
  }
}
