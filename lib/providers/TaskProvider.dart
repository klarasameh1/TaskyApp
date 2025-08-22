import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Database', 'status': false , 'Desc' : 'none' , 'Priority' : Colors.white70 },
    {'name': 'Software', 'status': false , 'Desc' : 'none' ,  'Priority' : Colors.white70},
    {'name': 'Web', 'status': false, 'Desc' : 'none' , 'Priority' : Colors.white70},
    {'name': 'Data Structure', 'status': false, 'Desc' : 'none' , 'Priority' : Colors.white70},
    {'name': 'Social Issues', 'status': false, 'Desc' : 'none' , 'Priority' : Colors.white70},
    {'name': 'Database', 'status': false , 'Desc' : 'none' , 'Priority' : Colors.white70},

  ];

  List<Map<String, dynamic>> get tasks => _tasks;

  void toggleStatus(int index) {
    _tasks[index]['status'] = !_tasks[index]['status'];
    notifyListeners(); // 🔔 tells UI to rebuild
  }

  void addTask(String name, String desc, Color? priority) {
    _tasks.insert(0,{
      'name': name,
      'status': false,
      'Desc': desc.isNotEmpty ? desc : "no description yet",
    'Priority': priority ?? Colors.white70,
    });
    notifyListeners();
  }

  void updateTask(int index, String name, String desc, Color priority) {
    _tasks[index]['name'] = name;
    _tasks[index]['Desc'] = desc;
    _tasks[index]['Priority'] = priority;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }


  void clearTasklist(){
    _tasks.clear();
    notifyListeners();
  }

}
