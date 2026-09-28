import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../knowledge_games/presentation/game_pack_view.dart';
import '../application/crossword_game_adapter.dart';
import '../application/crossword_progress_provider.dart';
import '../application/crossword_repository.dart';
import '../domain/crossword_models.dart';
import 'crossword_ui_helpers.dart';

class CrosswordPackPage extends ConsumerWidget {
  const CrosswordPackPage({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(crosswordCatalogProvider);
    final progress = ref.watch(crosswordProgressProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return catalogAsync.when(
      loading: () => GameStatePage(
        title: l10n.crosswordHomeTitle,
        subtitle: l10n.crosswordLoadingSubtitle,
        isLoading: true,
      ),
      error: (_, _) => GameStatePage(
        title: l10n.crosswordHomeTitle,
        subtitle: l10n.crosswordLoadErrorSubtitle,
        message: l10n.crosswordLoadErrorTitle,
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return GameStatePage(
            title: l10n.crosswordHomeTitle,
            subtitle: l10n.crosswordNotFoundSubtitle,
            message: l10n.crosswordNotFoundTitle,
          );
        }
        if (isChildProfile && pack.mode != 'kids') {
          return GameStatePage(
            title: l10n.crosswordHomeTitle,
            subtitle: l10n.crosswordNotFoundSubtitle,
            message: l10n.crosswordKidsOnlyTitle,
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<CrosswordPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aScore = _sortPriority(progress.progressFor(a.id));
                final bScore = _sortPriority(progress.progressFor(b.id));
                if (aScore != bScore) return aScore.compareTo(bScore);
                return a.difficulty.compareTo(b.difficulty);
              });
        final packSummary = catalog.progressForPack(pack.id, progress);
        final currentLevel = ref.watch(
          journeyComputedProgressProvider.select((value) => value.level),
        );
        final adapter = ref.watch(crosswordGameAdapterProvider);
        final recommendedId = KnowledgeGameRecommendations.recommendedNext(
          games: puzzles
              .map(adapter.toGame)
              .where(
                (game) =>
                    currentLevel >=
                        (catalog.puzzlesById[game.id]?.levelBandMin ?? 0) &&
                    currentLevel <=
                        (catalog.puzzlesById[game.id]?.levelBandMax ?? 999),
              ),
          isCompleted: (gameId) => progress.progressFor(gameId).isCompleted,
          isStarted: (gameId) =>
              (progress.progressFor(gameId).startedAtIso ?? '').isNotEmpty,
        );
        final recommended = recommendedId == null
            ? _recommendedPuzzle(puzzles, progress, currentLevel)
            : puzzles.where((item) => item.id == recommendedId).firstOrNull;

        void openPuzzle(String puzzleId) => context.pushNamed(
          'learnCrosswordPuzzle',
          pathParameters: {'puzzleId': puzzleId},
          queryParameters: {'pack': pack.id},
        );

        return GamePackView(
          title: crosswordPackTitle(l10n, pack),
          subtitle: crosswordPackSubtitle(l10n, pack),
          summaryChips: [
            crosswordLocalizedCategory(l10n, pack.category),
            l10n.crosswordPackDifficultyLabel(
              pack.minDifficulty.toString(),
              pack.maxDifficulty.toString(),
            ),
            l10n.crosswordPackProgressLabel(
              packSummary.completedPuzzles.toString(),
              packSummary.totalPuzzles.toString(),
            ),
            if (packSummary.perfectPuzzles > 0)
              l10n.crosswordPackPerfectLabel(
                packSummary.perfectPuzzles.toString(),
              ),
          ],
          progress: packSummary.completionFraction,
          // No button when nothing fits the reader's level band.
          primaryActionLabel: recommended == null
              ? null
              : packSummary.inProgressPuzzles > 0
              ? l10n.crosswordContinueAction
              : l10n.crosswordRecommendedAction,
          onPrimaryAction: recommended == null
              ? null
              : () => openPuzzle(recommended.id),
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
    CrosswordPuzzle puzzle,
    CrosswordPuzzleProgress progress,
    void Function(String puzzleId) openPuzzle,
  ) {
    final isStarted = (progress.startedAtIso ?? '').isNotEmpty;
    return GamePackItem(
      title: crosswordPuzzleTitle(l10n, puzzle),
      chips: [
        crosswordLocalizedCategory(l10n, puzzle.category),
        crosswordDifficultyLabel(l10n, puzzle.difficulty),
        l10n.crosswordGridSizeLabel(puzzle.gridSize.toString()),
        if (puzzle.isAssembled) l10n.crosswordAssembledBadge,
        if (progress.isPerfect) l10n.crosswordPerfectBadge,
      ],
      details: [
        GamePackDetail(
          l10n.crosswordClueCountSubtitle(
            puzzle.clues.length.toString(),
            progress.solvedClueIds.length.toString(),
          ),
          subdued: true,
        ),
      ],
      actionIcon: progress.isCompleted
          ? Icons.refresh_rounded
          : Icons.play_arrow_rounded,
      actionLabel: progress.isCompleted
          ? l10n.crosswordReplayAction
          : isStarted
          ? l10n.crosswordContinueAction
          : l10n.crosswordStartAction,
      onOpen: () => openPuzzle(puzzle.id),
    );
  }

  CrosswordPuzzle? _recommendedPuzzle(
    List<CrosswordPuzzle> puzzles,
    CrosswordProgressState progress,
    int currentLevel,
  ) {
    for (final puzzle in puzzles) {
      final item = progress.progressFor(puzzle.id);
      if (!item.isCompleted && (item.startedAtIso ?? '').isNotEmpty) {
        return puzzle;
      }
    }
    final levelFit = puzzles
        .where(
          (puzzle) =>
              !progress.progressFor(puzzle.id).isCompleted &&
              currentLevel >= puzzle.levelBandMin &&
              currentLevel <= puzzle.levelBandMax,
        )
        .toList(growable: false);
    if (levelFit.isNotEmpty) return levelFit.first;
    return puzzles
            .where((puzzle) => !progress.progressFor(puzzle.id).isCompleted)
            .firstOrNull ??
        puzzles.firstOrNull;
  }

  int _sortPriority(CrosswordPuzzleProgress progress) {
    if (!progress.isCompleted && (progress.startedAtIso ?? '').isNotEmpty) {
      return 0;
    }
    if (!progress.isCompleted) return 1;
    return 2;
  }
}
