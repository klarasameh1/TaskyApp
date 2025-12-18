import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../providers/TaskProvider.dart';
import 'TaskDialog.dart';

void showAddDialog(BuildContext context) {
  final taskProvider = context.read<TaskProvider>();

  showDialog(
    context: context,
    builder: (_) => TaskDialog(
      title: "Add Task", // title of dialog
      initialPriority: Colors.white70,
      onSubmit: (name, desc, priority,date) {
        taskProvider.addTask(name, desc, priority, date);
      },
    ),
  );
}
