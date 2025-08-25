import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<Map<String, dynamic>> getNetworkStatus() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final wifiName = await _networkInfo.getWifiName();
    final wifiIP = await _networkInfo.getWifiIP();
    final wifiGateway = await _networkInfo.getWifiGatewayIP();

    return {
      'status': connectivityResult.toString(),
      'wifiName': wifiName ?? 'Desconhecido',
      'ip': wifiIP ?? 'Desconhecido',
      'gateway': wifiGateway ?? 'Desconhecido',
    };
  }

  Future<bool> pingHost(String host) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
