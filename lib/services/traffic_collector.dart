import 'package:sqflite/sqflite.dart';

class TrafficCollector {
  final Database db;

  TrafficCollector(this.db);

  Future<void> logTraffic(Map<String, dynamic> traffic) async {
    await db.insert(
      'traffic',
      traffic,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
