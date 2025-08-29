import 'dart:convert';
import 'package:http/http.dart' as http;

class HuaweiService {
  final String ip;
  final String username;
  final String password;

  HuaweiService({
    required this.ip,
    required this.username,
    required this.password,
  });

  Future<String?> login() async {
    try {
      final response = await http.post(
        Uri.parse("http://$ip/api/system/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Username": username,
          "Password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["SessionID"];
      } else {
        return null;
      }
    } catch (e) {
      print("Erro login Huawei: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getConnectedDevices(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse("http://$ip/api/device/host-info"),
        headers: {"Cookie": "SessionID=$sessionId"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro devices Huawei: $e");
      return null;
    }
  }

  Future<bool> blockDevice(String sessionId, String mac) async {
    try {
      final response = await http.post(
        Uri.parse("http://$ip/api/device/block"),
        headers: {
          "Content-Type": "application/json",
          "Cookie": "SessionID=$sessionId"
        },
        body: jsonEncode({"MACAddress": mac}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Erro bloquear Huawei: $e");
      return false;
    }
  }
}
