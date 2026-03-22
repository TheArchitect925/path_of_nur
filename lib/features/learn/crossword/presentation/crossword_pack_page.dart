import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
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
      loading: () => LearnHubPageScaffold(
        headerIcon: Icons.grid_view_rounded,
        title: l10n.crosswordHomeTitle,
        subtitle: l10n.crosswordLoadingSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (_, _) => LearnHubPageScaffold(
        headerIcon: Icons.grid_view_rounded,
        title: l10n.crosswordHomeTitle,
        subtitle: l10n.crosswordLoadErrorSubtitle,
        children: [PremiumCard(child: Text(l10n.crosswordLoadErrorTitle))],
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return LearnHubPageScaffold(
            headerIcon: Icons.grid_view_rounded,
            title: l10n.crosswordHomeTitle,
            subtitle: l10n.crosswordNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.crosswordNotFoundTitle))],
          );
        }
        if (isChildProfile && pack.mode != 'kids') {
          return LearnHubPageScaffold(
            headerIcon: Icons.grid_view_rounded,
            title: l10n.crosswordHomeTitle,
            subtitle: l10n.crosswordNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.crosswordKidsOnlyTitle))],
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<CrosswordPuzzle>()
                .toList(growable: false)
              ..sort((a, b) {
                final aProgress = progress.progressFor(a.id);
                final bProgress = progress.progressFor(b.id);
                final aScore = _sortPriority(aProgress);
                final bScore = _sortPriority(bProgress);
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

        return LearnHubPageScaffold(
          headerIcon: Icons.grid_view_rounded,
          title: crosswordPackTitle(l10n, pack),
          subtitle: crosswordPackSubtitle(l10n, pack),
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(
                        context,
                        crosswordLocalizedCategory(l10n, pack.category),
                      ),
                      _chip(
                        context,
                        l10n.crosswordPackDifficultyLabel(
                          pack.minDifficulty.toString(),
                          pack.maxDifficulty.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.crosswordPackProgressLabel(
                          packSummary.completedPuzzles.toString(),
                          packSummary.totalPuzzles.toString(),
                        ),
                      ),
                      if (packSummary.perfectPuzzles > 0)
                        _chip(
                          context,
                          l10n.crosswordPackPerfectLabel(
                            packSummary.perfectPuzzles.toString(),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: packSummary.completionFraction,
                    ),
                  ),
                  if (recommended != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => context.pushNamed(
                        'learnCrosswordPuzzle',
                        pathParameters: {'puzzleId': recommended.id},
                        queryParameters: {'pack': pack.id},
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        packSummary.inProgressPuzzles > 0
                            ? l10n.crosswordContinueAction
                            : l10n.crosswordRecommendedAction,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...puzzles.map(
              (puzzle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PackPuzzleCard(
                  puzzle: puzzle,
                  progress: progress.progressFor(puzzle.id),
                  onOpen: () => context.pushNamed(
                    'learnCrosswordPuzzle',
                    pathParameters: {'puzzleId': puzzle.id},
                    queryParameters: {'pack': pack.id},
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
    if (!progress.isCompleted) {
      return 1;
    }
    return 2;
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(label),
    );
  }
}

class _PackPuzzleCard extends StatelessWidget {
  const _PackPuzzleCard({
    required this.puzzle,
    required this.progress,
    required this.onOpen,
  });

  final CrosswordPuzzle puzzle;
  final CrosswordPuzzleProgress progress;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag(context, crosswordLocalizedCategory(l10n, puzzle.category)),
              _tag(context, crosswordDifficultyLabel(l10n, puzzle.difficulty)),
              _tag(
                context,
                l10n.crosswordGridSizeLabel(puzzle.gridSize.toString()),
              ),
              if (puzzle.isAssembled)
                _tag(context, l10n.crosswordAssembledBadge),
              if (progress.isPerfect) _tag(context, l10n.crosswordPerfectBadge),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            crosswordPuzzleTitle(l10n, puzzle),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.crosswordClueCountSubtitle(
              puzzle.clues.length.toString(),
              progress.solvedClueIds.length.toString(),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onOpen,
            icon: Icon(
              progress.isCompleted
                  ? Icons.refresh_rounded
                  : Icons.play_arrow_rounded,
            ),
            label: Text(
              progress.isCompleted
                  ? l10n.crosswordReplayAction
                  : (progress.startedAtIso ?? '').isNotEmpty
                  ? l10n.crosswordContinueAction
                  : l10n.crosswordStartAction,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(label),
    );
  }
}
