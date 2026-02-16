import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const SeinfeldQuizApp());

    // provjeri da se prikazuje AppBar title iz DebugQuestionsScreen
    expect(find.text('Debug: Questions'), findsOneWidget);
  });
}
