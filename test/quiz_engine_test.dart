import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/domain/level_rules.dart';

void main() {
  test('Level rules sanity', () {
    expect(LevelRules.questionsCount(1), 10);
    expect(LevelRules.passThreshold(1), 8);
    expect(LevelRules.questionsCount(7), 20);
    expect(LevelRules.passThreshold(7), 20);
  });
}
