import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/db_helper.dart';

void main() {
  test('DBHelper insert e query simulados', () async {
    final db = DBHelper();
    await db.insert('devices', {'ip': '192.168.0.2', 'name': 'PC1'});

    final results = await db.query('devices');
    expect(results.length, 1);
    expect(results.first['name'], 'PC1');
  });
}
