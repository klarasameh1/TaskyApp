import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TaskProvider.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ use watch instead of read so UI updates automatically
    var taskProvider = context.watch<TaskProvider>();

    int allTasks = taskProvider.tasks.length;
    int doneTasks = taskProvider.tasks.where((t) => t['status']).length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // progress card
        Card(
          color: const Color(0xffA7C1A8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Text(
                  "$doneTasks / $allTasks",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),


        // delete button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            taskProvider.clearTasklist();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ avoids unnecessary height
            children: const [
              Text("Clear All" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),),
              SizedBox(height: 5),
              Icon(Icons.delete_sweep_outlined, size: 25 , color: Colors.black,),
            ],
          ),
        ),
      ],
    );
  }
}
