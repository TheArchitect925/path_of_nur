import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../presentation/widgets/learn_section_header.dart';
import '../application/word_search_progress_provider.dart';
import '../application/word_search_repository.dart';
import '../domain/word_search_models.dart';
import 'word_search_ui_helpers.dart';

class WordSearchHomePage extends ConsumerWidget {
  const WordSearchHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(wordSearchCatalogProvider);
    final dailyAsync = ref.watch(wordSearchDailyPuzzleProvider);
    final progress = ref.watch(wordSearchProgressProvider);
    final xpSummary = ref.watch(journeyXpSummaryProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.text_fields_rounded,
      title: l10n.wordSearchHomeTitle,
      subtitle: l10n.wordSearchHomeSubtitle,
      children: [
        catalogAsync.when(
          loading: () => const PremiumCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.wordSearchLoadErrorTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.wordSearchLoadErrorSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          data: (catalog) {
            final featuredPacks = catalog.packs
                .where((pack) => pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode == 'kids')
                .toList(growable: false);
            final otherPacks = catalog.packs
                .where((pack) => !pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode == 'kids')
                .toList(growable: false);
            final visiblePuzzles = isChildProfile
                ? catalog.kidsPuzzles
                : catalog.puzzles;
            final continuePuzzle =
                visiblePuzzles
                    .where((puzzle) {
                      final item = progress.progressFor(puzzle.id);
                      return item.isStarted && !item.isCompleted;
                    })
                    .toList(growable: false)
                  ..sort((a, b) {
                    final aStamp =
                        progress.progressFor(a.id).lastPlayedAtIso ?? '';
                    final bStamp =
                        progress.progressFor(b.id).lastPlayedAtIso ?? '';
                    return bStamp.compareTo(aStamp);
                  });
            final daily = dailyAsync.valueOrNull;
            final dailyProgress = daily == null
                ? null
                : progress.dailyProgressFor(daily.dateKey);
            final dailyStreak = progress.dailyStreakSummary(DateTime.now());
            final recentHistory = progress.recentDailyHistory(limit: 7);
            final completedCount = progress.progressByPuzzleId.values
                .where((item) => item.isCompleted)
                .length;
            return Column(
              children: [
                SectionHubActionGrid(
                  actions: [
                    SectionHubAction(
                      title: l10n.wordSearchKidsModeTitle,
                      subtitle: l10n.wordSearchKidsModeSubtitle,
                      icon: Icons.child_friendly_rounded,
                      color: const Color(0xFFF3E9CF),
                      accentColor: const Color(0xFF8C6239),
                      onTap: () => context.pushNamed(
                        'learnWordSearchPack',
                        pathParameters: {'packId': 'kids_starter_words'},
                      ),
                    ),
                    if (!isChildProfile)
                      SectionHubAction(
                        title: l10n.wordSearchAdultModeTitle,
                        subtitle: l10n.wordSearchAdultModeSubtitle,
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFFE7E7DA),
                        accentColor: const Color(0xFF56634E),
                        onTap: () => context.pushNamed(
                          'learnWordSearchPack',
                          pathParameters: {'packId': 'adult_foundations_words'},
                        ),
                      ),
                    SectionHubAction(
                      title: l10n.wordSearchDailyModeTitle,
                      subtitle: daily == null
                          ? l10n.wordSearchDailyModeSubtitle
                          : dailyProgress?.isCompleted == true
                          ? l10n.wordSearchDailyCompletedSubtitle(
                              wordSearchLocalizedCategory(
                                l10n,
                                daily.weekdayTheme,
                              ),
                            )
                          : l10n.wordSearchDailyThemeLabel(
                              wordSearchLocalizedCategory(
                                l10n,
                                daily.weekdayTheme,
                              ),
                            ),
                      icon: Icons.today_rounded,
                      color: const Color(0xFFE2ECE6),
                      accentColor: const Color(0xFF3F6956),
                      onTap: () => context.pushNamed('learnWordSearchDaily'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PremiumCard(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(
                        context,
                        l10n.wordSearchPuzzleCountLabel(
                          catalog.puzzles.length.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.wordSearchCompletedCountLabel(
                          completedCount.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.wordSearchXpLabel(xpSummary.totalXp.toString()),
                      ),
                      _chip(
                        context,
                        l10n.wordSearchDropsLabel(
                          dropSummary.totalDrops.toString(),
                        ),
                      ),
                      if (dailyStreak.currentStreak > 0)
                        _chip(
                          context,
                          l10n.wordSearchDailyStreakLabel(
                            dailyStreak.currentStreak.toString(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (daily != null) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.wordSearchDailyModeTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dailyProgress?.isCompleted == true
                              ? l10n.wordSearchDailyCompletedSubtitle(
                                  wordSearchLocalizedCategory(
                                    l10n,
                                    daily.weekdayTheme,
                                  ),
                                )
                              : l10n.wordSearchDailyThemeLabel(
                                  wordSearchLocalizedCategory(
                                    l10n,
                                    daily.weekdayTheme,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(
                              context,
                              wordSearchDifficultyLabel(
                                l10n,
                                daily.puzzle.difficulty,
                              ),
                            ),
                            if (dailyProgress?.isCompleted == true)
                              _chip(context, l10n.wordSearchDailyCompleteBadge)
                            else if ((dailyProgress?.startedAtIso ?? '')
                                .isNotEmpty)
                              _chip(context, l10n.wordSearchResumeBadge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              context.pushNamed('learnWordSearchDaily'),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(
                            dailyProgress?.isCompleted == true
                                ? l10n.wordSearchOpenTodayAction
                                : (dailyProgress?.startedAtIso ?? '').isNotEmpty
                                ? l10n.wordSearchContinueAction
                                : l10n.wordSearchStartAction,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (continuePuzzle.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.wordSearchContinueSectionTitle,
                    subtitle: l10n.wordSearchContinueSectionSubtitle,
                  ),
                  const SizedBox(height: 8),
                  _ContinuePuzzleCard(
                    puzzle: continuePuzzle.first,
                    progress: progress.progressFor(continuePuzzle.first.id),
                  ),
                ],
                if (recentHistory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.wordSearchDailyHistoryTitle,
                    subtitle: l10n.wordSearchDailyHistorySubtitle,
                  ),
                  const SizedBox(height: 8),
                  ...recentHistory.map((item) {
                    final puzzle = catalog.puzzlesById[item.puzzleId];
                    if (puzzle == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: Row(
                          children: [
                            Icon(
                              item.isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.history_rounded,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(wordSearchPuzzleTitle(l10n, puzzle)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.dateKey} • ${wordSearchLocalizedCategory(l10n, item.weekdayTheme ?? puzzle.category)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 12),
                LearnSectionHeader(
                  title: l10n.wordSearchFeaturedPacksTitle,
                  subtitle: l10n.wordSearchFeaturedPacksSubtitle,
                ),
                const SizedBox(height: 8),
                ...featuredPacks.map(
                  (pack) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PackCard(pack: pack, progress: progress),
                  ),
                ),
                const SizedBox(height: 12),
                LearnSectionHeader(
                  title: l10n.wordSearchThemesTitle,
                  subtitle: l10n.wordSearchThemesSubtitle,
                ),
                const SizedBox(height: 8),
                ...otherPacks.map(
                  (pack) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PackCard(pack: pack, progress: progress),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
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

class _ContinuePuzzleCard extends StatelessWidget {
  const _ContinuePuzzleCard({required this.puzzle, required this.progress});

  final WordSearchPuzzle puzzle;
  final WordSearchPuzzleProgress progress;

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
              _tag(context, wordSearchLocalizedCategory(l10n, puzzle.category)),
              _tag(context, wordSearchDifficultyLabel(l10n, puzzle.difficulty)),
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
          Text(
            l10n.wordSearchFoundCountLabel(
              progress.foundWordIds.length.toString(),
              puzzle.targetWords.length.toString(),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnWordSearchPuzzle',
              pathParameters: {'puzzleId': puzzle.id},
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.wordSearchContinueAction),
          ),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String label) {
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

class _PackCard extends ConsumerWidget {
  const _PackCard({required this.pack, required this.progress});

  final WordSearchPuzzlePack pack;
  final WordSearchProgressState progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(wordSearchCatalogProvider).valueOrNull;
    final summary = catalog?.progressForPack(pack.id, progress);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag(context, wordSearchLocalizedCategory(l10n, pack.category)),
              _tag(
                context,
                l10n.wordSearchPackDifficultyLabel(
                  pack.minDifficulty.toString(),
                  pack.maxDifficulty.toString(),
                ),
              ),
              if (summary != null)
                _tag(
                  context,
                  l10n.wordSearchPackProgressLabel(
                    summary.completedPuzzles.toString(),
                    summary.totalPuzzles.toString(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            wordSearchPackTitle(l10n, pack),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(wordSearchPackSubtitle(l10n, pack)),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnWordSearchPack',
              pathParameters: {'packId': pack.id},
            ),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.wordSearchOpenPackAction),
          ),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String label) {
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
