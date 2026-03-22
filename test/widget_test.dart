import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Debug: Questions'), findsOneWidget);
  });
}
