import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge_games/domain/knowledge_game_adapter.dart';
import '../../knowledge_games/domain/knowledge_game_models.dart';
import '../domain/matching_models.dart';

class MatchingGameAdapter
    implements KnowledgeGameAdapter<MatchingPuzzle, MatchingPuzzleProgress> {
  const MatchingGameAdapter();

  @override
  String get type => 'matching';

  @override
  KnowledgeGame toGame(MatchingPuzzle game) {
    return KnowledgeGame(
      id: game.id,
      type: type,
      category: game.category,
      difficulty: game.difficulty,
      tags: game.tags,
    );
  }

  @override
  KnowledgeGameSession createSession({
    required MatchingPuzzle game,
    required MatchingPuzzleProgress progress,
  }) {
    return KnowledgeGameSession(
      gameId: game.id,
      type: type,
      startedAt:
          DateTime.tryParse(progress.startedAtIso ?? '') ?? DateTime.now(),
      isCompleted: progress.isCompleted,
      state: {
        'matchedPairIds': progress.matchedPairIds.toList(growable: false),
        'selectedLeftPairId': progress.selectedLeftPairId,
        'selectedRightPairId': progress.selectedRightPairId,
      },
    );
  }

  @override
  KnowledgeGameResult evaluate({
    required MatchingPuzzle game,
    required MatchingPuzzleProgress progress,
    required int xpEarned,
    required int dropsEarned,
  }) {
    return KnowledgeGameResult(
      gameId: game.id,
      completed: progress.isCompleted,
      perfect: progress.isPerfect,
      xpEarned: xpEarned,
      dropsEarned: dropsEarned,
    );
  }
}

final matchingGameAdapterProvider = Provider<MatchingGameAdapter>(
  (_) => const MatchingGameAdapter(),
);
