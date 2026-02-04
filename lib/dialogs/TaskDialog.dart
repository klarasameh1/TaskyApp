import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final String title;
  final String initialName;
  final String initialDescription;
  final String date;
  final Color initialPriority;
  final Function(String, String, Color, String) onSubmit;

  const TaskDialog({
    super.key,
    required this.title,
    this.initialName = '',
    this.initialDescription = '',
    this.initialPriority = const Color(0xB3FFFFFF), // white70
    this.date = '',
    required this.onSubmit,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late Color selectedPriority;
  late TextEditingController nameController;
  late TextEditingController descController;
  late String selectedDate;

  // Priority colors
  final List<Color> priorityColors = [
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    const Color(0xFFFFFFFF),
  ];

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority;
    nameController = TextEditingController(text: widget.initialName);
    descController = TextEditingController(text: widget.initialDescription);
    selectedDate = widget.date.isEmpty
        ? DateTime.now().toString().substring(0, 10)
        : widget.date;
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Color: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Color buttons
                ...priorityColors.map((color) => _buildColorButton(color)),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Title",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descController,
              maxLines: 3,
              minLines: 2,
              expands: false,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: "Description",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: pickDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: Colors.black87),
                  const SizedBox(width: 10),
                  Text(
                    selectedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Task name is required"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                widget.onSubmit(
                  nameController.text.trim(),
                  descController.text.trim(),
                  selectedPriority,
                  selectedDate,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xff3b3b3b),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedPriority = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedPriority.value == color.value
                ? Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(Icons.circle, color: color, size: 28),
      ),
    );
  }
}