import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/Task.dart';

/// Database helper class for managing tasks CRUD operations
class DBHelper {
  static Database? _db; //Singleton instance of the database

  //getter for the db
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  /// Initializes the DB by:
  // 1. Getting path to databases folder
  // 2. Joining database name
  // 3. Opening/creating the DB with onCreate callback
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create table schema on first creation
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            desc TEXT,
            date TEXT,
            priority INTEGER,
            status INTEGER
          )
        ''');
      },
    );
  }

  // Insert task
  static Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert("tasks", task.toMap());
  }

  // Get tasks
  static Future<List<Task>> getTasks({int? status}) async {
    final db = await database;

    List<Map<String, dynamic>> res;

    if (status == null) {
      res = await db.query('tasks', orderBy: 'id DESC');
    } else {
      res = await db.query(
        'tasks',
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'id DESC',
      );
    }

    // Convert db rows to Task objects
    return res.map((e) => Task.fromMap(e)).toList();
  }

  // Update task
  static Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
        "tasks",
        task.toMap(),
        where: "id = ?",
        whereArgs: [task.id]
    );
  }

  // Update task status
  static Future<int> updateTaskStatus(int id, int status) async {
    final db = await database;
    return db.update(
      "tasks",
      {"status": status },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Delete task
  static Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

  // Clear all tasks
  static Future<void> clearTasks() async {
    final db = await database;
    await db.delete("tasks");
  }

  //clear finished tasks
  static Future<void> clearFinishedTasks() async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'status = ?',
      whereArgs: [1],
    );
  }
}