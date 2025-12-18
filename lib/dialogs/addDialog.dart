import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TaskProvider.dart';
import 'TaskDialog.dart';

void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          TaskDialog(
            title: "Add Task",
            initialPriority: Colors.white70,
            onSubmit: (name, desc, priority, date) async {
              await Provider.of<TaskProvider>(context, listen: false)
                  .addTask(name, desc, priority, date);
            },
          ),
    );
}
