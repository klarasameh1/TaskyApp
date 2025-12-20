import 'package:flutter/material.dart';
import 'TaskDialog.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

void showAddDialog(BuildContext context, VoidCallback refresh) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return TaskDialog(
        title: "Add Task",
        initialPriority: Colors.white70,
        onSubmit: (name, desc, priority, date) async {
          final newTask = Task(
            name: name,
            desc: desc.isNotEmpty ? desc : "No description yet",
            date: date.isEmpty ? DateTime.now().toString().substring(0, 10) : date,
            priority: priority,
            status: false,
          );
          await DBHelper.insertTask(newTask);

          refresh(); // refresh task list
          Navigator.pop(dialogContext);
        },
      );
    },
  );
}

