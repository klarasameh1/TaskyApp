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
  int selectedItem = 0; // index for the bottom navbar
  List<MapEntry<dynamic, Task>> tasks = []; // Hive key + Task

  @override
  void initState() {
    super.initState();
    _loadTasks(); // load tasks when screen is opened
  }

  Future<void> _loadTasks() async {
    final loaded = await DBHelper.getTasks(); // should return List<MapEntry<dynamic, Task>>
    setState(() => tasks = loaded);
  }

  Future<void> _clearTasks() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Clear All Tasks"),
        content: const Text("Are you sure you want to delete all tasks?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DBHelper.clearTasks();
      await _loadTasks();
    }
  }

  Future<void> _clearFinishedTasks() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Finished Tasks"),
        content: const Text("Are you sure you want to delete all finished tasks?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DBHelper.clearFinishedTasks();
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    // number of pending tasks
    final pendingCount = tasks.where((entry) => entry.value.status == 0).length;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      body: Column(
        children: [
          CustomAppBar(userName: widget.userName, count: pendingCount),
          Expanded(
            child: Builder(
              builder: (_) {
                switch (selectedItem) {
                  case 0:
                    return AllTasks(
                      tasksWithKeys: tasks,
                      refresh: _loadTasks,
                    );
                  case 1:
                    return PendingTasks(
                      tasksWithKeys: tasks,
                      refresh: _loadTasks,
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedItem == 0
          ? FloatingActionButton(
        onPressed: () => showAddDialog(context, _loadTasks),
        backgroundColor: Colors.black,
        elevation: 8,
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      )
          : null,

      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const Divider(color: Colors.black),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.black),
                      title: const Text(
                        'Clear All Tasks',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onTap: tasks.isEmpty
                          ? null
                          : () {
                        Navigator.pop(context);
                        _clearTasks();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_outlined, color: Colors.black),
                      title: const Text(
                        'Clear Finished Tasks',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onTap: tasks.any((entry) => entry.value.status == 1)
                          ? () {
                        Navigator.pop(context);
                        _clearFinishedTasks();
                      }
                          : null,
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.black),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'v1.0.0 | Klara Sameh',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.black),
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
