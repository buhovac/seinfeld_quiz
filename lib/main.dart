import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SeinfeldQuizApp());
}

class SeinfeldQuizApp extends StatelessWidget {
  const SeinfeldQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seinfeld Quiz',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
