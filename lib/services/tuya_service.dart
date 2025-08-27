import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TuyaService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String accessToken = '';
  List<dynamic> devices = [];
  TextEditingController clientIdController = TextEditingController();
  TextEditingController clientSecretController = TextEditingController();

  Future<void> loadCredentials() async {
    clientIdController.text = await _storage.read(key: 'Tuya-clientId') ?? '';
    clientSecretController.text = await _storage.read(key: 'Tuya-clientSecret') ?? '';
    if (clientIdController.text.isNotEmpty) {
      await authenticate();
    }
  }

  Future<void> saveCredentials() async {
    await _storage.write(key: 'Tuya-clientId', value: clientIdController.text);
    await _storage.write(key: 'Tuya-clientSecret', value: clientSecretController.text);
    await authenticate();
  }

  Future<void> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('https://openapi.tuyaus.com/v1.0/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'client_id': clientIdController.text,
          'secret': clientSecretController.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        accessToken = data['result']['access_token'] ?? '';
        await fetchDevices();
      }
    } catch (e) {
      print('Erro Tuya: $e');
    }
  }

  Future<void> fetchDevices() async {
    try {
      final response = await http.get(
        Uri.parse('https://openapi.tuyaus.com/v1.0/devices'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        devices = data['result'] ?? [];
      }
    } catch (e) {
      print('Erro fetchDevices: $e');
    }
  }

  Widget buildDeviceList() {
    if (devices.isEmpty) return Text('Nenhum dispositivo Tuya encontrado');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: devices.map((d) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(d['name'] ?? 'Sem nome'),
            subtitle: Text(d['id'] ?? ''),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> buildApiEditor(BuildContext context) {
    return [
      Card(
        child
