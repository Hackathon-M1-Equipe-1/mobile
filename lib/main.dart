import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      home: const HomeScreen(),
    );
  }
}