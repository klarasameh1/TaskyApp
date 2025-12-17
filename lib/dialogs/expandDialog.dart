import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/TaskProvider.dart';


 AlertDialog expandDialog(BuildContext context, int index) {
  final taskProvider = context.watch<TaskProvider>();
  final task = taskProvider.tasks[index];

  return AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),

    title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.name ,
              style: TextStyle(
                  fontWeight: FontWeight.bold ,
                  fontSize: 30 ,
                  color: Colors.black
              ),
              overflow: TextOverflow.ellipsis, // ✅ prevent overflow
            ),
            SizedBox(width: 8,),
            Icon(Icons.circle , color: task.priorityColor, size: 40,),
          ],
        )
    ),

    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.4,

          decoration:  BoxDecoration(
            border:
            Border.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
              strokeAlign : BorderSide.strokeAlignInside,
            )
          ),
          child: Center(
            child: SingleChildScrollView( // ✅ scroll if desc is too long
              child: Text(
                task.desc,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),

    actions: [
      Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child:  Text("Exit", style: TextStyle(color: Colors.white , fontSize: 16) ),
        ),
      ),

    ],
  );
}
