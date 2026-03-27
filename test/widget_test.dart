import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}