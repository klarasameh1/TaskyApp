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
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),        // 👈 circular edges
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name.isNotEmpty ? "Hello, $name 👋🏻" : "Welcome 👋🏻",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            count > 0
                ? "You have $count tasks pending"
                : "No tasks available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
