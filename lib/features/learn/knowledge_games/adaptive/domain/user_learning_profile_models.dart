class UserLearningProfile {
  const UserLearningProfile({
    required this.categoryStrength,
    required this.gameTypeStrength,
    required this.overallSkillLevel,
    required this.recentPerformance,
    required this.difficultyComfort,
    this.focusCategory,
    this.strongestCategory,
    this.supportGameType,
    this.challengeGameType,
    this.lastUpdatedAtIso,
  });

  final Map<String, double> categoryStrength;
  final Map<String, double> gameTypeStrength;
  final double overallSkillLevel;
  final Map<String, int> recentPerformance;
  final Map<String, double> difficultyComfort;
  final String? focusCategory;
  final String? strongestCategory;
  final String? supportGameType;
  final String? challengeGameType;
  final String? lastUpdatedAtIso;

  factory UserLearningProfile.initial() => const UserLearningProfile(
    categoryStrength: <String, double>{},
    gameTypeStrength: <String, double>{},
    overallSkillLevel: 0.5,
    recentPerformance: <String, int>{},
    difficultyComfort: <String, double>{},
  );

  double categoryScore(String category) => categoryStrength[category] ?? 0.5;

  double gameTypeScore(String gameType) =>
      gameTypeStrength[gameType] ?? overallSkillLevel;

  double comfortScore(String gameType) =>
      difficultyComfort[gameType] ?? gameTypeScore(gameType);

  int recentCount(String key) => recentPerformance[key] ?? 0;

  UserLearningProfile copyWith({
    Map<String, double>? categoryStrength,
    Map<String, double>? gameTypeStrength,
    double? overallSkillLevel,
    Map<String, int>? recentPerformance,
    Map<String, double>? difficultyComfort,
    String? focusCategory,
    bool clearFocusCategory = false,
    String? strongestCategory,
    bool clearStrongestCategory = false,
    String? supportGameType,
    bool clearSupportGameType = false,
    String? challengeGameType,
    bool clearChallengeGameType = false,
    String? lastUpdatedAtIso,
    bool clearLastUpdatedAtIso = false,
  }) {
    return UserLearningProfile(
      categoryStrength: categoryStrength ?? this.categoryStrength,
      gameTypeStrength: gameTypeStrength ?? this.gameTypeStrength,
      overallSkillLevel: overallSkillLevel ?? this.overallSkillLevel,
      recentPerformance: recentPerformance ?? this.recentPerformance,
      difficultyComfort: difficultyComfort ?? this.difficultyComfort,
      focusCategory: clearFocusCategory
          ? null
          : (focusCategory ?? this.focusCategory),
      strongestCategory: clearStrongestCategory
          ? null
          : (strongestCategory ?? this.strongestCategory),
      supportGameType: clearSupportGameType
          ? null
          : (supportGameType ?? this.supportGameType),
      challengeGameType: clearChallengeGameType
          ? null
          : (challengeGameType ?? this.challengeGameType),
      lastUpdatedAtIso: clearLastUpdatedAtIso
          ? null
          : (lastUpdatedAtIso ?? this.lastUpdatedAtIso),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'categoryStrength': categoryStrength,
    'gameTypeStrength': gameTypeStrength,
    'overallSkillLevel': overallSkillLevel,
    'recentPerformance': recentPerformance,
    'difficultyComfort': difficultyComfort,
    'focusCategory': focusCategory,
    'strongestCategory': strongestCategory,
    'supportGameType': supportGameType,
    'challengeGameType': challengeGameType,
    'lastUpdatedAtIso': lastUpdatedAtIso,
  };

  factory UserLearningProfile.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    return UserLearningProfile(
      categoryStrength: _doubleMap(source['categoryStrength']),
      gameTypeStrength: _doubleMap(source['gameTypeStrength']),
      overallSkillLevel: (source['overallSkillLevel'] as num?)?.toDouble() ?? 0.5,
      recentPerformance: _intMap(source['recentPerformance']),
      difficultyComfort: _doubleMap(source['difficultyComfort']),
      focusCategory: source['focusCategory']?.toString(),
      strongestCategory: source['strongestCategory']?.toString(),
      supportGameType: source['supportGameType']?.toString(),
      challengeGameType: source['challengeGameType']?.toString(),
      lastUpdatedAtIso: source['lastUpdatedAtIso']?.toString(),
    );
  }
}

class AdaptiveLearningInsight {
  const AdaptiveLearningInsight({
    required this.hasAdaptiveData,
    this.supportGameType,
    this.challengeGameType,
    this.focusCategory,
  });

  final bool hasAdaptiveData;
  final String? supportGameType;
  final String? challengeGameType;
  final String? focusCategory;
}

Map<String, double> _doubleMap(Object? raw) {
  if (raw is! Map) return const <String, double>{};
  return raw.map(
    (key, value) => MapEntry(
      key.toString(),
      (value as num?)?.toDouble() ?? 0,
    ),
  );
}

Map<String, int> _intMap(Object? raw) {
  if (raw is! Map) return const <String, int>{};
  return raw.map(
    (key, value) => MapEntry(
      key.toString(),
      (value as num?)?.toInt() ?? 0,
    ),
  );
}
