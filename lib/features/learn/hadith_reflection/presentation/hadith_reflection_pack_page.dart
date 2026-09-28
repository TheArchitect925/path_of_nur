import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../knowledge_games/presentation/game_pack_view.dart';
import '../application/hadith_reflection_game_adapter.dart';
import '../application/hadith_reflection_progress_provider.dart';
import '../application/hadith_reflection_repository.dart';
import '../domain/hadith_reflection_models.dart';
import 'hadith_reflection_ui_helpers.dart';

class HadithReflectionPackPage extends ConsumerWidget {
  const HadithReflectionPackPage({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(hadithReflectionCatalogProvider);
    final progress = ref.watch(hadithReflectionProgressProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return catalogAsync.when(
      loading: () => GameStatePage(
        title: l10n.hadithReflectionHomeTitle,
        subtitle: l10n.hadithReflectionLoadingSubtitle,
        isLoading: true,
      ),
      error: (_, _) => GameStatePage(
        title: l10n.hadithReflectionHomeTitle,
        subtitle: l10n.hadithReflectionLoadErrorSubtitle,
        message: l10n.hadithReflectionLoadErrorTitle,
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return GameStatePage(
            title: l10n.hadithReflectionHomeTitle,
            subtitle: l10n.hadithReflectionNotFoundSubtitle,
            message: l10n.hadithReflectionNotFoundTitle,
          );
        }
        if (isChildProfile && pack.mode == 'adult') {
          return GameStatePage(
            title: l10n.hadithReflectionHomeTitle,
            subtitle: l10n.hadithReflectionNotFoundSubtitle,
            message: l10n.hadithReflectionKidsOnlyTitle,
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<HadithReflectionPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aScore = _sortPriority(progress.progressFor(a.id));
                final bScore = _sortPriority(progress.progressFor(b.id));
                if (aScore != bScore) return aScore.compareTo(bScore);
                return a.difficulty.compareTo(b.difficulty);
              });
        final packSummary = catalog.progressForPack(pack.id, progress);
        final adapter = ref.watch(hadithReflectionGameAdapterProvider);
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
          'learnHadithReflectionPuzzle',
          pathParameters: {'puzzleId': puzzleId},
          queryParameters: {'pack': pack.id},
        );

        return GamePackView(
          title: hadithReflectionPackTitle(l10n, pack),
          subtitle: hadithReflectionPackSubtitle(l10n, pack),
          summaryChips: [
            hadithReflectionLocalizedCategory(l10n, pack.category),
            l10n.hadithReflectionPackDifficultyLabel(
              pack.minDifficulty.toString(),
              pack.maxDifficulty.toString(),
            ),
            l10n.hadithReflectionPackProgressLabel(
              packSummary.completedPuzzles.toString(),
              packSummary.totalPuzzles.toString(),
            ),
            if (packSummary.bestChoicePuzzles > 0)
              l10n.hadithReflectionPackBestChoiceLabel(
                packSummary.bestChoicePuzzles.toString(),
              ),
          ],
          progress: packSummary.completionFraction,
          primaryActionLabel: packSummary.inProgressPuzzles > 0
              ? l10n.hadithReflectionContinueAction
              : l10n.hadithReflectionRecommendedAction,
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
    HadithReflectionPuzzle puzzle,
    HadithReflectionPuzzleProgress progress,
    void Function(String puzzleId) openPuzzle,
  ) {
    return GamePackItem(
      title: puzzle.scenarioTitle,
      chips: [
        hadithReflectionLocalizedCategory(l10n, puzzle.category),
        hadithReflectionDifficultyLabel(l10n, puzzle.difficulty),
        if (progress.isBestChoice)
          l10n.hadithReflectionBestChoiceBadge
        else if (progress.isCompleted)
          l10n.hadithReflectionCompletedBadge
        else if (progress.isStarted)
          l10n.hadithReflectionResumeBadge,
      ],
      details: [
        GamePackDetail(puzzle.scenarioDescription, maxLines: 2),
        GamePackDetail(puzzle.shortTeachingSummary, subdued: true),
      ],
      // These cards are prose; the card itself is the affordance.
      onOpen: () => openPuzzle(puzzle.id),
    );
  }

  int _sortPriority(HadithReflectionPuzzleProgress progress) {
    if (progress.isStarted && !progress.isCompleted) return 0;
    if (!progress.isCompleted) return 1;
    return 2;
  }
}
