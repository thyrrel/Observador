Future<int> insertTraffic(Map<String, dynamic> row) async {
  final db = await database;
  return db.insert('traffic', row);
}

Future<List<Map<String, dynamic>>> last24Hours() async {
  final db = await database;
  final since = DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;
  return db.query('traffic', where: 'ts > ?', whereArgs: [since]);
}

Future<List<Map<String, dynamic>>> last7Days() async {
  final db = await database;
  final since = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
  return db.query('traffic', where: 'ts > ?', whereArgs: [since]);
}
