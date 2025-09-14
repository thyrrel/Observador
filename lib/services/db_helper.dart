// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 db_helper.dart - Serviço de acesso e inicialização do banco SQLite ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

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
    final String path = join(await getDatabasesPath(), 'observador.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE devices (
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

// Sugestões
// - 🛡️ Adicionar `try/catch` em `_initDB()` para capturar falhas de inicialização
// - 📦 Criar método `insertDevice()` para facilitar inserções futuras
// - 🔤 Tipar `blocked` como booleano na lógica de acesso, mesmo que armazenado como inteiro
// - 🧩 Separar criação de tabelas em função modular (`_createTables`)
– 🧼 Adicionar controle de versão e migração com `onUpgrade`

// ✍️ byThyrrel
// 💡 Código formatado com estilo técnico, seguro e elegante
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
