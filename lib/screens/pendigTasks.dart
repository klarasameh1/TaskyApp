import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class PendingTasks extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback refresh;

  const PendingTasks({super.key, required this.tasks, required this.refresh});

  Future<void> toggleStatus(Task task) async {
    await DBHelper.updateTaskStatus(task.id!, !task.status);
    refresh();
  }

  Future<void> deleteTask(Task task) async {
    await DBHelper.deleteTask(task.id!);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasks.where((task) => !task.status).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: pendingTasks.isEmpty
          ? const Center(
        child: Icon(
          Icons.pending_actions,
          color: Colors.grey,
          size: 40,
        ),
      )
          : ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, i) {
          final task = pendingTasks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => toggleStatus(task),
              onEdit: () => showEditDialog(context, task, refresh),
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
