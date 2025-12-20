import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class PendingTasks extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback refresh;

  const PendingTasks({super.key, required this.tasks, required this.refresh});

  @override
  State<PendingTasks> createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks> {
  @override
  Widget build(BuildContext context) {
    final pendingTasks = widget.tasks.where((task) => !task.status).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: pendingTasks.isEmpty
          ? const Center(
          child: Icon(
            Icons.pending_actions,
            color: Colors.grey,
            size: 40,
          ))
          : ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, i) {
          final task = pendingTasks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () async {
                await DBHelper.updateTaskStatus(task.id!, !task.status);
                widget.refresh();
              },
              onEdit: () {
                showEditDialog(context, task, widget.refresh);
              },
              onDelete: () async {
                await DBHelper.deleteTask(task.id!);
                widget.refresh();
              },
              onExpand: () {
                showDialog(
                  context: context,
                  builder: (_) => expandDialog(context, task),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
