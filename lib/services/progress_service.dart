import '../domain/quiz_state.dart';
import '../models/app_progress.dart';
import 'progress_store.dart';

class ProgressService {
  final ProgressStore _store;

  ProgressService({ProgressStore? store}) : _store = store ?? ProgressStore();

  Future<AppProgress> getProgress() async {
    return _store.load();
  }

  Future<AppProgress> updateAfterQuiz(QuizResult result) async {
    final current = await _store.load();

    final updatedUnlocked = Map<int, int>.from(current.unlockedLevelsByCategory);

    final currentUnlockedForCategory = updatedUnlocked[result.categoryId] ?? 1;

    if (result.passed && result.level < 7) {
      final candidate = result.level + 1;
      if (candidate > currentUnlockedForCategory) {
        updatedUnlocked[result.categoryId] = candidate;
      }
    }

    final unlockedFanMaster =
        current.fanMasterUnlocked || (result.level == 7 && result.passed);

    final updated = current.copyWith(
      totalCorrect: current.totalCorrect + result.correct,
      totalAnswered: current.totalAnswered + result.total,
      unlockedLevelsByCategory: updatedUnlocked,
      fanMasterUnlocked: unlockedFanMaster,
    );

    await _store.save(updated);
    return updated;
  }

  Future<void> resetAll() async {
    await _store.clear();
  }
}