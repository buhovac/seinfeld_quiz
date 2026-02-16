import '../models/question.dart';

class QuizState {
  final int level;
  final int categoryId;
  final List<Question> questions;
  final int currentIndex;
  final int correct;
  final int answered;
  final bool finished;

  const QuizState({
    required this.level,
    required this.categoryId,
    required this.questions,
    required this.currentIndex,
    required this.correct,
    required this.answered,
    required this.finished,
  });

  Question get current => questions[currentIndex];

  QuizState copyWith({
    int? currentIndex,
    int? correct,
    int? answered,
    bool? finished,
  }) {
    return QuizState(
      level: level,
      categoryId: categoryId,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correct: correct ?? this.correct,
      answered: answered ?? this.answered,
      finished: finished ?? this.finished,
    );
  }
}

class QuizResult {
  final int level;
  final int categoryId;
  final int correct;
  final int total;
  final bool passed;

  const QuizResult({
    required this.level,
    required this.categoryId,
    required this.correct,
    required this.total,
    required this.passed,
  });
}
