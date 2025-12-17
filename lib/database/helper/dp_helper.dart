import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/Task.dart';

class TaskDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            desc TEXT,
            priority INTEGER,
            status INTEGER
          )
        ''');
      },
    );
  }

  // Insert a Task
  static Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert("tasks", task.toMap());
  }

  // Get all Tasks
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db.query("tasks", orderBy: "id DESC");
  }

  // Update a Task
  static Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  // Delete a Task
  static Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

  // Clear all tasks
  static Future<void> clearTasks() async {
    final db = await database;
    await db.delete("tasks");
  }
}
