class LevelRules {
  static int questionsCount(int level) {
    switch (level) {
      case 1:
        return 10; // novice
      case 2:
        return 10; // medium
      case 3:
        return 10; // advanced
      default:
        throw ArgumentError('Invalid level: $level');
    }
  }

  static int passThreshold(int level) {
    switch (level) {
      case 1:
        return 8;
      case 2:
        return 8;
      case 3:
        return 8;
      default:
        throw ArgumentError('Invalid level: $level');
    }
  }

  static String label(int level) {
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
}