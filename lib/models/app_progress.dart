class AppProgress {
  final int totalCorrect;
  final int totalAnswered;
  final int highestUnlockedLevel;
  final bool fanMasterUnlocked;

  const AppProgress({
    required this.totalCorrect,
    required this.totalAnswered,
    required this.highestUnlockedLevel,
    required this.fanMasterUnlocked,
  });

  factory AppProgress.initial() {
    return const AppProgress(
      totalCorrect: 0,
      totalAnswered: 0,
      highestUnlockedLevel: 1,
      fanMasterUnlocked: false,
    );
  }

  AppProgress copyWith({
    int? totalCorrect,
    int? totalAnswered,
    int? highestUnlockedLevel,
    bool? fanMasterUnlocked,
  }) {
    return AppProgress(
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      highestUnlockedLevel: highestUnlockedLevel ?? this.highestUnlockedLevel,
      fanMasterUnlocked: fanMasterUnlocked ?? this.fanMasterUnlocked,
    );
  }

  double get percentage {
    if (totalAnswered == 0) return 0;
    return (totalCorrect / totalAnswered) * 100;
  }
}