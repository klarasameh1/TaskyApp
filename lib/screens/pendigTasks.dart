import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class PendingTasks extends StatelessWidget {
  final List<MapEntry<dynamic, Task>> tasksWithKeys; // Hive key + Task
  final VoidCallback refresh;

  const PendingTasks({super.key, required this.tasksWithKeys, required this.refresh});

  Future<void> toggleStatus(dynamic key, Task task) async {
    await DBHelper.updateTaskStatus(key, 1); // mark as done
    refresh();
  }

  Future<void> archiveTask(dynamic key) async {
    await DBHelper.updateTaskStatus(key, 2); // mark as archived
    refresh();
  }

  Future<void> deleteTask(dynamic key) async {
    await DBHelper.deleteTask(key);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasksWithKeys.where((entry) => entry.value.status == 0).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: pendingTasks.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_actions,
              color: Colors.grey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'Tap + to add your first task',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, i) {
          final entry = pendingTasks[i];
          final key = entry.key;
          final task = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(key), // use Hive key
              task: task,
              onToggle: () => toggleStatus(key, task),
              onEdit: () => showEditDialog(context, key, task, refresh), // ✅ pass key
              onDelete: () => deleteTask(key),
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
