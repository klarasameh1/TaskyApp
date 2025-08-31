import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onExpand;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onExpand,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: widget.task.status
          ? Colors.green.shade100
          : widget.task.priority, // ✅ use Task object
      elevation: 6,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: IconButton(
              onPressed: widget.onToggle,
              icon: widget.task.status
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.radio_button_unchecked, color: Color(0xff3b3b3b)),
            )

          ),
          title: Text(
            widget.task.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration:
              widget.task.status ? TextDecoration.lineThrough : null,
              color: widget.task.status ? Colors.grey.shade500 : Colors.black,
              decorationThickness: 2,
            ),
          ),
          subtitle: Text(
            widget.task.desc,
            style: TextStyle(
              fontSize: 18,
              decoration:
              widget.task.status ? TextDecoration.lineThrough : null,
              color: widget.task.status ? Colors.grey.shade500 : Colors.black,
              decorationThickness: 1.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit,
                    color: Color(0xff3b3b3b), size: 25),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 25),
              ),
            ],
          ),
          onTap: widget.onExpand,
        ),
      ),
    );
  }
}
