import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../knowledge_games/presentation/game_pack_view.dart';
import '../application/matching_game_adapter.dart';
import '../application/matching_progress_provider.dart';
import '../application/matching_repository.dart';
import '../domain/matching_models.dart';
import 'matching_ui_helpers.dart';

class MatchingPackPage extends ConsumerWidget {
  const MatchingPackPage({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(matchingCatalogProvider);
    final progress = ref.watch(matchingProgressProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return catalogAsync.when(
      loading: () => GameStatePage(
        title: l10n.matchingHomeTitle,
        subtitle: l10n.matchingLoadingSubtitle,
        isLoading: true,
      ),
      error: (_, _) => GameStatePage(
        title: l10n.matchingHomeTitle,
        subtitle: l10n.matchingLoadErrorSubtitle,
        message: l10n.matchingLoadErrorTitle,
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return GameStatePage(
            title: l10n.matchingHomeTitle,
            subtitle: l10n.matchingNotFoundSubtitle,
            message: l10n.matchingNotFoundTitle,
          );
        }
        if (isChildProfile && pack.mode != 'kids' && pack.mode != 'mixed') {
          return GameStatePage(
            title: l10n.matchingHomeTitle,
            subtitle: l10n.matchingNotFoundSubtitle,
            message: l10n.matchingKidsOnlyTitle,
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<MatchingPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aScore = _sortPriority(progress.progressFor(a.id));
                final bScore = _sortPriority(progress.progressFor(b.id));
                if (aScore != bScore) return aScore.compareTo(bScore);
                return a.difficulty.compareTo(b.difficulty);
              });
        final packSummary = catalog.progressForPack(pack.id, progress);
        final adapter = ref.watch(matchingGameAdapterProvider);
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
          'learnMatchingPuzzle',
          pathParameters: {'puzzleId': puzzleId},
          queryParameters: {'pack': pack.id},
        );

        return GamePackView(
          title: matchingPackTitle(l10n, pack),
          subtitle: matchingPackSubtitle(l10n, pack),
          summaryChips: [
            matchingLocalizedCategory(l10n, pack.category),
            l10n.matchingPackDifficultyLabel(
              pack.minDifficulty.toString(),
              pack.maxDifficulty.toString(),
            ),
            l10n.matchingPackProgressLabel(
              packSummary.completedPuzzles.toString(),
              packSummary.totalPuzzles.toString(),
            ),
            if (packSummary.perfectPuzzles > 0)
              l10n.matchingPackPerfectLabel(
                packSummary.perfectPuzzles.toString(),
              ),
          ],
          progress: packSummary.completionFraction,
          primaryActionLabel: packSummary.inProgressPuzzles > 0
              ? l10n.matchingContinueAction
              : l10n.matchingRecommendedAction,
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
    MatchingPuzzle puzzle,
    MatchingPuzzleProgress progress,
    void Function(String puzzleId) openPuzzle,
  ) {
    return GamePackItem(
      title: matchingPuzzleTitle(l10n, puzzle),
      chips: [
        matchingLocalizedCategory(l10n, puzzle.category),
        matchingDifficultyLabel(l10n, puzzle.difficulty),
        l10n.matchingFoundCountLabel(
          progress.matchedPairIds.length.toString(),
          puzzle.pairs.length.toString(),
        ),
        if (progress.isPerfect) l10n.matchingPerfectBadge,
      ],
      details: [
        GamePackDetail(
          l10n.matchingPairCountLabel(puzzle.pairs.length.toString()),
        ),
      ],
      actionIcon: progress.isCompleted
          ? Icons.replay_rounded
          : Icons.play_arrow_rounded,
      actionLabel: progress.isCompleted
          ? l10n.matchingReplayAction
          : progress.isStarted
          ? l10n.matchingContinueAction
          : l10n.matchingStartAction,
      onOpen: () => openPuzzle(puzzle.id),
    );
  }

  int _sortPriority(MatchingPuzzleProgress progress) {
    if (progress.isStarted && !progress.isCompleted) return 0;
    if (!progress.isCompleted) return 1;
    return 2;
  }
}
