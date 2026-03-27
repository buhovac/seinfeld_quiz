import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_quiz_config.dart';
import '../domain/level_rules.dart';
import '../domain/quiz_engine.dart';
import '../domain/quiz_state.dart';
import '../services/progress_service.dart';
import '../services/share_text_builder.dart';

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
  final QuizEngine _engine = QuizEngine();
  final ProgressService _progressService = ProgressService();

  QuizState? _state;
  QuizResult? _result;
  Object? _error;

  bool _locked = false;

  bool get _hasNextLevel {
    return _result != null && _result!.passed && widget.level < 3;
  }

  bool get _isCategoryComplete {
    return _result != null && _result!.passed && widget.level == 3;
  }

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

      if (!mounted) return;

      setState(() {
        _state = s;
        _result = null;
        _error = null;
        _locked = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e;
        _locked = false;
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

  void _goToNextLevel() {
    if (!_hasNextLevel) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          level: widget.level + 1,
          categoryId: widget.categoryId,
        ),
      ),
    );
  }

  void _answer(int choiceIndex) {
    if (_locked) return;
    _locked = true;

    try {
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
    } catch (e) {
      setState(() {
        _error = e;
        _locked = false;
      });
    }
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (_state == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_result != null) {
      final r = _result!;
      final categoryTitle =
          appQuizConfig.getCategoryById(r.categoryId)?.title ??
          'Category ${r.categoryId}';
      final accuracy = ((r.correct / r.total) * 100).toStringAsFixed(1);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$categoryTitle / ${LevelRules.label(r.level)}',
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
              const SizedBox(height: 8),
              Text(
                'Accuracy: $accuracy%',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                r.passed ? 'PASSED' : 'FAILED',
                style: const TextStyle(fontSize: 22),
              ),
              const Spacer(),
              if (_hasNextLevel) ...[
                ElevatedButton(
                  onPressed: _goToNextLevel,
                  child: const Text('Next Level'),
                ),
                const SizedBox(height: 8),
              ],
              if (_isCategoryComplete) ...[
                const Text(
                  'Category Complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
    final categoryTitle =
        appQuizConfig.getCategoryById(s.categoryId)?.title ??
        'Category ${s.categoryId}';

    final hasCodeBlock =
        q.questionFormat == 'code' &&
        q.codeSnippet != null &&
        q.codeSnippet!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$categoryTitle - ${LevelRules.label(s.level)} (${s.currentIndex + 1}/${s.questions.length})',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (s.currentIndex + 1) / s.questions.length,
            ),
            const SizedBox(height: 16),
            Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasCodeBlock) _buildCodeBlock(q.codeSnippet!),
            if (!hasCodeBlock) const SizedBox(height: 16),
            ...List.generate(4, (i) {
              final choiceText = q.choices[i].trim().isEmpty
                  ? '(empty choice)'
                  : q.choices[i];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: _locked ? null : () => _answer(i),
                  child: Text(choiceText),
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
}import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_quiz_config.dart';
import '../domain/level_rules.dart';
import '../domain/quiz_engine.dart';
import '../domain/quiz_state.dart';
import '../services/progress_service.dart';
import '../services/share_text_builder.dart';

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
  final QuizEngine _engine = QuizEngine();
  final ProgressService _progressService = ProgressService();

  QuizState? _state;
  QuizResult? _result;
  Object? _error;

  bool _locked = false;

  bool get _hasNextLevel {
    return _result != null && _result!.passed && widget.level < 3;
  }

  bool get _isCategoryComplete {
    return _result != null && _result!.passed && widget.level == 3;
  }

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

      if (!mounted) return;

      setState(() {
        _state = s;
        _result = null;
        _error = null;
        _locked = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e;
        _locked = false;
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

  void _goToNextLevel() {
    if (!_hasNextLevel) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          level: widget.level + 1,
          categoryId: widget.categoryId,
        ),
      ),
    );
  }

  void _answer(int choiceIndex) {
    if (_locked) return;
    _locked = true;

    try {
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
    } catch (e) {
      setState(() {
        _error = e;
        _locked = false;
      });
    }
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (_state == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_result != null) {
      final r = _result!;
      final categoryTitle =
          appQuizConfig.getCategoryById(r.categoryId)?.title ??
          'Category ${r.categoryId}';
      final accuracy = ((r.correct / r.total) * 100).toStringAsFixed(1);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$categoryTitle / ${LevelRules.label(r.level)}',
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
              const SizedBox(height: 8),
              Text(
                'Accuracy: $accuracy%',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                r.passed ? 'PASSED' : 'FAILED',
                style: const TextStyle(fontSize: 22),
              ),
              const Spacer(),
              if (_hasNextLevel) ...[
                ElevatedButton(
                  onPressed: _goToNextLevel,
                  child: const Text('Next Level'),
                ),
                const SizedBox(height: 8),
              ],
              if (_isCategoryComplete) ...[
                const Text(
                  'Category Complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
    final categoryTitle =
        appQuizConfig.getCategoryById(s.categoryId)?.title ??
        'Category ${s.categoryId}';

    final hasCodeBlock =
        q.questionFormat == 'code' &&
        q.codeSnippet != null &&
        q.codeSnippet!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$categoryTitle - ${LevelRules.label(s.level)} (${s.currentIndex + 1}/${s.questions.length})',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (s.currentIndex + 1) / s.questions.length,
            ),
            const SizedBox(height: 16),
            Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasCodeBlock) _buildCodeBlock(q.codeSnippet!),
            if (!hasCodeBlock) const SizedBox(height: 16),
            ...List.generate(4, (i) {
              final choiceText = q.choices[i].trim().isEmpty
                  ? '(empty choice)'
                  : q.choices[i];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: _locked ? null : () => _answer(i),
                  child: Text(choiceText),
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