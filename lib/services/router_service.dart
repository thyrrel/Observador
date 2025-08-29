import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RouterService {
  // Credenciais padrão para cada marca
  final Map<String, String> defaultCredentials = {
    'huawei': 'admin:admin',
    'tplink': 'admin:admin',
    'xiaomi': 'admin:admin',
    'asus': 'admin:admin',
  };

  // Salvar credenciais localmente
  Future<void> saveCredentials(String brand, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$brand-username', username);
    await prefs.setString('$brand-password', password);
  }

  // Carregar credenciais salvas
  Future<Map<String, String>?> loadCredentials(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('$brand-username');
    final password = prefs.getString('$brand-password');
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  // Conectar roteador (tenta credenciais salvas ou padrão)
  Future<bool> connectRouter(String brand, String ip) async {
    Map<String, String>? creds = await loadCredentials(brand);
    if (creds == null) {
      final defaultCred = defaultCredentials[brand]!.split(':');
      creds = {'username': defaultCred[0], 'password': defaultCred[1]};
    }

    final url = Uri.parse('http://$ip/login');
    final response = await http.post(
      url,
      body: {
        'username': creds['username']!,
        'password': creds['password']!,
      },
    );

    if (response.statusCode == 200) {
      await saveCredentials(brand, creds['username']!, creds['password']!);
      return true;
    } else {
      return false;
    }
  }

  // Bloquear IP (genérico)
  Future<bool> blockIP(String brand, String ip, String targetIP) async {
    final creds = await loadCredentials(brand);
    if (creds == null) return false;

    final url = Uri.parse('http://$ip/block');
    final response = await http.post(
      url,
      body: {
        'username': creds['username']!,
        'password': creds['password']!,
        'targetIP': targetIP,
      },
    );

    return response.statusCode == 200;
  }

  // Limitar velocidade de IP (genérico)
  Future<bool> limitIP(String brand, String ip, String targetIP, int speedKb) async {
    final creds = await loadCredentials(brand);
    if (creds == null) return false;

    final url = Uri.parse('http://$ip/limit');
    final response = await http.post(
      url,
      body: {
        'username': creds['username']!,
        'password': creds['password']!,
        'targetIP': targetIP,
        'speed': speedKb.toString(),
      },
    );

    return response.statusCode == 200;
  }

  // Métodos específicos por marca (exemplo Huawei)
  Future<bool> connectHuawei(String ip) async => connectRouter('huawei', ip);
  Future<bool> blockHuaweiIP(String ip, String targetIP) async => blockIP('huawei', ip, targetIP);
  Future<bool> limitHuaweiIP(String ip, String targetIP, int speedKb) async =>
      limitIP('huawei', ip, targetIP, speedKb);

  // Métodos TP-Link
  Future<bool> connectTPLink(String ip) async => connectRouter('tplink', ip);
  Future<bool> blockTPLinkIP(String ip, String targetIP) async => blockIP('tplink', ip, targetIP);
  Future<bool> limitTPLinkIP(String ip, String targetIP, int speedKb) async =>
      limitIP('tplink', ip, targetIP, speedKb);

  // Métodos Xiaomi
  Future<bool> connectXiaomi(String ip) async => connectRouter('xiaomi', ip);
  Future<bool> blockXiaomiIP(String ip, String targetIP) async => blockIP('xiaomi', ip, targetIP);
  Future<bool> limitXiaomiIP(String ip, String targetIP, int speedKb) async =>
      limitIP('xiaomi', ip, targetIP, speedKb);

  // Métodos Asus
  Future<bool> connectAsus(String ip) async => connectRouter('asus', ip);
  Future<bool> blockAsusIP(String ip, String targetIP) async => blockIP('asus', ip, targetIP);
  Future<bool> limitAsusIP(String ip, String targetIP, int speedKb) async =>
      limitIP('asus', ip, targetIP, speedKb);
}
