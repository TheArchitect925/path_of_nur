import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge_games/domain/knowledge_game_adapter.dart';
import '../../knowledge_games/domain/knowledge_game_models.dart';
import '../domain/ayah_completion_models.dart';

class AyahCompletionGameAdapter
    implements
        KnowledgeGameAdapter<
          AyahCompletionPuzzle,
          AyahCompletionPuzzleProgress
        > {
  const AyahCompletionGameAdapter();

  @override
  String get type => 'ayah_completion';

  @override
  KnowledgeGame toGame(AyahCompletionPuzzle game) {
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
    required AyahCompletionPuzzle game,
    required AyahCompletionPuzzleProgress progress,
  }) {
    return KnowledgeGameSession(
      gameId: game.id,
      type: type,
      startedAt:
          DateTime.tryParse(progress.startedAtIso ?? '') ?? DateTime.now(),
      isCompleted: progress.isCompleted,
      state: {
        'filledWordsByBlankIndex': Map<String, String>.from(
          progress.filledWordsByBlankIndex,
        ),
        'revealedBlankIndexes': progress.revealedBlankIndexes.toList(
          growable: false,
        ),
        'selectedBlankIndex': progress.selectedBlankIndex,
      },
    );
  }

  @override
  KnowledgeGameResult evaluate({
    required AyahCompletionPuzzle game,
    required AyahCompletionPuzzleProgress progress,
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

final ayahCompletionGameAdapterProvider = Provider<AyahCompletionGameAdapter>(
  (_) => const AyahCompletionGameAdapter(),
);
