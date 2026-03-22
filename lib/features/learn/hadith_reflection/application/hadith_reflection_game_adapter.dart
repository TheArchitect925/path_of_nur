import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge_games/domain/knowledge_game_adapter.dart';
import '../../knowledge_games/domain/knowledge_game_models.dart';
import '../../knowledge_games/presentation/knowledge_game_screen.dart';
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

  @override
  Widget buildScreen({
    required BuildContext context,
    required String title,
    required String subtitle,
    required KnowledgeGame game,
    KnowledgeGameSession? session,
    KnowledgeGameResult? result,
    required List<Widget> children,
  }) {
    return KnowledgeGameScreen(
      title: title,
      subtitle: subtitle,
      game: game,
      session: session,
      result: result,
      children: children,
    );
  }
}

final hadithReflectionGameAdapterProvider =
    Provider<HadithReflectionGameAdapter>(
      (_) => const HadithReflectionGameAdapter(),
    );
