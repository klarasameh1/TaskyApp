import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../providers/TaskProvider.dart';
import 'TaskDialog.dart';

void showAddDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => TaskDialog(
      title: "Add Task", // title of dialog
      onSubmit: (name, desc, priority) {
        context.read<TaskProvider>().addTask(name, desc, priority);
      },
    ),
  );
}
