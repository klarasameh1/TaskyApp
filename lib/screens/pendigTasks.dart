import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../providers/TaskProvider.dart';

class PendingTasks extends StatelessWidget {
  const PendingTasks({super.key});

  @override
  Widget build(BuildContext context) {
    var taskProvider = context.watch<TaskProvider>();

    // Filter tasks: only tasks where status == false
    final pendingTasks =
        taskProvider.tasks.where((task) => task['status'] == false).toList();

    return Padding(
      padding: const EdgeInsets.only(right: 30 , left: 30),
      child:
          pendingTasks.isEmpty
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
                      name: task['name'],
                      description: task['Desc'],
                      isDone: task['status'],
                      priority: task['Priority'],
                      onToggle: () {
                        // Find original index in full list
                        final originalIndex = taskProvider.tasks.indexOf(task);
                        taskProvider.toggleStatus(originalIndex);
                      },
                      onEdit: () {
                        final originalIndex = taskProvider.tasks.indexOf(task);
                        showEditDialog(context, originalIndex);
                      },
                      onDelete: () {
                        final originalIndex = taskProvider.tasks.indexOf(task);
                        taskProvider.deleteTask(originalIndex);
                      },
                      onExpand: (){
                        final originalIndex = taskProvider.tasks.indexOf(task);
                        showDialog(
                          context: context,
                          builder: (context) => expandDialog(context, i),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
