import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('observador.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, fileName),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE traffic(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip TEXT,
            name TEXT,
            rx INTEGER,
            tx INTEGER,
            ts INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTraffic(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('traffic', row);
  }

  Future<List<Map<String, dynamic>>> last24Hours() async {
    final db = await database;
    final since = DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    return db.query('traffic', where: 'ts > ?', whereArgs: [since]);
  }
}
