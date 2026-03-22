import 'knowledge_game_variations.dart';

class KnowledgeGame {
  const KnowledgeGame({
    required this.id,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.tags,
    this.config = const KnowledgeGameConfig.standard(),
  });

  final String id;
  final String type;
  final String category;
  final int difficulty;
  final List<String> tags;
  final KnowledgeGameConfig config;

  KnowledgeGame copyWith({
    String? id,
    String? type,
    String? category,
    int? difficulty,
    List<String>? tags,
    KnowledgeGameConfig? config,
  }) {
    return KnowledgeGame(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      config: config ?? this.config,
    );
  }
}

class KnowledgeGameSession {
  const KnowledgeGameSession({
    required this.gameId,
    required this.type,
    required this.startedAt,
    required this.isCompleted,
    required this.state,
    this.config = const KnowledgeGameConfig.standard(),
  });

  final String gameId;
  final String type;
  final DateTime startedAt;
  final bool isCompleted;
  final Map<String, Object?> state;
  final KnowledgeGameConfig config;

  KnowledgeGameSession copyWith({
    String? gameId,
    String? type,
    DateTime? startedAt,
    bool? isCompleted,
    Map<String, Object?>? state,
    KnowledgeGameConfig? config,
  }) {
    return KnowledgeGameSession(
      gameId: gameId ?? this.gameId,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      state: state ?? this.state,
      config: config ?? this.config,
    );
  }
}

class KnowledgeGameResult {
  const KnowledgeGameResult({
    required this.gameId,
    required this.completed,
    required this.perfect,
    required this.xpEarned,
    required this.dropsEarned,
    this.config = const KnowledgeGameConfig.standard(),
    this.variationBonusXpEarned = 0,
    this.variationBonusDropsEarned = 0,
  });

  final String gameId;
  final bool completed;
  final bool perfect;
  final int xpEarned;
  final int dropsEarned;
  final KnowledgeGameConfig config;
  final int variationBonusXpEarned;
  final int variationBonusDropsEarned;

  KnowledgeGameResult copyWith({
    String? gameId,
    bool? completed,
    bool? perfect,
    int? xpEarned,
    int? dropsEarned,
    KnowledgeGameConfig? config,
    int? variationBonusXpEarned,
    int? variationBonusDropsEarned,
  }) {
    return KnowledgeGameResult(
      gameId: gameId ?? this.gameId,
      completed: completed ?? this.completed,
      perfect: perfect ?? this.perfect,
      xpEarned: xpEarned ?? this.xpEarned,
      dropsEarned: dropsEarned ?? this.dropsEarned,
      config: config ?? this.config,
      variationBonusXpEarned:
          variationBonusXpEarned ?? this.variationBonusXpEarned,
      variationBonusDropsEarned:
          variationBonusDropsEarned ?? this.variationBonusDropsEarned,
    );
  }
}

class KnowledgeGamePack {
  const KnowledgeGamePack({
    required this.id,
    required this.type,
    required this.category,
    required this.tags,
    required this.gameIds,
    required this.isDailyEligible,
    required this.isFeatured,
  });

  final String id;
  final String type;
  final String category;
  final List<String> tags;
  final List<String> gameIds;
  final bool isDailyEligible;
  final bool isFeatured;
}

class KnowledgeGameProgressSummary {
  const KnowledgeGameProgressSummary({
    required this.totalItems,
    required this.completedItems,
    required this.perfectItems,
    required this.inProgressItems,
    required this.nextItemId,
  });

  final int totalItems;
  final int completedItems;
  final int perfectItems;
  final int inProgressItems;
  final String? nextItemId;

  double get completionFraction =>
      totalItems == 0 ? 0 : completedItems / totalItems;
}

class KnowledgeGameDailyChallenge {
  const KnowledgeGameDailyChallenge({
    required this.dateKey,
    required this.type,
    required this.gameId,
    required this.category,
    required this.difficulty,
    required this.tags,
    this.config = const KnowledgeGameConfig.standard(),
  });

  final String dateKey;
  final String type;
  final String gameId;
  final String category;
  final int difficulty;
  final List<String> tags;
  final KnowledgeGameConfig config;
}
