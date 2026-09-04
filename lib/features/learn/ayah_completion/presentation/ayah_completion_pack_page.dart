import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../knowledge_games/presentation/game_pack_view.dart';
import '../application/ayah_completion_game_adapter.dart';
import '../application/ayah_completion_progress_provider.dart';
import '../application/ayah_completion_repository.dart';
import '../domain/ayah_completion_models.dart';
import 'ayah_completion_ui_helpers.dart';

class AyahCompletionPackPage extends ConsumerWidget {
  const AyahCompletionPackPage({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(ayahCompletionCatalogProvider);
    final progress = ref.watch(ayahCompletionProgressProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return catalogAsync.when(
      loading: () => GameStatePage(
        title: l10n.ayahCompletionHomeTitle,
        subtitle: l10n.ayahCompletionLoadingSubtitle,
        isLoading: true,
      ),
      error: (_, _) => GameStatePage(
        title: l10n.ayahCompletionHomeTitle,
        subtitle: l10n.ayahCompletionLoadErrorSubtitle,
        message: l10n.ayahCompletionLoadErrorTitle,
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return GameStatePage(
            title: l10n.ayahCompletionHomeTitle,
            subtitle: l10n.ayahCompletionNotFoundSubtitle,
            message: l10n.ayahCompletionNotFoundTitle,
          );
        }
        if (isChildProfile && pack.mode != 'kids' && pack.mode != 'mixed') {
          return GameStatePage(
            title: l10n.ayahCompletionHomeTitle,
            subtitle: l10n.ayahCompletionNotFoundSubtitle,
            message: l10n.ayahCompletionKidsOnlyTitle,
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<AyahCompletionPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aScore = _sortPriority(progress.progressFor(a.id));
                final bScore = _sortPriority(progress.progressFor(b.id));
                if (aScore != bScore) return aScore.compareTo(bScore);
                return a.difficulty.compareTo(b.difficulty);
              });
        final packSummary = catalog.progressForPack(pack.id, progress);
        final adapter = ref.watch(ayahCompletionGameAdapterProvider);
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
          'learnAyahCompletionPuzzle',
          pathParameters: {'puzzleId': puzzleId},
          queryParameters: {'pack': pack.id},
        );

        return GamePackView(
          title: ayahCompletionPackTitle(l10n, pack),
          subtitle: ayahCompletionPackSubtitle(l10n, pack),
          summaryChips: [
            ayahCompletionLocalizedCategory(l10n, pack.category),
            l10n.ayahCompletionPackDifficultyLabel(
              pack.minDifficulty.toString(),
              pack.maxDifficulty.toString(),
            ),
            l10n.ayahCompletionPackProgressLabel(
              packSummary.completedPuzzles.toString(),
              packSummary.totalPuzzles.toString(),
            ),
            if (packSummary.perfectPuzzles > 0)
              l10n.ayahCompletionPackPerfectLabel(
                packSummary.perfectPuzzles.toString(),
              ),
          ],
          progress: packSummary.completionFraction,
          primaryActionLabel: packSummary.inProgressPuzzles > 0
              ? l10n.ayahCompletionContinueAction
              : l10n.ayahCompletionRecommendedAction,
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
    AyahCompletionPuzzle puzzle,
    AyahCompletionPuzzleProgress progress,
    void Function(String puzzleId) openPuzzle,
  ) {
    return GamePackItem(
      title: ayahCompletionPuzzleTitle(l10n, puzzle),
      chips: [
        ayahCompletionLocalizedCategory(l10n, puzzle.category),
        ayahCompletionDifficultyLabel(l10n, puzzle.difficulty),
        l10n.ayahCompletionProgressCountLabel(
          progress.filledWordsByBlankIndex.length.toString(),
          puzzle.blanks.length.toString(),
        ),
        if (progress.isPerfect) l10n.ayahCompletionPerfectBadge,
      ],
      details: [
        GamePackDetail(
          l10n.ayahCompletionReferenceLabel(puzzle.ref.locationLabel),
        ),
      ],
      actionIcon: progress.isCompleted
          ? Icons.replay_rounded
          : Icons.play_arrow_rounded,
      actionLabel: progress.isCompleted
          ? l10n.ayahCompletionReplayAction
          : progress.isStarted
          ? l10n.ayahCompletionContinueAction
          : l10n.ayahCompletionStartAction,
      onOpen: () => openPuzzle(puzzle.id),
    );
  }

  int _sortPriority(AyahCompletionPuzzleProgress progress) {
    if (progress.isStarted && !progress.isCompleted) return 0;
    if (!progress.isCompleted) return 1;
    return 2;
  }
}
