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

  Future<void> toggleStatus(int index) async {
    final task = tasks[index];
    await DBHelper.updateTaskStatus(task.id!, !task.status);
    refresh();
  }

  Future<void> deleteTask(int index) async {
    await DBHelper.deleteTask(tasks[index].id!);
    refresh();
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
              onToggle: () => toggleStatus(i),
              onEdit: () => showEditDialog(context, task, refresh),
              onDelete: () => deleteTask(i),
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
