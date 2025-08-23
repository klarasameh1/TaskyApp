import 'package:flutter/material.dart';

class TaskListTile extends StatefulWidget {
  final String name;
  final String description;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color priority ;
  final VoidCallback onExpand;

  const TaskListTile({
    super.key,
    required this.name,
    required this.description,
    required this.isDone,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.priority,
    required this.onExpand,

  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool doneClick = false ;

  @override
  Widget build(BuildContext context) {
    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: widget.isDone?Colors.green.shade100: widget.priority, //✅
      elevation: 6,
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.15,
        child: ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child), // Nice zoom effect
            child:
            IconButton(
                onPressed:(){doneClick=!doneClick ; widget.onToggle();} ,

                icon : (doneClick)?
                  Icon(Icons.check_circle , color: Colors.green)
                : Icon(Icons.radio_button_unchecked, color: Color(0xff3b3b3b))
            )
          ),
          title: Text(
            widget.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration: widget.isDone ? TextDecoration.lineThrough: null,
              color: widget.isDone ? Colors.grey.shade500 : Colors.black,
              decorationThickness: 2
            ),
          ),
          subtitle: Text(
            widget.description
            ,style: TextStyle(
              fontSize: 18,
              decoration: widget.isDone ? TextDecoration.lineThrough: null,
              color: widget.isDone ? Colors.grey.shade500 : Colors.black,
              decorationThickness: 1.5,
            overflow: TextOverflow.ellipsis
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit, color: Color(0xff3b3b3b) , size:25,),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent , size: 25),
              ),
            ],
          ),
          onTap: widget.onExpand
        ),
      ),
    );
  }
}
