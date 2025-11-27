import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String name;
  final int count;

  const StatsCard({
    super.key,
    this.name = '',
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.transparent,
      shadowColor: Colors.black,
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              "Hello $name 👋",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              count > 0
                  ? "You have $count tasks to do"
                  : "No tasks yet 🎉",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
