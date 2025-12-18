import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../database/helper/taskDb.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Load all tasks from DB
  Future<void> loadTasks() async {
    final data = await TaskDB.getTasks();
    _tasks.clear();

    for (var row in data) {
      _tasks.add(Task.fromMap(row));
    }

    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String name, String desc, Color priority, String date) async {
    // Generate current date for this task
    final String currentDate = DateTime.now().toString().substring(0,10);

    final task = Task(
      name: name,
      desc: desc.isNotEmpty ? desc : "No description yet",
      date: date,   // use the freshly generated date
      priority: priority.value,
      status: false,
    );

    final id = await TaskDB.insertTask(task.toMap());
    task.id = id; // set the auto-generated DB id
    _tasks.insert(0, task);

    notifyListeners();
  }


  // Toggle status (done/pending)
  Future<void> toggleStatus(int index) async {
    var task = _tasks[index];
    task.status = !task.status;

    await TaskDB.updateTask(task.toMap());
    notifyListeners();
  }

  // Update task details
  Future<void> updateTask(int index, String name, String desc, Color priority , String date) async {
    var task = _tasks[index];
    task.name = name;
    task.desc = desc.isNotEmpty ? desc : "No description yet";
    task.priority = priority.value;
    task.date= date;

    await TaskDB.updateTask(task.toMap());
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(int index) async {
    final task = _tasks[index];
    await TaskDB.deleteTask(task.id!);

    _tasks.removeAt(index);
    notifyListeners();
  }

  // Clear all tasks
  Future<void> clearTaskList() async {
    await TaskDB.clearTasks();
    _tasks.clear();
    notifyListeners();
  }
}
