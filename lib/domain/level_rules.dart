class LevelRules {
  static int questionsCount(int level) {
    return switch (level) {
      1 => 10,
      2 => 20,
      3 || 4 || 5 || 6 => 30,
      7 => 20,
      _ => throw ArgumentError('Invalid level: $level'),
    };
  }

  static int passThreshold(int level) {
    return switch (level) {
      1 => 8,
      2 => 16,
      3 || 4 || 5 || 6 => 25,
      7 => 20, // must be perfect
      _ => throw ArgumentError('Invalid level: $level'),
    };
  }
}
