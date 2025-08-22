import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TaskProvider.dart';
import 'TaskDialog.dart';

void showEditDialog(BuildContext context, int index) {
  final taskProvider = context.read<TaskProvider>();
  final task = taskProvider.tasks[index];
  showDialog(
    context: context,
    builder:
        (_) => TaskDialog(
      title: "Edit Task", // title of dialog
      initialName: task['name'],
      initialDescription: task['Desc'],
      initialPriority: task['Priority'],
      onSubmit: (name, desc , priority) {
        taskProvider.updateTask(index, name, desc , priority);
      },
    ),
  );
}