import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../providers/TaskProvider.dart';


class AllTasks extends StatelessWidget {
  const AllTasks({super.key});

  @override
  Widget build(BuildContext context) {
    var taskProvider = context.watch<TaskProvider>();

    return Padding(
      padding: const EdgeInsets.only( right: 30 , left: 30),
      child: taskProvider.tasks.isEmpty
          ?  Center(
        child: Icon(
          Icons.pending_actions,
          color: Colors.grey,
          size: 40,
        ),
      )
          : ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, i) {
          final task = taskProvider.tasks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskListTile(
                key: ValueKey(task.id), // 👈 important for correct rebuilds
                task: task,
                onToggle: () => taskProvider.toggleStatus(i),
              onEdit: () => showEditDialog(context, i),
              onDelete: () => taskProvider.deleteTask(i),
              onExpand: () => showDialog(
                context: context,
                builder: (context) => expandDialog(context, i),
              )
            ),
          );
        },
      ),
    );
  }
}
