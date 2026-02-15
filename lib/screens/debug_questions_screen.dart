import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_validator.dart';
import '../services/question_repository.dart';


class DebugQuestionsScreen extends StatefulWidget {
  const DebugQuestionsScreen({super.key});

  @override
  State<DebugQuestionsScreen> createState() => _DebugQuestionsScreenState();
}

class _DebugQuestionsScreenState extends State<DebugQuestionsScreen> {
  late final Future<QuestionBank> _bankFuture;

  @override
  void initState() {
    super.initState();
    _bankFuture = QuestionRepository().load();
  }

  Map<String, int> _countByLevelCategory(List<Question> questions) {
    final map = <String, int>{};
    for (final q in questions) {
      final key = 'L${q.level}-C${q.categoryId}';
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug: Questions')),
      body: FutureBuilder<QuestionBank>(
        future: _bankFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Load error: ${snapshot.error}'),
            );
          }

          final bank = snapshot.data!;
          final validator = QuestionValidator();
          final errors = validator.validate(bank.questions);
          final counts = _countByLevelCategory(bank.questions);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Version: ${bank.version}'),
              Text('Questions loaded: ${bank.questions.length}'),
              const SizedBox(height: 12),

              Text(
                'Validation errors: ${errors.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: errors.isEmpty ? Colors.green : Colors.red,
                ),
              ),
              if (errors.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...errors.take(20).map((e) => Text('• $e')),
                if (errors.length > 20) Text('... +${errors.length - 20} more'),
              ],

              const SizedBox(height: 16),
              const Text('Counts by level/category:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(
                counts.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key))
              ).map(
                (e) => Text('${e.key}: ${e.value}'),
              ),

              const SizedBox(height: 16),
              const Text('Sample questions:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...bank.questions.take(3).map((q) {
                final correct = (q.correctIndex >= 0 && q.correctIndex < q.choices.length)
                    ? q.choices[q.correctIndex]
                    : 'INVALID';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('${q.id}: ${q.question}\nCorrect: $correct'),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
