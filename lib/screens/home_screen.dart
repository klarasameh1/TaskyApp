import 'package:flutter/material.dart';
import '../dialogs/addDialog.dart';
import '../widgets/stats_card.dart';
import 'allTasks.dart';
import 'archivedTasks.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "TaskFlow",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Text(
              "Organize your day Simply",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
        actions: selectedItem == 0
            ? [
          IconButton(
            onPressed: _clearTasks,
            icon: const Icon(Icons.delete, color: Colors.white),
          )
        ]
            : null,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu , color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StatsCard(
            name: widget.userName,
            count: tasks.where((task) => task.status==0).length,
          ),
          const SizedBox(height: 15),
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
                  case 2:
                    return ArchivedTasks(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedItem == 0   // only for AllTasks tab
          ? FloatingActionButton(
        onPressed: () => showAddDialog(context, _loadTasks),
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        elevation: 3,
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      )
          : null,

      drawer: Drawer(
        width: MediaQuery.of(context).size.width*0.6,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('LogOut'),
              trailing: Icon(Icons.logout, size: 25),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
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
            BottomNavigationBarItem(
              label: "Archived",
              icon: Icon(Icons.archive_outlined),
            ),
          ],
        ),
      ),
    );
  }
}