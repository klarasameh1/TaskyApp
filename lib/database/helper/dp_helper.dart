import 'package:hive/hive.dart';
import '../../models/Task.dart';

/// Hive-based Database helper class for tasks (no manual id)
class DBHelper {
  static const String _boxName = 'tasks';
  static Box? _box;

  /// Initialize Hive box
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  static Box get _db {
    if (_box == null) {
      throw Exception('Hive box not initialized. Call DBHelper.init() first.');
    }
    return _box!;
  }

  /// Insert task
  static Future<int> insertTask(Task task) async {
    // Returns the auto-generated Hive key
    return await _db.add(task.toMap());
  }

  /// Get all tasks or filter by status
  /// Get all tasks or by status
  static Future<List<MapEntry<dynamic, Task>>> getTasks({int? status}) async {
    final box = _db;
    final allEntries = box.toMap().entries // returns Map<dynamic, dynamic>
        .map((entry) => MapEntry(entry.key, Task.fromMap(Map<String, dynamic>.from(entry.value))))
        .toList();

    if (status != null) {
      return allEntries.where((entry) => entry.value.status == status).toList();
    }

    return allEntries;
  }


  /// Update task by Hive index
  static Future<void> updateTask(int index, Task task) async {
    await _db.putAt(index, task.toMap());
  }

  /// Update task status only by Hive index
  static Future<void> updateTaskStatus(int index, int status) async {
    final taskMap = Map<String, dynamic>.from(_db.getAt(index));
    taskMap['status'] = status;
    await _db.putAt(index, taskMap);
  }

  /// Delete task by Hive index
  static Future<void> deleteTask(int index) async {
    await _db.deleteAt(index);
  }

  /// Clear all tasks
  static Future<void> clearTasks() async {
    await _db.clear();
  }

  /// Clear finished tasks
  static Future<void> clearFinishedTasks() async {
    final keysToDelete = <int>[];

    for (int i = 0; i < _db.length; i++) {
      final task = Task.fromMap(Map<String, dynamic>.from(_db.getAt(i)));
      if (task.status == 1) {
        keysToDelete.add(i);
      }
    }

    // Delete in reverse to avoid index shifting
    for (var i in keysToDelete.reversed) {
      await _db.deleteAt(i);
    }
  }
}
