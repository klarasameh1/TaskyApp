import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';
import 'TaskDialog.dart';

void showEditDialog(BuildContext context, Task task, VoidCallback refresh) {
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
          id: task.id,
          name: name,
          desc: desc.isNotEmpty ? desc : "",
          priority: priority,
          date: date.isNotEmpty ? date : task.date,
          status: task.status,
        );

        await DBHelper.updateTask(updatedTask); // update DB
        refresh(); // refresh task list in UI
      },
    ),
  );
}
