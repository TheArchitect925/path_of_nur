import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
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
      loading: () => LearnHubPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: l10n.hadithReflectionHomeTitle,
        subtitle: l10n.hadithReflectionLoadingSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (_, _) => LearnHubPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: l10n.hadithReflectionHomeTitle,
        subtitle: l10n.hadithReflectionLoadErrorSubtitle,
        children: [
          PremiumCard(child: Text(l10n.hadithReflectionLoadErrorTitle)),
        ],
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return LearnHubPageScaffold(
            headerIcon: Icons.menu_book_rounded,
            title: l10n.hadithReflectionHomeTitle,
            subtitle: l10n.hadithReflectionNotFoundSubtitle,
            children: [
              PremiumCard(child: Text(l10n.hadithReflectionNotFoundTitle)),
            ],
          );
        }
        if (isChildProfile && pack.mode == 'adult') {
          return LearnHubPageScaffold(
            headerIcon: Icons.menu_book_rounded,
            title: l10n.hadithReflectionHomeTitle,
            subtitle: l10n.hadithReflectionNotFoundSubtitle,
            children: [
              PremiumCard(child: Text(l10n.hadithReflectionKidsOnlyTitle)),
            ],
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<HadithReflectionPuzzle>()
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

        return LearnHubPageScaffold(
          headerIcon: Icons.menu_book_rounded,
          title: hadithReflectionPackTitle(l10n, pack),
          subtitle: hadithReflectionPackSubtitle(l10n, pack),
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
                        hadithReflectionLocalizedCategory(l10n, pack.category),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionPackDifficultyLabel(
                          pack.minDifficulty.toString(),
                          pack.maxDifficulty.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionPackProgressLabel(
                          packSummary.completedPuzzles.toString(),
                          packSummary.totalPuzzles.toString(),
                        ),
                      ),
                      if (packSummary.bestChoicePuzzles > 0)
                        _chip(
                          context,
                          l10n.hadithReflectionPackBestChoiceLabel(
                            packSummary.bestChoicePuzzles.toString(),
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
                      'learnHadithReflectionPuzzle',
                      pathParameters: {'puzzleId': recommended.id},
                      queryParameters: {'pack': pack.id},
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      packSummary.inProgressPuzzles > 0
                          ? l10n.hadithReflectionContinueAction
                          : l10n.hadithReflectionRecommendedAction,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...puzzles.map(
              (puzzle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PuzzleCard(
                  puzzle: puzzle,
                  progress: progress.progressFor(puzzle.id),
                  onOpen: () => context.pushNamed(
                    'learnHadithReflectionPuzzle',
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

  int _sortPriority(HadithReflectionPuzzleProgress progress) {
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

class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({
    required this.puzzle,
    required this.progress,
    required this.onOpen,
  });

  final HadithReflectionPuzzle puzzle;
  final HadithReflectionPuzzleProgress progress;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CardButton(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                hadithReflectionLocalizedCategory(l10n, puzzle.category),
              ),
              _chip(
                context,
                hadithReflectionDifficultyLabel(l10n, puzzle.difficulty),
              ),
              if (progress.isBestChoice)
                _chip(context, l10n.hadithReflectionBestChoiceBadge)
              else if (progress.isCompleted)
                _chip(context, l10n.hadithReflectionCompletedBadge)
              else if (progress.isStarted)
                _chip(context, l10n.hadithReflectionResumeBadge),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            puzzle.scenarioTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            puzzle.scenarioDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            puzzle.shortTeachingSummary,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
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

class _CardButton extends StatelessWidget {
  const _CardButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: PremiumCard(child: child),
    );
  }
}
