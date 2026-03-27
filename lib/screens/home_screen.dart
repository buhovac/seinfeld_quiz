import 'package:flutter/material.dart';
import '../config/app_quiz_config.dart';
import '../models/app_progress.dart';
import '../services/progress_service.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgressService _progressService = ProgressService();
  late Future<AppProgress> _progressFuture;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() {
    _progressFuture = _progressService.getProgress();
  }

  Future<void> _resetProgress() async {
    await _progressService.resetAll();
    setState(() {
      _loadProgress();
    });
  }
  String _levelLabel(int level) {
    switch (level) {
      case 1:
        return 'Novice';
      case 2:
        return 'Medium';
      case 3:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }

  void _openQuiz(int level, int categoryId) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => QuizScreen(level: level, categoryId: categoryId),
          ),
        )
        .then((_) {
          setState(() {
            _loadProgress();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appQuizConfig.appTitle)),
      body: FutureBuilder<AppProgress>(
        future: _progressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading progress: ${snapshot.error}'),
            );
          }

          final progress = snapshot.data ?? AppProgress.initial();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Unlocked levels are tracked separately for each category.',
                ),
                Text(
                  'Global score: ${progress.totalCorrect}/${progress.totalAnswered}',
                ),
                Text(
                  'Accuracy: ${progress.percentage.toStringAsFixed(1)}%',
                ),
                Text(
                  '${appQuizConfig.masteryTitle}: ${progress.fanMasterUnlocked ? "YES" : "NO"}',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      ...appQuizConfig.categories.map((category) {
                        final unlockedLevelForCategory =
                            progress.unlockedLevelForCategory(category.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(category.description),
                                const SizedBox(height: 8),
                                Text(
                                  'Unlocked up to level $unlockedLevelForCategory',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...List.generate(3, (index) {
                                  final level = index + 1;
                                  final unlocked = level <=
                                      progress.unlockedLevelForCategory(
                                        category.id,
                                      );

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ElevatedButton(
                                      onPressed: unlocked
                                          ? () => _openQuiz(level, category.id)
                                          : null,
                                      child: Text(
                                        unlocked
                                            ? 'Start ${category.title} - ${_levelLabel(level)}'
                                            : '${category.title} - ${_levelLabel(level)} Locked',
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _resetProgress,
                        child: const Text('Reset Progress'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}