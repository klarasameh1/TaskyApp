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
      appBar: AppBar(
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "TaskyApp",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _clearTasks,
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StatsCard(
            name: widget.userName,
            count: tasks.where((task) => !task.status).length,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: selectedItem == 0
                ? AllTasks(
              tasks: tasks,
              refresh: _loadTasks,
            )
                : PendingTasks(
              tasks: tasks,
              refresh: _loadTasks,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(context, _loadTasks),
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        elevation: 3,
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          unselectedItemColor: Colors.white24,
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