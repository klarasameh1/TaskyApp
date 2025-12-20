import 'package:flutter/material.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class ArchivedTasks extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback refresh;

  const ArchivedTasks({super.key, required this.tasks, required this.refresh});

  Future<void> deleteTask(Task task) async {
    await DBHelper.deleteTask(task.id!);
    refresh();
  }

  Future<void> restoreTask(Task task) async {
    await DBHelper.updateTaskStatus(task.id!, 0); // 0 = pending
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final archivedTasks = tasks.where((task) => task.status == 2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: archivedTasks.isEmpty
          ? const Center(
        child: Icon(
          Icons.archive_outlined,
          color: Colors.grey,
          size: 40,
        ),
      )
          : ListView.builder(
        itemCount: archivedTasks.length,
        itemBuilder: (context, i) {
          final task = archivedTasks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(task.id),
              task: task,
              // cant edit or change on archived
              onToggle: () {},
              onEdit: () {},
              onDelete: () => deleteTask(task),
              // Restore back to pending
              onArchive: () => restoreTask(task),
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
