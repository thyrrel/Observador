// lib/services/network_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retorna o IP local do dispositivo
  Future<String?> getLocalIp() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.isLoopback &&
              !addr.address.startsWith("169")) {
            return addr.address;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao obter IP local: $e");
      return null;
    }
  }

  /// Retorna o IP público (consulta a um serviço externo)
  Future<String?> getPublicIp() async {
    try {
      final response = await http.get(Uri.parse("https://api.ipify.org?format=json"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["ip"];
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao obter IP público: $e");
      return null;
    }
  }

  /// Faz consulta DNS usando DNS-over-HTTPS (Google)
  Future<List<String>> resolveDnsOverHttps(String domain) async {
    try {
      final url = Uri.parse("https://dns.google/resolve?name=$domain&type=A");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["Answer"] != null) {
          return List<String>.from(
              data["Answer"].map((a) => a["data"].toString()));
        }
      }
      return [];
    } catch (e) {
      debugPrint("Erro no DoH: $e");
      return [];
    }
  }

  /// Salva credenciais de roteador de forma segura
  Future<void> saveRouterCredentials(String routerIp, String username, String password) async {
    try {
      final hashedKey = sha256.convert(utf8.encode(routerIp)).toString();
      final creds = jsonEncode({"user": username, "pass": password});
      await _secureStorage.write(key: "router_$hashedKey", value: creds);
    } catch (e) {
      debugPrint("Erro ao salvar credenciais: $e");
    }
  }

  /// Recupera credenciais salvas
  Future<Map<String, String>?> getRouterCredentials(String routerIp) async {
    try {
      final hashedKey = sha256.convert(utf8.encode(routerIp)).toString();
      final creds = await _secureStorage.read(key: "router_$hashedKey");
      if (creds != null) {
        return Map<String, String>.from(jsonDecode(creds));
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao ler credenciais: $e");
      return null;
    }
  }

  /// Remove credenciais de roteador
  Future<void> deleteRouterCredentials(String routerIp) async {
    try {
      final hashedKey = sha256.convert(utf8.encode(routerIp)).toString();
      await _secureStorage.delete(key: "router_$hashedKey");
    } catch (e) {
      debugPrint("Erro ao deletar credenciais: $e");
    }
  }

  /// Faz varredura simples para detectar hosts ativos na rede local
  Future<List<String>> scanLocalNetwork({String subnet = "192.168.0"}) async {
    List<String> hosts = [];
    try {
      for (int i = 1; i < 255; i++) {
        final ip = "$subnet.$i";
        try {
          final result = await InternetAddress(ip).reverse();
          hosts.add(result.address);
        } catch (_) {
          // ignora hosts sem resposta
        }
      }
    } catch (e) {
      debugPrint("Erro ao escanear rede: $e");
    }
    return hosts;
  }
}
