import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../knowledge_games/presentation/game_pack_view.dart';
import '../application/word_search_game_adapter.dart';
import '../application/word_search_progress_provider.dart';
import '../application/word_search_repository.dart';
import '../domain/word_search_models.dart';
import 'word_search_ui_helpers.dart';

class WordSearchPackPage extends ConsumerWidget {
  const WordSearchPackPage({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(wordSearchCatalogProvider);
    final progress = ref.watch(wordSearchProgressProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return catalogAsync.when(
      loading: () => GameStatePage(
        title: l10n.wordSearchHomeTitle,
        subtitle: l10n.wordSearchLoadingSubtitle,
        isLoading: true,
      ),
      error: (_, _) => GameStatePage(
        title: l10n.wordSearchHomeTitle,
        subtitle: l10n.wordSearchLoadErrorSubtitle,
        message: l10n.wordSearchLoadErrorTitle,
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return GameStatePage(
            title: l10n.wordSearchHomeTitle,
            subtitle: l10n.wordSearchNotFoundSubtitle,
            message: l10n.wordSearchNotFoundTitle,
          );
        }
        if (isChildProfile && pack.mode != 'kids' && pack.mode != 'mixed') {
          return GameStatePage(
            title: l10n.wordSearchHomeTitle,
            subtitle: l10n.wordSearchNotFoundSubtitle,
            message: l10n.wordSearchKidsOnlyTitle,
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<WordSearchPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aScore = _sortPriority(progress.progressFor(a.id));
                final bScore = _sortPriority(progress.progressFor(b.id));
                if (aScore != bScore) return aScore.compareTo(bScore);
                return a.difficulty.compareTo(b.difficulty);
              });
        final packSummary = catalog.progressForPack(pack.id, progress);
        final adapter = ref.watch(wordSearchGameAdapterProvider);
        final recommendedId = KnowledgeGameRecommendations.recommendedNext(
          games: puzzles.map(adapter.toGame),
          isCompleted: (gameId) => progress.progressFor(gameId).isCompleted,
          isStarted: (gameId) => progress.progressFor(gameId).isStarted,
        );
        final recommended = recommendedId == null
            ? puzzles.firstWhere(
                (item) => !progress.progressFor(item.id).isCompleted,
                orElse: () => puzzles.first,
              )
            : puzzles.firstWhere((item) => item.id == recommendedId);

        void openPuzzle(String puzzleId) => context.pushNamed(
          'learnWordSearchPuzzle',
          pathParameters: {'puzzleId': puzzleId},
          queryParameters: {'pack': pack.id},
        );

        return GamePackView(
          title: wordSearchPackTitle(l10n, pack),
          subtitle: wordSearchPackSubtitle(l10n, pack),
          summaryChips: [
            wordSearchLocalizedCategory(l10n, pack.category),
            l10n.wordSearchPackDifficultyLabel(
              pack.minDifficulty.toString(),
              pack.maxDifficulty.toString(),
            ),
            l10n.wordSearchPackProgressLabel(
              packSummary.completedPuzzles.toString(),
              packSummary.totalPuzzles.toString(),
            ),
            if (packSummary.perfectPuzzles > 0)
              l10n.wordSearchPackPerfectLabel(
                packSummary.perfectPuzzles.toString(),
              ),
          ],
          progress: packSummary.completionFraction,
          primaryActionLabel: packSummary.inProgressPuzzles > 0
              ? l10n.wordSearchContinueAction
              : l10n.wordSearchRecommendedAction,
          onPrimaryAction: () => openPuzzle(recommended.id),
          items: [
            for (final puzzle in puzzles)
              _item(l10n, puzzle, progress.progressFor(puzzle.id), openPuzzle),
          ],
        );
      },
    );
  }

  GamePackItem _item(
    AppLocalizations l10n,
    WordSearchPuzzle puzzle,
    WordSearchPuzzleProgress progress,
    void Function(String puzzleId) openPuzzle,
  ) {
    return GamePackItem(
      title: wordSearchPuzzleTitle(l10n, puzzle),
      chips: [
        wordSearchLocalizedCategory(l10n, puzzle.category),
        wordSearchDifficultyLabel(l10n, puzzle.difficulty),
        l10n.wordSearchFoundCountLabel(
          progress.foundWordIds.length.toString(),
          puzzle.targetWords.length.toString(),
        ),
        if (progress.isPerfect) l10n.wordSearchPerfectBadge,
      ],
      details: [
        GamePackDetail(
          l10n.wordSearchGridSizeLabel(puzzle.gridSize.toString()),
        ),
      ],
      actionIcon: progress.isCompleted
          ? Icons.replay_rounded
          : Icons.play_arrow_rounded,
      actionLabel: progress.isCompleted
          ? l10n.wordSearchReplayAction
          : progress.isStarted
          ? l10n.wordSearchContinueAction
          : l10n.wordSearchStartAction,
      onOpen: () => openPuzzle(puzzle.id),
    );
  }

  int _sortPriority(WordSearchPuzzleProgress progress) {
    if (progress.isStarted && !progress.isCompleted) return 0;
    if (!progress.isCompleted) return 1;
    return 2;
  }
}
