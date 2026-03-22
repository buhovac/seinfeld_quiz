class AppProgress {
  final int totalCorrect;
  final int totalAnswered;
  final Map<int, int> unlockedLevelsByCategory;
  final bool fanMasterUnlocked;

  const AppProgress({
    required this.totalCorrect,
    required this.totalAnswered,
    required this.unlockedLevelsByCategory,
    required this.fanMasterUnlocked,
  });

  factory AppProgress.initial() {
    return const AppProgress(
      totalCorrect: 0,
      totalAnswered: 0,
      unlockedLevelsByCategory: {
        1: 1,
        2: 1,
        3: 1,
        4: 1,
        5: 1,
        6: 1,
        7: 1,
      },
      fanMasterUnlocked: false,
    );
  }

  AppProgress copyWith({
    int? totalCorrect,
    int? totalAnswered,
    Map<int, int>? unlockedLevelsByCategory,
    bool? fanMasterUnlocked,
  }) {
    return AppProgress(
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      unlockedLevelsByCategory:
          unlockedLevelsByCategory ?? this.unlockedLevelsByCategory,
      fanMasterUnlocked: fanMasterUnlocked ?? this.fanMasterUnlocked,
    );
  }

  double get percentage {
    if (totalAnswered == 0) return 0;
    return (totalCorrect / totalAnswered) * 100;
  }

  int unlockedLevelForCategory(int categoryId) {
    return unlockedLevelsByCategory[categoryId] ?? 1;
  }
}