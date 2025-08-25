import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RouterService {
  final String routerIP;
  final String username;
  final String password;
  late String routerType;
  String? token;

  RouterService({required this.routerIP, required this.username, required this.password});

  /// Passo 1 – Detectar tipo de roteador
  Future<void> detectRouter() async {
    routerType = 'Desconhecido';
    try {
      final response = await HttpClient()
          .getUrl(Uri.parse('http://$routerIP'))
          .then((req) => req.close());
      if (response.statusCode == 200) {
        final headers = response.headers.value('Server') ?? '';
        if (headers.contains('TP-LINK')) routerType = 'TP-Link';
        if (headers.contains('ASUS')) routerType = 'ASUS';
        if (headers.contains('D-Link')) routerType = 'D-Link';
      }
    } catch (_) {}
  }

  /// Passo 2 – Autenticar (token ou basic)
  Future<bool> login() async {
    switch (routerType) {
      case 'TP-Link':
        return await _loginTPLink();
      case 'ASUS':
        return await _loginASUS();
      case 'D-Link':
        return await _loginDLink();
      default:
        return false;
    }
  }

  Future<bool> _loginTPLink() async {
    // Simulação: implementar autenticação via API real TP-Link
    token = base64Encode(utf8.encode('$username:$password'));
    return true;
  }

  Future<bool> _loginASUS() async {
    token = base64Encode(utf8.encode('$username:$password'));
    return true;
  }

  Future<bool> _loginDLink() async {
    token = base64Encode(utf8.encode('$username:$password'));
    return true;
  }

  /// Passo 3 – Bloquear dispositivo
  Future<bool> blockDevice(String mac) async {
    switch (routerType) {
      case 'TP-Link':
        return await _blockDeviceTPLink(mac);
      case 'ASUS':
        return await _blockDeviceASUS(mac);
      case 'D-Link':
        return await _blockDeviceDLink(mac);
      default:
        return false;
    }
  }

  Future<bool> _blockDeviceTPLink(String mac) async {
    // Implementar chamada real da API TP-Link
    return
