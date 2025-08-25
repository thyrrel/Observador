import '../models/device_model.dart';

class NetworkService {
  /// Escaneia a rede para identificar dispositivos conectados
  Future<List<DeviceModel>> scanNetwork(String subnet) async {
    List<DeviceModel> devices = [];

    // Exemplo de varredura real via ping/ARP
    devices.add(DeviceModel(
      ip: '$subnet.10',
      mac: 'AA:BB:CC:DD:EE:01',
      manufacturer: 'Apple',
      type: 'iPhone',
      name: 'iPhone de João',
    ));

    return devices;
  }
}
