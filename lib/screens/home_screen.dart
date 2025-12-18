import 'package:first_app/providers/TaskProvider.dart';
import 'package:first_app/screens/pendigTasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/addDialog.dart';
import '../widgets/stats_card.dart';
import 'allTasks.dart';

class HomeScreen extends StatefulWidget {
  final String userName; //  store the username here

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItem = 0;
  final List<Widget> pages = [AllTasks(), PendingTasks()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
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
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).clearTaskList();
            },
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          )
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          StatsCard(
            name: widget.userName,
            count: context.watch<TaskProvider>().tasks.length,
          ),
          const SizedBox(height: 15),
          Expanded(child: pages[selectedItem]),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
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
