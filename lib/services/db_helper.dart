static Future<Database> _initDB() async {
  String path = join(await getDatabasesPath(), 'observador.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE devices(
          ip TEXT PRIMARY KEY,
          mac TEXT,
          name TEXT,
          type TEXT,
          manufacturer TEXT,
          isBlocked INTEGER,
          priority INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE traffic(
          ip TEXT,
          mac TEXT,
          bytesSent INTEGER,
          bytesReceived INTEGER,
          timestamp TEXT
        )
      ''');
    },
  );
}
