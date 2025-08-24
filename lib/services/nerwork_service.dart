// lib/services/network_service.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NetworkService {
  // Stream de dispositivos conectados
  final StreamController<List<String>> _devicesController =
      StreamController<List<String>>.broadcast();

  // Lista simulada de dispositivos (substituir por detecção real)
  List<String> _devices = [];

  NetworkService() {
    // Simulação inicial de dispositivos
    _devices = ['Dispositivo 1', 'Dispositivo 2', 'Dispositivo 3'];
    _updateDevicesStream();
  }

  Stream<List<String>> get devicesStream => _devicesController.stream;

  void _updateDevicesStream() {
    _devicesController.add(_devices);
  }

  // Método para adicionar dispositivo (ex: novo dispositivo detectado)
  void addDevice(String name) {
    _devices.add(name);
    _updateDevicesStream();
  }

  // Método para remover dispositivo
  void removeDevice(String name) {
    _devices.remove(name);
    _updateDevicesStream();
  }

  // Método para checar conexão de internet
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  // Dispose
  void dispose() {
    _devicesController.close();
  }
}
