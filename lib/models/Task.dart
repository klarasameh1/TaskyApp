import 'package:flutter/material.dart';

class Task {
  int? id;
  String name;
  String desc;
  String date; // stored as YYYY-MM-DD
  Color priority; // Flutter Color
  bool status;

  Task({
    this.id,
    required this.name,
    required this.desc,
    required this.date,
    required this.priority,
    this.status = false,
  });

  // Convert Task to Map for DB storage
  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    name: map['name'] ?? '',
    desc: map['desc'] ?? '',
    date: map['date'] ?? DateTime.now().toString().substring(0,10),
    priority: map['priority'] != null ? Color(map['priority']) : Colors.white70,
    status: map['status'] == 1,
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'desc': desc , 'date': date, 'priority':priority.value ,'status': status?1:0};
}

