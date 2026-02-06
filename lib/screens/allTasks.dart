import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';
import 'expandTask.dart';

class AllTasks extends StatelessWidget {
  final List<MapEntry<dynamic, Task>> tasksWithKeys; // Hive key + Task
  final VoidCallback refresh;

  const AllTasks({super.key, required this.tasksWithKeys, required this.refresh});

  Future<void> toggleStatus(dynamic key, Task task) async {
    int newStatus;

    if (task.status == 0) {
      newStatus = 1; // pending -> completed
    } else if (task.status == 1) {
      newStatus = 0; // completed -> pending
    } else {
      newStatus = task.status;
    }

    await DBHelper.updateTaskStatus(key, newStatus);
    refresh(); // reload tasks from database
  }

  Future<void> deleteTask(dynamic key) async {
    await DBHelper.deleteTask(key);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final tasksList = tasksWithKeys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: tasksList.isEmpty
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
            )
          ],
        ),
      )
          : ListView.builder(
        itemCount: tasksList.length,
        itemBuilder: (context, i) {
          final entry = tasksList[i];
          final key = entry.key;
          final task = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
              key: ValueKey(key), // Hive key as unique identifier
              task: task,
              onToggle: () => toggleStatus(key, task),
              onEdit: () => showEditDialog(context, key, task, refresh), // ✅ pass key
              onDelete: () => deleteTask(key),
              onExpand: () async {
                final deleted = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Expandtask(
                      keyId: key, // ✅ pass Hive key
                      task: task,
                    ),
                  ),
                );

                if (deleted == true) {
                  refresh(); // reload tasks
                }
              },
            ),
          );
        },
      ),
    );
  }
}
