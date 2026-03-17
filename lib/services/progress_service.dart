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

    int nextUnlockedLevel = current.highestUnlockedLevel;
    if (result.passed && result.level < 7) {
      final candidate = result.level + 1;
      if (candidate > nextUnlockedLevel) {
        nextUnlockedLevel = candidate;
      }
    }

    final unlockedFanMaster =
        current.fanMasterUnlocked || (result.level == 7 && result.passed);

    final updated = current.copyWith(
      totalCorrect: current.totalCorrect + result.correct,
      totalAnswered: current.totalAnswered + result.total,
      highestUnlockedLevel: nextUnlockedLevel,
      fanMasterUnlocked: unlockedFanMaster,
    );

    await _store.save(updated);
    return updated;
  }

  Future<void> resetAll() async {
    await _store.clear();
  }
}