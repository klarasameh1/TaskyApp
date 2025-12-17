import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "notes.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insert(String title, String content) async {
    final db = await database;
    return db.insert("notes", {"title": title, "content": content});
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return db.query("notes");
  }

  static Future<int> delete(int id) async {
    final db = await database;
    return db.delete("notes", where: "id = ?", whereArgs: [id]);
  }
}
