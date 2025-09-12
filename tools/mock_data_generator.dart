// /tools/mock_data_generator.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🧪 MockDataGenerator - Dados falsos          ┃
// ┃ 🔧 Gera dispositivos e tráfego para testes   ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() async {
  final uuid = const Uuid();
  final List<Map<String, dynamic>> devices = [];

  for (int i = 0; i < 5; i++) {
    final id = uuid.v4();
    devices.add({
      'id': id,
      'name': 'Dispositivo $i',
      'ip': '192.168.0.${10 + i}',
      'mac': '00:1A:C2:7B:00:${i.toRadixString(16).padLeft(2, '0')}',
      'type': i % 2 == 0 ? 'Smartphone' : 'Notebook',
      'trafficMbps': (5 + i * 2).toDouble(),
    });
  }

  final json = jsonEncode(devices);
  final file = File('mock_devices.json');
  await file.writeAsString(json);

  stdout.writeln('✅ mock_devices.json gerado com ${devices.length} dispositivos');
}
