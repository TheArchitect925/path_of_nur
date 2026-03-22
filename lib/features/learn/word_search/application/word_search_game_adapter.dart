import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../knowledge_games/domain/knowledge_game_adapter.dart';
import '../../knowledge_games/domain/knowledge_game_models.dart';
import '../../knowledge_games/presentation/knowledge_game_screen.dart';
import '../domain/word_search_models.dart';

class WordSearchGameAdapter
    implements
        KnowledgeGameAdapter<WordSearchPuzzle, WordSearchPuzzleProgress> {
  const WordSearchGameAdapter();

  @override
  String get type => 'word_search';

  @override
  KnowledgeGame toGame(WordSearchPuzzle game) {
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
    required WordSearchPuzzle game,
    required WordSearchPuzzleProgress progress,
  }) {
    return KnowledgeGameSession(
      gameId: game.id,
      type: type,
      startedAt:
          DateTime.tryParse(progress.startedAtIso ?? '') ?? DateTime.now(),
      isCompleted: progress.isCompleted,
      state: {
        'foundWordIds': progress.foundWordIds.toList(growable: false),
        'selectedStartCellKey': progress.selectedStartCellKey,
        'selectedEndCellKey': progress.selectedEndCellKey,
        'recentSelectionCellKeys': progress.recentSelectionCellKeys,
      },
    );
  }

  @override
  KnowledgeGameResult evaluate({
    required WordSearchPuzzle game,
    required WordSearchPuzzleProgress progress,
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

final wordSearchGameAdapterProvider = Provider<WordSearchGameAdapter>(
  (_) => const WordSearchGameAdapter(),
);
