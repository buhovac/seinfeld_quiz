import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_progress.dart';

class ProgressStore {
  static const _totalCorrectKey = 'total_correct';
  static const _totalAnsweredKey = 'total_answered';
  static const _highestUnlockedLevelKey = 'highest_unlocked_level';
  static const _fanMasterUnlockedKey = 'fan_master_unlocked';

  Future<AppProgress> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AppProgress(
      totalCorrect: prefs.getInt(_totalCorrectKey) ?? 0,
      totalAnswered: prefs.getInt(_totalAnsweredKey) ?? 0,
      highestUnlockedLevel: prefs.getInt(_highestUnlockedLevelKey) ?? 1,
      fanMasterUnlocked: prefs.getBool(_fanMasterUnlockedKey) ?? false,
    );
  }

  Future<void> save(AppProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_totalCorrectKey, progress.totalCorrect);
    await prefs.setInt(_totalAnsweredKey, progress.totalAnswered);
    await prefs.setInt(_highestUnlockedLevelKey, progress.highestUnlockedLevel);
    await prefs.setBool(_fanMasterUnlockedKey, progress.fanMasterUnlocked);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_totalCorrectKey);
    await prefs.remove(_totalAnsweredKey);
    await prefs.remove(_highestUnlockedLevelKey);
    await prefs.remove(_fanMasterUnlockedKey);
  }
}