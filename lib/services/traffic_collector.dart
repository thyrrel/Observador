import 'package:observador/models/device_traffic.dart';
import 'package:observador/services/db_helper.dart';

class TrafficCollector {
  Future<void> saveTraffic(DeviceTraffic traffic) async {
    final db = await DBHelper.database;
    await db.insert('traffic', traffic.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DeviceTraffic>> getTrafficLogs() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('traffic');
    return List.generate(maps.length, (i) => DeviceTraffic.fromMap(maps[i]));
  }
}
