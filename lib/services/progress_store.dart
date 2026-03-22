import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_progress.dart';

class ProgressStore {
  static const _totalCorrectKey = 'total_correct';
  static const _totalAnsweredKey = 'total_answered';
  static const _unlockedLevelsByCategoryKey = 'unlocked_levels_by_category';
  static const _fanMasterUnlockedKey = 'fan_master_unlocked';

  Future<AppProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final initial = AppProgress.initial();

    final totalCorrect = prefs.getInt(_totalCorrectKey) ?? 0;
    final totalAnswered = prefs.getInt(_totalAnsweredKey) ?? 0;
    final fanMasterUnlocked = prefs.getBool(_fanMasterUnlockedKey) ?? false;

    Map<int, int> unlockedLevelsByCategory = initial.unlockedLevelsByCategory;

    final unlockedRaw = prefs.getString(_unlockedLevelsByCategoryKey);

    if (unlockedRaw != null && unlockedRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(unlockedRaw);

        if (decoded is Map<String, dynamic>) {
          unlockedLevelsByCategory = {
            1: 1,
            2: 1,
            3: 1,
            4: 1,
            5: 1,
            6: 1,
            7: 1,
          };

          decoded.forEach((key, value) {
            final parsedKey = int.tryParse(key);
            if (parsedKey != null && value is int) {
              unlockedLevelsByCategory[parsedKey] = value;
            }
          });
        }
      } catch (_) {
        unlockedLevelsByCategory = initial.unlockedLevelsByCategory;
      }
    }

    return AppProgress(
      totalCorrect: totalCorrect,
      totalAnswered: totalAnswered,
      unlockedLevelsByCategory: unlockedLevelsByCategory,
      fanMasterUnlocked: fanMasterUnlocked,
    );
  }

  Future<void> save(AppProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedUnlocked = jsonEncode(
      progress.unlockedLevelsByCategory.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );

    await prefs.setInt(_totalCorrectKey, progress.totalCorrect);
    await prefs.setInt(_totalAnsweredKey, progress.totalAnswered);
    await prefs.setString(_unlockedLevelsByCategoryKey, encodedUnlocked);
    await prefs.setBool(_fanMasterUnlockedKey, progress.fanMasterUnlocked);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_totalCorrectKey);
    await prefs.remove(_totalAnsweredKey);
    await prefs.remove(_unlockedLevelsByCategoryKey);
    await prefs.remove(_fanMasterUnlockedKey);

    await prefs.remove('highest_unlocked_level');
  }
}