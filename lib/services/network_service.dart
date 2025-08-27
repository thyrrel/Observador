import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkService {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<Map<String, dynamic>> getNetworkStatus() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiIPv6 = await _networkInfo.getWifiIPv6();
      final wifiSubmask = await _networkInfo.getWifiSubmask();
      final wifiBroadcast = await _networkInfo.getWifiBroadcast();
      final wifiGateway = await _networkInfo.getWifiGatewayIP();

      return {
        "wifiName": wifiName ?? "Desconhecido",
        "bssid": wifiBSSID ?? "N/A",
        "ip": wifiIP ?? "N/A",
        "ipv6": wifiIPv6 ?? "N/A",
        "submask": wifiSubmask ?? "N/A",
        "broadcast": wifiBroadcast ?? "N/A",
        "gateway": wifiGateway ?? "N/A",
        "dns": await _getDnsServers(),
      };
    } catch (e) {
      return {"error": "Falha ao obter dados da rede: $e"};
    }
  }

  Future<List<String>> _getDnsServers() async {
    try {
      final result = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.any,
      );

      final dnsServers = <String>[];
      for (var interface in result) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 ||
              addr.type == InternetAddressType.IPv6) {
            dnsServers.add(addr.address);
          }
        }
      }
      return dnsServers;
    } catch (_) {
      return ["Não foi possível obter DNS"];
    }
  }
}
