import 'package:first_app/widgets/appBar.dart';
import 'package:flutter/material.dart';
import '../dialogs/addDialog.dart';
import '../widgets/stats_card.dart';
import 'allTasks.dart';
import 'pendigTasks.dart';
import '../database/helper/dp_helper.dart';
import '../models/Task.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItem = 0; //index for the bottom navbar
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); //load tasks when screen is opened
  }

  Future<void> _loadTasks() async {
      final loaded = await DBHelper.getTasks(); //fetch from sqlite
      setState(() => tasks = loaded);
  }

  Future<void> _clearTasks() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Tasks"),
        content: const Text("Are you sure you want to delete all tasks?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DBHelper.clearTasks();
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      body: Column(
        children: [
          CustomAppBar(userName: widget.userName, count:tasks.where((task) => task.status==0).length,),
          Expanded(
            child: Builder(
              builder: (_) {
                switch (selectedItem) {
                  case 0:
                    return AllTasks(
                      tasks: tasks,
                      refresh: _loadTasks,
                    );
                  case 1:
                    return PendingTasks(
                      tasks: tasks,
                      refresh: _loadTasks,
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedItem == 0   // only for AllTasks tab
          ? FloatingActionButton(
        onPressed: () => showAddDialog(context, _loadTasks),
        backgroundColor: Colors.black,
        elevation: 8,
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      )
          : null,

      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width*0.6,
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
                  child: Text(
                      'TaskFlow',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ),
            ListTile(
              title: const Text('Clear All' ,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),
              ),
              trailing: Icon(Icons.delete_sweep_outlined, size: 25 , color: Colors.white,),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Clear Finished ' ,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),
              ),
              trailing: Icon(Icons.cleaning_services_outlined, size: 25 , color: Colors.white,),
              onTap: () {
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          currentIndex: selectedItem,
          onTap: (index) => setState(() => selectedItem = index),
          items: const [
            BottomNavigationBarItem(
              label: "All Tasks",
              icon: Icon(Icons.library_books_outlined),
            ),
            BottomNavigationBarItem(
              label: "Pending Tasks",
              icon: Icon(Icons.pending_actions_outlined),
            ),
          ],
        ),
      ),
    );
  }
}