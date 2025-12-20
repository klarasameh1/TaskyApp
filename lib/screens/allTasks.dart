import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../database/helper/dp_helper.dart';
import '../models/Task.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final loaded = await DBHelper.getTasks();
    setState(() {
      tasks = loaded;
    });
  }

  Future<void> toggleStatus(int index) async {
    final task = tasks[index];
    await DBHelper.updateTaskStatus(task.id!, !task.status);
    loadTasks();
  }

  Future<void> deleteTask(int index) async {
    await DBHelper.deleteTask(tasks[index].id!);
    setState(() {
      tasks.removeAt(index);
    });
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
          ))
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
              onEdit: () => showEditDialog(context, task, loadTasks),
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
