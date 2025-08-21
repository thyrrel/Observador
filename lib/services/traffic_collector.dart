import 'dart:io';
import 'package:observador/services/db_helper.dart';
import 'package:observador/models/device_traffic.dart';

class TrafficCollector {
  Future<void> collectOnce() async {
    final arpFile = File('/proc/net/arp');
    if (!arpFile.existsSync()) return;

    final lines = arpFile.readAsLinesSync().skip(1);
    final now = DateTime.now();

    for (final line in lines) {
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length < 4) continue;
      final ip = parts[0];

      // bytes fictícios para esqueleto
      final rx = 1000 + (ip.hashCode % 1000);
      final tx = 800  + (ip.hashCode % 500);

      await DBHelper().insertTraffic(
        DeviceTraffic(
          ip: ip,
          name: 'Dispositivo ${ip.split('.').last}',
          rxBytes: rx,
          txBytes: tx,
          timestamp: now,
        ).toMap(),
      );
    }
  }
}
