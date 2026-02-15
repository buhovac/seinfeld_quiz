import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const SeinfeldQuizApp());
    expect(find.text('DebugQuestionsScreen'), findsOneWidget);
  });
}
