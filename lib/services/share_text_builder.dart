import '../config/quiz_config.dart';
import '../domain/quiz_state.dart';

class ShareTextBuilder {
  static String build({
    required QuizResult result,
    required QuizConfig config,
  }) {
    final accuracy = ((result.correct / result.total) * 100).toStringAsFixed(1);

    if (result.level == 7 && result.passed) {
      return 'I achieved ${config.masteryTitle} status with a perfect ${result.correct}/${result.total} on the ultimate questions. Accuracy: $accuracy%.';
    }

    if (!result.passed && result.level == 1) {
      return 'I am a ${config.beginnerTitle}, working on it... I scored ${result.correct}/${result.total} on Level 1 of the ${config.quizSubjectName} quiz. Accuracy: $accuracy%.';
    }

    if (!result.passed) {
      return 'I failed Level ${result.level} of the ${config.quizSubjectName} quiz with ${result.correct}/${result.total}. Accuracy: $accuracy%.';
    }

    return 'I cleared Level ${result.level} of the ${config.quizSubjectName} quiz with ${result.correct}/${result.total}. Accuracy: $accuracy%.';
  }
}