import 'package:flutter/material.dart';

class Task {
  int? id;
  String name;
  String desc;
  String date;
  Color priority;
  int status; // 0 pending - 1 done - 2 archive

  Task({
    this.id,
    required this.name,
    required this.desc,
    required this.date,
    required this.priority,
    this.status = 0,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    // Handle priority conversion safely
    Color priorityColor = Colors.white70; // Default

    if (map['priority'] != null) {
      try {
        final priorityValue = map['priority'];
        if (priorityValue is int) {
          priorityColor = Color(priorityValue);
        }
      } catch (e) {
        print('Error converting priority color: $e');
      }
    }

    return Task(
      id: map['id'],
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      date: map['date'] ?? DateTime.now().toString().substring(0, 10),
      priority: priorityColor,
      status: map['status'] ,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'date': date,
    'priority': priority.value,
    'status': status ,
  };
}