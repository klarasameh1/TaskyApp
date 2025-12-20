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
  int selectedItem = 0;
  List<Task> tasks = [];
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll([
      AllTasks(),
      PendingTasks(tasks: tasks, refresh: loadTasks)

    ]);
    loadTasks();
  }

  Future<void> loadTasks() async {
    final loaded = await DBHelper.getTasks();
    setState(() {
      tasks = loaded;
    });
  }

  Future<void> clearTasks() async {
    await DBHelper.clearTasks();
    setState(() {
      tasks.clear();
    });
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
            onPressed: clearTasks,
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StatsCard(
            name: widget.userName,
            count: tasks.length,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: selectedItem == 0
                ? AllTasks()
                : PendingTasks(tasks: tasks, refresh: loadTasks),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(context, loadTasks),
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
          onTap: (index) {
            setState(() {
              selectedItem = index;
            });
          },
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
