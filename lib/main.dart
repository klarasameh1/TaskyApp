import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/TaskProvider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // fontFamily: 'Outfit',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
