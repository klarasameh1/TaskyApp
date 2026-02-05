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
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                count > 0 ? Icons.pending_actions_sharp : Icons.check_circle_sharp,
                size: 28,
                color: count > 0 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count > 0 ? "You have" : "All Done!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    count > 0 ? "$count tasks waiting" : "Great work!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: count > 0 ? Colors.red: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}