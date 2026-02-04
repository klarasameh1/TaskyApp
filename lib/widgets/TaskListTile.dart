import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onExpand;
  final VoidCallback onArchive;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onExpand,
    required this.onArchive,
  });

  bool get isDone => task.status == 1;

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

  /// Priority → Color mapping (decouples UI from model)
  Color get cardColor {
    if (isDone) return Colors.green.shade50;

    switch (task.priority) {
      case 1:
        return Colors.red.shade100;
      case 2:
        return Colors.orange.shade100;
      case 3 :
        return Colors.yellow.shade100;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
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
            onPressed: onToggle,
            icon:
                isDone
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(
                      Icons.radio_button_unchecked,
                      color: Color(0xff3b3b3b),
                    ),
          ),
        ),

        title: Text(task.name, style: titleStyle),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.desc, style: descriptionStyle),
            const SizedBox(height: 4),
            Text(
              task.date,
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
              tooltip: 'Archive task',
              onPressed: onArchive,
              icon: const Icon(Icons.archive_outlined, color: Colors.grey),
            ),
            IconButton(
              tooltip: 'Edit task',
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
            IconButton(
              tooltip: 'Delete task',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),

        onTap: onExpand,
      ),
    );
  }
}
