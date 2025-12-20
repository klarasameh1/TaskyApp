import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class AllTasks extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback refresh;

  const AllTasks({super.key, required this.tasks, required this.refresh});

  Future<void> toggleStatus(Task task) async {
    int newStatus;

    if (task.status == 0) {
      newStatus = 1; // pending -> completed
    } else if (task.status == 1) {
      newStatus = 0; // completed -> pending
    } else {
      newStatus = task.status; // archived stays archived
    }

    await DBHelper.updateTaskStatus(task.id!, newStatus);
    refresh(); //reload ALL tasks from database
  }

  Future<void> archiveTask(Task task) async {
    await DBHelper.updateTaskStatus(task.id!, 2);
    refresh();
  }


  Future<void> deleteTask(Task task) async {
    await DBHelper.deleteTask(task.id!);
    refresh(); //reload ALL tasks from database
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: tasks.isEmpty
          ? const Center(
        child: Icon(
          Icons.pending_actions,
          color: Colors.grey,
          size: 40,
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          final task = tasks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => toggleStatus(task),
              onEdit: () => showEditDialog(context, task, refresh),
              onArchive: () => archiveTask(task),
              onDelete: () => deleteTask(task),
              onExpand: () => showDialog(
                context: context,
                builder: (_) => expandDialog(context, task),
              ),
            ),
          );
        },
      ),
    );
  }
}