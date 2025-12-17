import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../database/helper/taskDb.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // load tasks from DB
  Future<void> loadTasks() async {
    final data = await TaskDB.getTasks();
    _tasks.clear();

    for (var row in data) {
      _tasks.add(Task(
        id: row["id"],
        name: row["name"],
        desc: row["desc"],
        status: row["status"] == 1,
        priority: Color(row["priority"]),
      ));
    }

    notifyListeners();
  }

  Future<void> addTask(String name, String desc, Color priority) async {
    final id = await TaskDB.insertTask({
      "name": name,
      "desc": desc,
      "priority": priority.value,
      "status": 0,
    });

    _tasks.insert(
      0,
      Task(
        id: id,              // 👈 use real DB id
        name: name,
        desc: desc,
        priority: priority,
        status: false,
      ),
    );

    notifyListeners();
  }


  Future<void> toggleStatus(int index) async {
    var task = _tasks[index];
    task.status = !task.status;

    await TaskDB.updateTask({
      "id": task.id,
      "name": task.name,
      "desc": task.desc,
      "status": task.status ? 1 : 0,
      "priority": task.priority.value,
    });

    notifyListeners();
  }

  Future<void> updateTask(int index, String name, String desc, Color priority) async {
    var task = _tasks[index];

    task.name = name;
    task.desc = desc;
    task.priority = priority;

    await TaskDB.updateTask({
      "id": task.id,
      "name": name,
      "desc": desc,
      "status": task.status ? 1 : 0,
      "priority": priority.value,
    });

    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    final task = _tasks[index];
    await TaskDB.deleteTask(task.id);

    _tasks.removeAt(index);
    notifyListeners();
  }

  Future<void> clearTaskList() async {
    await TaskDB.clearTasks();
    _tasks.clear();
    notifyListeners();
  }
}
