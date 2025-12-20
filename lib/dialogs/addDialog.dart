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
          final task = Task(
            name: name,
            desc: desc.isNotEmpty ? desc : "No description yet",
            date: date.isNotEmpty ? date : DateTime.now().toString().substring(0,10),
            priority: priority,
            status: false,
          );

          await DBHelper.insertTask(task);
          refresh();  // refresh task list in UI
          Navigator.pop(dialogContext); // close dialog
        },
      );
    },
  );
}
