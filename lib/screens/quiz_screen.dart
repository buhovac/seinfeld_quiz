import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/quiz_engine.dart';
import '../domain/quiz_state.dart';
import '../services/progress_service.dart';
import '../services/share_text_builder.dart';
import '../config/app_quiz_config.dart';

class QuizScreen extends StatefulWidget {
  final int level;
  final int categoryId;

  const QuizScreen({
    super.key,
    required this.level,
    required this.categoryId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _engine = QuizEngine();
  final _progressService = ProgressService();

  QuizState? _state;
  QuizResult? _result;
  Object? _error;

  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final s = await _engine.start(
        level: widget.level,
        categoryId: widget.categoryId,
      );

      setState(() {
        _state = s;
        _result = null;
        _error = null;
        _locked = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  Future<void> _shareResult(QuizResult result) async {
    final text = ShareTextBuilder.build(
      result: result,
      config: appQuizConfig,
    );

    await SharePlus.instance.share(
      ShareParams(text: text),
    );
  }

  void _answer(int choiceIndex) {
    if (_locked) return;
    _locked = true;

    final s = _engine.answer(choiceIndex);

    if (s.finished) {
      final r = _engine.finish();

      _progressService.updateAfterQuiz(r).then((_) {
        if (!mounted) return;

        setState(() {
          _state = s;
          _result = r;
          _locked = false;
        });
      }).catchError((e) {
        if (!mounted) return;

        setState(() {
          _error = e;
          _locked = false;
        });
      });

      return;
    }

    setState(() {
      _state = s;
      _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $_error'),
        ),
      );
    }

    if (_state == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_result != null) {
      final r = _result!;

      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Level ${r.level} / ${appQuizConfig.getCategoryById(r.categoryId)?.title ?? "Category ${r.categoryId}"}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Score: ${r.correct}/${r.total}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                r.passed ? 'PASSED' : 'FAILED',
                style: const TextStyle(fontSize: 22),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _start,
                child: const Text('Play again'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _shareResult(r),
                child: const Text('Share Result'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    final s = _state!;
    final q = s.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'L${s.level} ${appQuizConfig.getCategoryById(s.categoryId)?.title ?? "Category ${s.categoryId}"} (${s.currentIndex + 1}/${s.questions.length})',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: _locked ? null : () => _answer(i),
                  child: Text(q.choices[i]),
                ),
              );
            }),
            const Spacer(),
            Text(
              'Correct: ${s.correct} / Answered: ${s.answered}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}