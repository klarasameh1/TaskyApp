import 'dart:ui';

class Task {
   int? id;
  String name;
  String desc;
  int priority;   // store color as int
  bool status;

  Task({
    this.id,
    required this.name,
    this.desc = "no description yet",
    this.priority = 0xFFFFFFFF, // white
    this.status = false,
  });

  Map<String,dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "desc": desc,
      "priority": priority,
      "status": status ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String,dynamic> map) {
    return Task(
      id: map["id"],
      name: map["name"],
      desc: map["desc"],
      priority: map["priority"],
      status: map["status"] == 1,
    );
  }

  Color get priorityColor => Color(priority);
}
