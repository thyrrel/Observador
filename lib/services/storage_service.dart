import 'package:sqflite/sqflite.dart';
import '../models/network_device.dart';

class StorageService {
  final Database db;

  StorageService(this.db);

  Future<void> saveDevice(NetworkDevice device) async {
    await db.insert(
      'devices',
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NetworkDevice>> getDevices() async {
    final List<Map<String, dynamic>> maps = await db.query('devices');
    return List.generate(maps.length, (i) => NetworkDevice.fromMap(maps[i]));
  }
}
