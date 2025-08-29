import 'dart:async';
import '../models/device_model.dart';

typedef TrafficCallback = void Function(Map<String, double> usage);

class RouterService {
  final Map<String, Map<String, String>> routerCredentials = {
    'Huawei': {'user': 'admin', 'pass': 'admin'},
    'TPLink': {'user': 'admin', 'pass': 'admin'},
    'Xiaomi': {'user': 'admin', 'pass': 'admin'},
    'Asus': {'user': 'admin', 'pass': 'admin'},
  };

  List<DeviceModel> _devices = [];
  final StreamController<Map<String, double>> _trafficController =
      StreamController.broadcast();

  RouterService() {
    // Inicializa o monitoramento de tráfego real
    _startTrafficSimulation(); // Substituir por integração real quando disponível
  }

  Future<List<DeviceModel>> getDevices() async {
    // Em tráfego real, aqui você buscaria dispositivos conectados via API HTTP, Telnet, SSH ou SNMP
    return _devices;
  }

  void updateDevice(DeviceModel device) {
    int index = _devices.indexWhere((d) => d.mac == device.mac);
    if (index != -1) {
      _devices[index] = device;
    }
  }

  void monitorTraffic(TrafficCallback callback) {
    _trafficController.stream.listen(callback);
  }

  void prioritizeDevice(String mac, {int priority = 100}) {
    // Integração real: enviar comando para roteador alterar QoS
    print('Prioridade $priority atribuída ao dispositivo $mac');
  }

  void addDevice(DeviceModel device) {
    if (!_devices.any((d) => d.mac == device.mac)) {
      _devices.add(device);
    }
  }

  void removeDevice(String mac) {
    _devices.removeWhere((d) => d.mac == mac);
  }

  void _startTrafficSimulation() {
    // Placeholder para tráfego real, substitua por coleta de tráfego via roteador
    Timer.periodic(const Duration(seconds: 5), (_) {
      Map<String, double> usage = {};
      for (var d in _devices) {
        usage[d.ip] = (10 + (d.mac.hashCode % 50)).toDouble();
      }
      _trafficController.add(usage);
    });
  }

  Map<String, String>? getCredentials(String brand) {
    return routerCredentials[brand];
  }

  void setCredentials(String brand, String user, String pass) {
    routerCredentials[brand] = {'user': user, 'pass': pass};
  }
}
