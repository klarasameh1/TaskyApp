import 'package:flutter/material.dart';

class Task {
  String name;
  String desc;
  String date;
  Color priority;
  int status; // 0 = pending, 1 = done, 2 = archived

  Task({
    required this.name,
    required this.desc,
    required this.date,
    required this.priority,
    this.status = 0,
  });

  /// Convert from Map (Hive or JSON)
  factory Task.fromMap(Map<String, dynamic> map) {
    // Safely convert priority
    Color priorityColor = Colors.white70; // default
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
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      date: map['date'] ?? DateTime.now().toString().substring(0, 10),
      priority: priorityColor,
      status: map['status'] ?? 0,
    );
  }

  /// Convert to Map (Hive storage)
  Map<String, dynamic> toMap() => {
    'name': name,
    'desc': desc,
    'date': date,
    'priority': priority.value,
    'status': status,
  };
}
