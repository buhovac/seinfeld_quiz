import 'package:flutter_test/flutter_test.dart';
import 'package:seinfeld_quiz/domain/level_rules.dart';

void main() {
  test('Level rules sanity', () {
    expect(LevelRules.questionsCount(1), 10);
    expect(LevelRules.passThreshold(1), 8);
    expect(LevelRules.label(1), 'Novice');

    expect(LevelRules.questionsCount(2), 10);
    expect(LevelRules.passThreshold(2), 8);
    expect(LevelRules.label(2), 'Medium');

    expect(LevelRules.questionsCount(3), 10);
    expect(LevelRules.passThreshold(3), 8);
    expect(LevelRules.label(3), 'Advanced');
  });

  test('Invalid levels throw', () {
    expect(() => LevelRules.questionsCount(0), throwsArgumentError);
    expect(() => LevelRules.questionsCount(4), throwsArgumentError);

    expect(() => LevelRules.passThreshold(0), throwsArgumentError);
    expect(() => LevelRules.passThreshold(4), throwsArgumentError);
  });
}