import 'dart:io';
import '../models/device_model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkService {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getGatewayIP() async {
    return await _networkInfo.getWifiGatewayIP();
  }

  Future<List<DeviceModel>> scanNetwork(String subnetPrefix) async {
    List<DeviceModel> devices = [];
    for (int i = 1; i <= 254; i++) {
      String ip = '$subnetPrefix.$i';
      try {
        final socket = await Socket.connect(ip, 80, timeout: Duration(milliseconds: 500));
        socket.destroy();
        String mac = await getMacFromIP(ip);
        String manufacturer = lookupManufacturer(mac);
        String type = classifyDevice(mac, manufacturer, ip);
        devices.add(DeviceModel(
          name: manufacturer,
          ip: ip,
          mac: mac,
          manufacturer: manufacturer,
          type: type,
        ));
      } catch (_) {}
    }
    return devices;
  }

  Future<String> getMacFromIP(String ip) async {
    try {
      final result = await Process.run('arp', ['-n', ip]);
      final lines = result.stdout.toString().split('\n');
      if (lines.length > 1) {
        final parts = lines[1].split(' ').where((e) => e.isNotEmpty).toList();
        if (parts.length >= 3) return parts[2];
      }
    } catch (_) {}
    return '';
  }

  String lookupManufacturer(String mac) {
    Map<String, String> ouiDatabase = {
      "00:1A:2B": "TP-Link",
      "3C:5A:B4": "Xiaomi",
      "00:26:BB": "ASUS",
      // Adicione mais fabricantes
    };
    if (mac.length < 8) return "Desconhecido";
    String prefix = mac.substring(0, 8).toUpperCase();
    return ouiDatabase[prefix] ?? "Desconhecido";
  }

  String classifyDevice(String mac, String manufacturer, String ip) {
    // Heurísticas simples por fabricante ou faixa MAC
    if (manufacturer.contains("Apple")) return "Smartphone/Tablet";
    if (manufacturer.contains("Samsung")) return "Smartphone/Tablet";
    if (manufacturer.contains("Xiaomi") || manufacturer.contains("TP-Link")) return "IoT";
    if (manufacturer.contains("ASUS") || manufacturer.contains("Intel")) return "PC/Laptop";

    // Pode usar o último octeto do IP para inferir dispositivos conectados
    int lastOctet = int.tryParse(ip.split('.').last) ?? 0;
    if (lastOctet > 200) return "IoT";

    return "Desconhecido";
  }
}
