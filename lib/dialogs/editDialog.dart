import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';
import 'TaskDialog.dart';

void showEditDialog(BuildContext context, dynamic key, Task task, VoidCallback refresh) {
  showDialog(
    context: context,
    builder: (_) => TaskDialog(
      title: "Edit Task",
      initialName: task.name,
      initialDescription: task.desc,
      initialPriority: task.priority,
      date: task.date,
      onSubmit: (name, desc, priority, date) async {
        final updatedTask = Task(
          name: name,
          desc: desc.isNotEmpty ? desc : "",
          priority: priority,
          date: date.isNotEmpty ? date : task.date,
          status: task.status,
        );

        await DBHelper.updateTask(key, updatedTask); // ✅ pass Hive key
        refresh(); // refresh task list in UI
      },
    ),
  );
}
