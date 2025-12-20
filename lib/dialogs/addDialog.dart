import 'package:flutter/material.dart';
import 'TaskDialog.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

void showAddDialog(BuildContext context, VoidCallback refresh) {
  showDialog(
    context: context,
    builder: (context) => TaskDialog(
      title: "Add Task",
      initialPriority: const Color(0xB3FFFFFF), // Use Color constructor for white70
      onSubmit: (name, desc, priority, date) async {
        final newTask = Task(
          name: name,
          desc: desc.isNotEmpty ? desc : "No description yet",
          date: date.isNotEmpty ? date : DateTime.now().toString().substring(0, 10),
          priority: priority,
          status: false,
        );

        print('Adding task: ${newTask.name}, priority: ${priority.value}');
        await DBHelper.insertTask(newTask);
        refresh(); // refresh task list

      },
    ),
  );
}