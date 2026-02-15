class Question {
  final String id;
  final int categoryId;
  final int level;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final List<String> tags;

  const Question({
    required this.id,
    required this.categoryId,
    required this.level,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.tags,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      categoryId: json['categoryId'] as int,
      level: json['level'] as int,
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e as String).toList(),
      correctIndex: json['correctIndex'] as int,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }
}

class QuestionBank {
  final int version;
  final List<Question> questions;

  const QuestionBank({required this.version, required this.questions});

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    return QuestionBank(
      version: json['version'] as int,
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
