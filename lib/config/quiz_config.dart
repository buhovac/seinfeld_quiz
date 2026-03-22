import '../models/quiz_category.dart';

class QuizConfig {
  final String appTitle;
  final String masteryTitle;
  final String beginnerTitle;
  final String quizSubjectName;
  final List<QuizCategory> categories;

  const QuizConfig({
    required this.appTitle,
    required this.masteryTitle,
    required this.beginnerTitle,
    required this.quizSubjectName,
    required this.categories,
  });

  QuizCategory? getCategoryById(int id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}