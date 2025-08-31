import 'package:flutter/material.dart';

class Task {
  final int id;
  String name;
  String desc;
  Color priority;
  bool status;

  Task({
    required this.id,
    required this.name,
    this.desc = "no description yet",
    this.priority = Colors.white,
    this.status = false,
  });
}
