import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../knowledge_games/application/knowledge_game_recommendations.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
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
      loading: () => LearnHubPageScaffold(
        headerIcon: Icons.text_fields_rounded,
        title: l10n.wordSearchHomeTitle,
        subtitle: l10n.wordSearchLoadingSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (_, _) => LearnHubPageScaffold(
        headerIcon: Icons.text_fields_rounded,
        title: l10n.wordSearchHomeTitle,
        subtitle: l10n.wordSearchLoadErrorSubtitle,
        children: [PremiumCard(child: Text(l10n.wordSearchLoadErrorTitle))],
      ),
      data: (catalog) {
        final pack = catalog.packsById[packId];
        if (pack == null) {
          return LearnHubPageScaffold(
            headerIcon: Icons.text_fields_rounded,
            title: l10n.wordSearchHomeTitle,
            subtitle: l10n.wordSearchNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.wordSearchNotFoundTitle))],
          );
        }
        if (isChildProfile && pack.mode != 'kids' && pack.mode != 'mixed') {
          return LearnHubPageScaffold(
            headerIcon: Icons.text_fields_rounded,
            title: l10n.wordSearchHomeTitle,
            subtitle: l10n.wordSearchNotFoundSubtitle,
            children: [PremiumCard(child: Text(l10n.wordSearchKidsOnlyTitle))],
          );
        }

        final puzzles =
            pack.puzzleIds
                .map((id) => catalog.puzzlesById[id])
                .whereType<WordSearchPuzzle>()
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

        return LearnHubPageScaffold(
          headerIcon: Icons.text_fields_rounded,
          title: wordSearchPackTitle(l10n, pack),
          subtitle: wordSearchPackSubtitle(l10n, pack),
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
                        wordSearchLocalizedCategory(l10n, pack.category),
                      ),
                      _chip(
                        context,
                        l10n.wordSearchPackDifficultyLabel(
                          pack.minDifficulty.toString(),
                          pack.maxDifficulty.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.wordSearchPackProgressLabel(
                          packSummary.completedPuzzles.toString(),
                          packSummary.totalPuzzles.toString(),
                        ),
                      ),
                      if (packSummary.perfectPuzzles > 0)
                        _chip(
                          context,
                          l10n.wordSearchPackPerfectLabel(
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
                      'learnWordSearchPuzzle',
                      pathParameters: {'puzzleId': recommended.id},
                      queryParameters: {'pack': pack.id},
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      packSummary.inProgressPuzzles > 0
                          ? l10n.wordSearchContinueAction
                          : l10n.wordSearchRecommendedAction,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...puzzles.map(
              (puzzle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WordSearchPuzzleCard(
                  puzzle: puzzle,
                  progress: progress.progressFor(puzzle.id),
                  onOpen: () => context.pushNamed(
                    'learnWordSearchPuzzle',
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

  int _sortPriority(WordSearchPuzzleProgress progress) {
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

class _WordSearchPuzzleCard extends StatelessWidget {
  const _WordSearchPuzzleCard({
    required this.puzzle,
    required this.progress,
    required this.onOpen,
  });

  final WordSearchPuzzle puzzle;
  final WordSearchPuzzleProgress progress;
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
              _chip(
                context,
                wordSearchLocalizedCategory(l10n, puzzle.category),
              ),
              _chip(
                context,
                wordSearchDifficultyLabel(l10n, puzzle.difficulty),
              ),
              _chip(
                context,
                l10n.wordSearchFoundCountLabel(
                  progress.foundWordIds.length.toString(),
                  puzzle.targetWords.length.toString(),
                ),
              ),
              if (progress.isPerfect)
                _chip(context, l10n.wordSearchPerfectBadge),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            wordSearchPuzzleTitle(l10n, puzzle),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.wordSearchGridSizeLabel(puzzle.gridSize.toString())),
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
                  ? l10n.wordSearchReplayAction
                  : progress.isStarted
                  ? l10n.wordSearchContinueAction
                  : l10n.wordSearchStartAction,
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
