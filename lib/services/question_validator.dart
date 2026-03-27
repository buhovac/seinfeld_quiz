import '/models/question.dart';

class QuestionValidator {
  static List<String> validate(Question q) {
    final errors = <String>[];

    // ID
    if (q.id.isEmpty) {
      errors.add('ID is empty');
    }

    // Category
    if (q.categoryId < 1 || q.categoryId > 5) {
      errors.add('Invalid categoryId: ${q.categoryId}');
    }

    // Level
    if (q.level < 1 || q.level > 3) {
      errors.add('Invalid level: ${q.level}');
    }

    // Question text
    if (q.question.trim().isEmpty) {
      errors.add('Question text is empty');
    }

    // Format
    if (q.questionFormat != 'text' && q.questionFormat != 'code') {
      errors.add('Invalid questionFormat: ${q.questionFormat}');
    }

    // Code validation
    if (q.questionFormat == 'code') {
      if (q.codeSnippet == null || q.codeSnippet!.trim().isEmpty) {
        errors.add('Code question missing codeSnippet');
      }
    }

    // Choices
    if (q.choices.length != 4) {
      errors.add('Question must have exactly 4 choices');
    } else {
      for (int i = 0; i < q.choices.length; i++) {
        if (q.choices[i].trim().isEmpty) {
          errors.add('Choice $i is empty');
        }
      }
    }

    // Correct index
    if (q.correctIndex < 0 || q.correctIndex > 3) {
      errors.add('Invalid correctIndex: ${q.correctIndex}');
    }

    return errors;
  }

  static bool isValid(Question q) {
    return validate(q).isEmpty;
  }

  static void validateOrThrow(Question q) {
    final errors = validate(q);
    if (errors.isNotEmpty) {
      throw Exception(
        'Invalid Question (${q.id}):\n${errors.join('\n')}',
      );
    }
  }
  static List<String> validateAll(List<Question> questions) {
    final errors = <String>[];

    for (final q in questions) {
      final e = validate(q);
      if (e.isNotEmpty) {
        errors.add('Question ${q.id}: ${e.join(", ")}');
      }
    }

    return errors;
  }
}