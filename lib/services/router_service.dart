import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_model.dart';

class RouterService {
  final String routerIP;
  final String token;

  RouterService({required this.routerIP, required this.token});

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Future<List<DeviceModel>> getDevices() async {
    final response = await http.get(Uri.parse('http://$routerIP/devices'), headers: headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DeviceModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> blockDevice(String mac) async {
    final response = await http.post(
      Uri.parse('http://$routerIP/block'),
      headers: headers,
      body: jsonEncode({'mac': mac}),
    );
    return response.statusCode == 200;
  }

  Future<bool> unblockDevice(String mac) async {
    final response = await http.post(
      Uri.parse('http://$routerIP/unblock'),
      headers: headers,
      body: jsonEncode({'mac': mac}),
    );
    return response.statusCode == 200;
  }

  Future<bool> startVPN() async {
    final response = await http.post(Uri.parse('http://$routerIP/vpn/start'), headers: headers);
    return response.statusCode == 200;
  }

  Future<bool> stopVPN() async {
    final response = await http.post(Uri.parse('http://$routerIP/vpn/stop'), headers: headers);
    return response.statusCode == 200;
  }
}
