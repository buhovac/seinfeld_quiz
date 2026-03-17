import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Seinfeld Quiz')),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Unlocked level: ${progress.highestUnlockedLevel}'),
                Text(
                  'Global score: ${progress.totalCorrect}/${progress.totalAnswered}',
                ),
                Text(
                  'Accuracy: ${progress.percentage.toStringAsFixed(1)}%',
                ),
                Text(
                  'Fan Master: ${progress.fanMasterUnlocked ? "YES" : "NO"}',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Levels',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...List.generate(7, (index) {
                  final level = index + 1;
                  final unlocked = level <= progress.highestUnlockedLevel;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: unlocked ? () => _openQuiz(level, 1) : null,
                      child: Text(
                        unlocked
                            ? 'Start Level $level'
                            : 'Level $level Locked',
                      ),
                    ),
                  );
                }),

                const Spacer(),

                OutlinedButton(
                  onPressed: _resetProgress,
                  child: const Text('Reset Progress'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}