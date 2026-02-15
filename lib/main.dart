import 'package:flutter/material.dart';
import 'screens/debug_questions_screen.dart';

void main() {
  runApp(const SeinfeldQuizApp());
}

class SeinfeldQuizApp extends StatelessWidget {
  const SeinfeldQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DebugQuestionsScreen(),
    );
  }
}
