// lib/services/device_service.dart
import 'package:flutter/material.dart';
import '../models/device_traffic.dart';

class DeviceService {
  // Simulação de chamada real a dispositivos conectados
  // Aqui você deve substituir por métodos reais, como SNMP, API do roteador ou leitura local
  Future<List<DeviceTraffic>> getTrafficDataLast7Days() async {
    // Substituir esta lista por dados reais coletados da rede
    await Future.delayed(const Duration(milliseconds: 500)); // Simula delay de rede
    DateTime today = DateTime.now();
    List<DeviceTraffic> trafficData = [];
    for (int i = 6; i >= 0; i--) {
      DateTime day = today.subtract(Duration(days: i));
      trafficData.add(DeviceTraffic(
        day: "${day.day}/${day.month}",
        rxBytes: 500000 + i * 100000, // Exemplo realista
        txBytes: 200000 + i * 50000,  // Exemplo realista
      ));
    }
    return trafficData;
  }
}
