import 'package:first_app/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/database/helper/dp_helper.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Initialize database BEFORE running the app
  print('Initializing database...');
  await DBHelper.database; // This will create/initialize the database

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}