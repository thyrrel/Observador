import 'db_helper.dart';
import '../models/device_model.dart';

class TrafficCollector {
  Future<void> collectOnce(DeviceModel device) async {
    final db = await DBHelper.getDatabase();
    // Exemplo: inserir dispositivo no DB
    await db.insert(
      'devices',
      {
        'ip': device.ip,
        'mac': device.mac,
        'name': device.name,
        'type': device.type,
        'manufacturer': device.manufacturer
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
