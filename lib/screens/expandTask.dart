import 'package:flutter/material.dart';
import '../dialogs/editDialog.dart';
import '../dialogs/expandDialog.dart';
import '../widgets/TaskListTile.dart';
import '../models/Task.dart';
import '../database/helper/dp_helper.dart';

class Expandtask extends StatelessWidget {

  final Task task ;
  const Expandtask({super.key , required this.task});


  Future<void> deleteTask(Task task) async {
    await DBHelper.deleteTask(task.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: task.priority,
      appBar: AppBar(
        title: Text(task.name),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, // makes the back arrow white
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title
            Text(
              task.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Description
            Text(
              task.desc.isEmpty
                  ? 'No description provided.'
                  : task.desc,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

// 🔴 Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // changed from red to black
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.delete, color: Colors.white), // ensure icon is visible
                label: const Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.white), // ensure text is visible
                ),
                onPressed: () async {
                  final confirmed = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await DBHelper.deleteTask(task.id!);
                    Navigator.pop(context, true); // return success
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}