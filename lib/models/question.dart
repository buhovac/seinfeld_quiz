class Question {
  final String id;
  final int categoryId;
  final int level;
  final String type;
  final String questionFormat;
  final String question;
  final String codeLanguage;
  final String codeSnippet;
  final List<String> choices;
  final int correctIndex;
  final List<String> tags;
  final String sourceRef;

  const Question({
    required this.id,
    required this.categoryId,
    required this.level,
    required this.type,
    required this.questionFormat,
    required this.question,
    required this.codeLanguage,
    required this.codeSnippet,
    required this.choices,
    required this.correctIndex,
    required this.tags,
    required this.sourceRef,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      categoryId: json['categoryId'] as int,
      level: json['level'] as int,
      type: (json['type'] as String?) ?? 'concept',
      questionFormat: (json['questionFormat'] as String?) ?? 'text',
      question: json['question'] as String,
      codeLanguage: (json['codeLanguage'] as String?) ?? '',
      codeSnippet: (json['codeSnippet'] as String?) ?? '',
      choices: (json['choices'] as List).map((e) => e as String).toList(),
      correctIndex: json['correctIndex'] as int,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
      sourceRef: (json['sourceRef'] as String?) ?? '',
    );
  }
}

class QuestionBank {
  final int version;
  final List<Question> questions;

  const QuestionBank({
    required this.version,
    required this.questions,
  });

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    return QuestionBank(
      version: json['version'] as int,
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}