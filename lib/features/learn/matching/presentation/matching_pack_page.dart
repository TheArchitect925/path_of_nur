import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
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
      loading: () => LearnHubPageScaffold(
        headerIcon: Icons.view_week_rounded,
        title: l10n.matchingHomeTitle,
        subtitle: l10n.matchingLoadingSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (_, _) => LearnHubPageScaffold(
        headerIcon: Icons.view_week_rounded,
        title: l10n.matchingHomeTitle,
        subtitle: l10n.matchingLoadErrorSubtitle,
        children: [PremiumCard(child: Text(l10n.matchingLoadErrorTitle))],
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return LearnHubPageScaffold(
            headerIcon: Icons.view_week_rounded,
            title: l10n.matchingHomeTitle,
            subtitle: l10n.matchingNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.matchingNotFoundTitle))],
          );
        }
        if (isChildProfile && pack.mode != 'kids' && pack.mode != 'mixed') {
          return LearnHubPageScaffold(
            headerIcon: Icons.view_week_rounded,
            title: l10n.matchingHomeTitle,
            subtitle: l10n.matchingNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.matchingKidsOnlyTitle))],
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<MatchingPuzzle>()
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

        return LearnHubPageScaffold(
          headerIcon: Icons.view_week_rounded,
          title: matchingPackTitle(l10n, pack),
          subtitle: matchingPackSubtitle(l10n, pack),
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
                        matchingLocalizedCategory(l10n, pack.category),
                      ),
                      _chip(
                        context,
                        l10n.matchingPackDifficultyLabel(
                          pack.minDifficulty.toString(),
                          pack.maxDifficulty.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.matchingPackProgressLabel(
                          packSummary.completedPuzzles.toString(),
                          packSummary.totalPuzzles.toString(),
                        ),
                      ),
                      if (packSummary.perfectPuzzles > 0)
                        _chip(
                          context,
                          l10n.matchingPackPerfectLabel(
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
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      'learnMatchingPuzzle',
                      pathParameters: {'puzzleId': recommended.id},
                      queryParameters: {'pack': pack.id},
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      packSummary.inProgressPuzzles > 0
                          ? l10n.matchingContinueAction
                          : l10n.matchingRecommendedAction,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...puzzles.map(
              (puzzle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchingPuzzleCard(
                  puzzle: puzzle,
                  progress: progress.progressFor(puzzle.id),
                  onOpen: () => context.pushNamed(
                    'learnMatchingPuzzle',
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

  int _sortPriority(MatchingPuzzleProgress progress) {
    if (progress.isStarted && !progress.isCompleted) return 0;
    if (!progress.isCompleted) return 1;
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

class _MatchingPuzzleCard extends StatelessWidget {
  const _MatchingPuzzleCard({
    required this.puzzle,
    required this.progress,
    required this.onOpen,
  });

  final MatchingPuzzle puzzle;
  final MatchingPuzzleProgress progress;
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
              _chip(context, matchingLocalizedCategory(l10n, puzzle.category)),
              _chip(context, matchingDifficultyLabel(l10n, puzzle.difficulty)),
              _chip(
                context,
                l10n.matchingFoundCountLabel(
                  progress.matchedPairIds.length.toString(),
                  puzzle.pairs.length.toString(),
                ),
              ),
              if (progress.isPerfect) _chip(context, l10n.matchingPerfectBadge),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            matchingPuzzleTitle(l10n, puzzle),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.matchingPairCountLabel(puzzle.pairs.length.toString())),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onOpen,
            icon: Icon(
              progress.isCompleted
                  ? Icons.replay_rounded
                  : Icons.play_arrow_rounded,
            ),
            label: Text(
              progress.isCompleted
                  ? l10n.matchingReplayAction
                  : progress.isStarted
                  ? l10n.matchingContinueAction
                  : l10n.matchingStartAction,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
