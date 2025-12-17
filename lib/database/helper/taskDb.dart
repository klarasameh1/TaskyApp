import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) {
        return db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            desc TEXT,
            status INTEGER,
            priority INTEGER
          );
        ''');
      },
    );
  }

  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return db.insert("tasks", task);
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db.query("tasks");
  }

  static Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    return db.update(
      "tasks",
      task,
      where: "id = ?",
      whereArgs: [task["id"]],
    );
  }

  static Future<void> clearTasks() async {
    final db = await database;
    await db.delete("tasks");
  }
}
