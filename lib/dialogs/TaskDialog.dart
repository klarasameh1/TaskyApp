import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final String title;
  final String initialName;
  final String initialDescription;
  final Color initialPriority;
  final Function(String, String, Color) onSubmit;

  const TaskDialog({
    super.key,
    required this.title,
    this.initialName = '',
    this.initialDescription = '',
    this.initialPriority = Colors.white70,
    required this.onSubmit,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late Color selectedPriority;
  late TextEditingController nameController ;
  late TextEditingController descController ;

  final Color red = Colors.redAccent.shade100;
  final Color orange = Colors.orangeAccent.shade100;
  final Color yellow = Colors.yellowAccent.shade100;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority; // Initialize here

     nameController = TextEditingController(text: widget.initialName);
     descController = TextEditingController(text: widget.initialDescription);

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Center(child: Text(widget.title , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22 , color: Colors.black87),)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width*0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Task name",
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
              decoration:  InputDecoration(
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
            Row(
              children: [
                const Text(
                  "Priority: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Red button
                _buildColorButton(red),
                // Orange button
                _buildColorButton(orange),
                // Yellow button
                _buildColorButton(yellow),
              ],
            ),
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
                    const SnackBar(content: Text("Task name is required") , duration: Duration(seconds: 5),),
                  );
                  return;
                }
                widget.onSubmit(nameController.text, descController.text , selectedPriority);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child:  Text("Save", style: TextStyle(color: Colors.white , fontSize: 16) ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Color(0xff3b3b3b) , fontSize: 16 , fontWeight: FontWeight.bold)),
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
            color: selectedPriority == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(Icons.circle, color: color, size: 28),
      ),
    );
  }
}
