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
  bool get isDone => widget.task.status == 1;

  /// Centralized title style
  TextStyle get titleStyle => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    decoration: isDone ? TextDecoration.lineThrough : null,
    decorationThickness: 2,
    color: isDone ? Colors.grey.shade500 : Colors.black,
  );

  /// Centralized description style
  TextStyle get descriptionStyle => TextStyle(
    fontSize: 18,
    decoration: isDone ? TextDecoration.lineThrough : null,
    decorationThickness: 1.5,
    color: isDone ? Colors.grey.shade500 : Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isDone ? Colors.green.shade50 : widget.task.priority,
      elevation: 6,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child: IconButton(
            key: ValueKey(isDone),
            tooltip: isDone ? 'Mark as incomplete' : 'Mark as completed',
            onPressed: widget.onToggle,
            icon:
                isDone
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(
                      Icons.radio_button_unchecked,
                      color: Color(0xff3b3b3b),
                    ),
          ),
        ),

        title: Text(widget.task.name, style: titleStyle),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.desc, style: descriptionStyle),
            const SizedBox(height: 4),
            Text(
              widget.task.date,
              style: TextStyle(
                fontSize: 14,
                color: isDone ? Colors.grey.shade500 : Colors.black54,
              ),
            ),
          ],
        ),

        /// IMPROVED UX: Grouped actions cleanly
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit task',
              onPressed: widget.onEdit,
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
            IconButton(
              tooltip: 'Delete task',
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),

        onTap: widget.onExpand,
      ),
    );
  }
}
