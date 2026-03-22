import '../domain/knowledge_game_models.dart';

typedef KnowledgeGameCompletionLookup = bool Function(String gameId);
typedef KnowledgeGameStartedLookup = bool Function(String gameId);

class KnowledgeGameRecommendations {
  const KnowledgeGameRecommendations._();

  static KnowledgeGameProgressSummary summarize({
    required Iterable<KnowledgeGame> games,
    required KnowledgeGameCompletionLookup isCompleted,
    required KnowledgeGameCompletionLookup isPerfect,
    required KnowledgeGameStartedLookup isStarted,
  }) {
    var total = 0;
    var completed = 0;
    var perfect = 0;
    var inProgress = 0;
    String? nextId;
    for (final game in games) {
      total += 1;
      if (isCompleted(game.id)) {
        completed += 1;
        if (isPerfect(game.id)) {
          perfect += 1;
        }
      } else if (isStarted(game.id)) {
        inProgress += 1;
        nextId ??= game.id;
      } else {
        nextId ??= game.id;
      }
    }
    return KnowledgeGameProgressSummary(
      totalItems: total,
      completedItems: completed,
      perfectItems: perfect,
      inProgressItems: inProgress,
      nextItemId: nextId,
    );
  }

  static String? recommendedNext({
    required Iterable<KnowledgeGame> games,
    required KnowledgeGameCompletionLookup isCompleted,
    required KnowledgeGameStartedLookup isStarted,
  }) {
    for (final game in games) {
      if (!isCompleted(game.id) && isStarted(game.id)) {
        return game.id;
      }
    }
    for (final game in games) {
      if (!isCompleted(game.id)) {
        return game.id;
      }
    }
    return games.firstOrNull?.id;
  }
}
