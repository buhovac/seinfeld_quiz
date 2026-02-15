import '../models/question.dart';
import 'question_loader.dart';
import 'question_validator.dart';

class QuestionRepository {
  final QuestionLoader _loader;
  final QuestionValidator _validator;

  QuestionBank? _cache;

  QuestionRepository({
    QuestionLoader? loader,
    QuestionValidator? validator,
  })  : _loader = loader ?? QuestionLoader(),
        _validator = validator ?? QuestionValidator();

  Future<QuestionBank> load() async {
    if (_cache != null) return _cache!;
    final bank = await _loader.load();

    final errors = _validator.validate(bank.questions);
    assert(errors.isEmpty, errors.join('\n'));

    _cache = bank;
    return bank;
  }

  Future<List<Question>> all() async {
    final bank = await load();
    return bank.questions;
  }

  Future<List<Question>> byLevel(int level) async {
    final qs = await all();
    return qs.where((q) => q.level == level).toList();
  }

  Future<List<Question>> byCategory(int categoryId) async {
    final qs = await all();
    return qs.where((q) => q.categoryId == categoryId).toList();
  }

  Future<List<Question>> forGame({
    required int level,
    required int categoryId,
    required int count,
  }) async {
    final qs = await all();
    final pool = qs
        .where((q) => q.level == level && q.categoryId == categoryId)
        .toList();

    pool.shuffle();
    if (pool.length >= count) return pool.take(count).toList();

    // fail hard (bolje nego tiho) - nema dovoljno pitanja za taj mode
    throw StateError(
      'Not enough questions for L$level C$categoryId. Need $count, have ${pool.length}.',
    );
  }
}
