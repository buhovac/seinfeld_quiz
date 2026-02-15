import '../models/question.dart';

class QuestionValidator {
  List<String> validate(List<Question> questions) {
    final errors = <String>[];

    final seenIds = <String>{};
    for (final q in questions) {
      if (q.id.trim().isEmpty) errors.add('Empty id');
      if (!seenIds.add(q.id)) errors.add('Duplicate id: ${q.id}');

      if (q.choices.length != 4) {
        errors.add('${q.id}: choices must be 4, got ${q.choices.length}');
      }

      if (q.correctIndex < 0 || q.correctIndex > 3) {
        errors.add('${q.id}: correctIndex out of range: ${q.correctIndex}');
      }

      if (q.level < 1 || q.level > 7) {
        errors.add('${q.id}: level out of range: ${q.level}');
      }

      if (q.categoryId < 1 || q.categoryId > 7) {
        errors.add('${q.id}: categoryId out of range: ${q.categoryId}');
      }

      if (q.question.trim().isEmpty) errors.add('${q.id}: empty question');

      final uniqueChoices = q.choices.toSet();
      if (uniqueChoices.length != q.choices.length) {
        errors.add('${q.id}: duplicate choices');
      }
    }

    return errors;
  }
}
