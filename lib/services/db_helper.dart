// lib/services/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._private();
  DBHelper._private();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'observador.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE devices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        mac TEXT,
        ip TEXT,
        type TEXT,
        blocked INTEGER
      )
    ''');
  }
}
