import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(id: 1, name: 'Home Work'),
    Task(id: 2, name: 'Assignment'),
    Task(id: 3, name: 'Quiz'),
    Task(id: 4, name: 'Internship'),
    Task(id: 5, name: 'Flutter project'),
    Task(id: 6, name: 'Grocery'),
  ];

  int _nextId = 7; // for new tasks

  List<Task> get tasks => _tasks;

  void toggleStatus(int index) {
    _tasks[index].status = !_tasks[index].status;
    notifyListeners();
  }

  void addTask(String name, String desc, Color? priority) {
    _tasks.insert(
      0,
      Task(
        id: _nextId++,
        name: name,
        desc: desc.isNotEmpty ? desc : "no description yet",
        priority: priority ?? Colors.white,
      ),
    );
    notifyListeners();
  }

  void updateTask(int index, String name, String desc, Color priority) {
    _tasks[index].name = name;
    _tasks[index].desc = desc;
    _tasks[index].priority = priority;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void clearTasklist() {
    _tasks.clear();
    notifyListeners();
  }
}
