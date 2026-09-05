import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge_games/domain/knowledge_game_adapter.dart';
import '../../knowledge_games/domain/knowledge_game_models.dart';
import '../domain/hadith_reflection_models.dart';

class HadithReflectionGameAdapter
    implements
        KnowledgeGameAdapter<
          HadithReflectionPuzzle,
          HadithReflectionPuzzleProgress
        > {
  const HadithReflectionGameAdapter();

  @override
  String get type => 'hadith_reflection';

  @override
  KnowledgeGame toGame(HadithReflectionPuzzle game) {
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
    required HadithReflectionPuzzle game,
    required HadithReflectionPuzzleProgress progress,
  }) {
    return KnowledgeGameSession(
      gameId: game.id,
      type: type,
      startedAt:
          DateTime.tryParse(progress.startedAtIso ?? '') ?? DateTime.now(),
      isCompleted: progress.isCompleted,
      state: {
        'selectedChoiceId': progress.selectedChoiceId,
        'feedbackViewed': progress.feedbackViewed,
        'helpViewed': progress.helpViewed,
      },
    );
  }

  @override
  KnowledgeGameResult evaluate({
    required HadithReflectionPuzzle game,
    required HadithReflectionPuzzleProgress progress,
    required int xpEarned,
    required int dropsEarned,
  }) {
    return KnowledgeGameResult(
      gameId: game.id,
      completed: progress.isCompleted,
      perfect: progress.isBestChoice,
      xpEarned: xpEarned,
      dropsEarned: dropsEarned,
    );
  }
}

final hadithReflectionGameAdapterProvider =
    Provider<HadithReflectionGameAdapter>(
      (_) => const HadithReflectionGameAdapter(),
    );
