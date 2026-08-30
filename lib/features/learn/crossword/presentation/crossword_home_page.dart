import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/utils/reward_feedback.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../presentation/widgets/learn_section_header.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../../../l10n/app_localizations.dart';
import '../../journey/application/family_learning_provider.dart';
import '../application/crossword_progress_provider.dart';
import '../application/crossword_repository.dart';
import '../domain/crossword_models.dart';
import 'crossword_ui_helpers.dart';

class CrosswordHomePage extends ConsumerWidget {
  const CrosswordHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(crosswordCatalogProvider);
    final dailyAsync = ref.watch(crosswordDailyPuzzleProvider);
    final progress = ref.watch(crosswordProgressProvider);
    final xpSummary = ref.watch(journeyXpSummaryProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.grid_view_rounded,
      title: l10n.crosswordHomeTitle,
      subtitle: l10n.crosswordHomeSubtitle,
      children: [
        catalogAsync.when(
          loading: () => const PremiumCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.crosswordLoadErrorTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.crosswordLoadErrorSubtitle,
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
            final themedPacks = catalog.packs
                .where((pack) => !pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode == 'kids')
                .toList(growable: false);
            final daily = dailyAsync.valueOrNull;
            final completedCount = progress.progressByPuzzleId.values
                .where((item) => item.isCompleted)
                .length;
            final totalCount = catalog.puzzles.length;
            final kidsSummary = catalog.progressForMode(
              CrosswordMode.kids,
              progress,
            );
            final adultSummary = isChildProfile
                ? null
                : catalog.progressForMode(CrosswordMode.adult, progress);
            final dailyProgress = daily == null
                ? null
                : progress.dailyProgressFor(daily.dateKey);
            final dailyStreak = progress.dailyStreakSummary(DateTime.now());
            final recentDailyHistory = progress.recentDailyHistory(limit: 7);
            final visiblePuzzles = isChildProfile
                ? catalog.kidsPuzzles
                : catalog.puzzles;
            final continuePuzzle =
                visiblePuzzles
                    .where((puzzle) {
                      final item = progress.progressFor(puzzle.id);
                      return !item.isCompleted &&
                          (item.startedAtIso ?? '').isNotEmpty;
                    })
                    .toList(growable: false)
                  ..sort((a, b) {
                    final aStamp =
                        progress.progressFor(a.id).lastPlayedAtIso ?? '';
                    final bStamp =
                        progress.progressFor(b.id).lastPlayedAtIso ?? '';
                    return bStamp.compareTo(aStamp);
                  });
            final continuePack = continuePuzzle.isEmpty
                ? null
                : catalog.packs
                      .where(
                        (pack) =>
                            pack.puzzleIds.contains(continuePuzzle.first.id) &&
                            (!isChildProfile || pack.mode == 'kids'),
                      )
                      .firstOrNull;
            return Column(
              children: [
                SectionHubActionGrid(
                  actions: [
                    SectionHubAction(
                      title: l10n.crosswordKidsModeTitle,
                      subtitle: l10n.crosswordKidsModeSubtitle,
                      icon: Icons.child_friendly_rounded,
                      color: const Color(0xFFF4E6C8),
                      accentColor: const Color(0xFF9C6B2F),
                      onTap: () => context.pushNamed(
                        'learnCrosswordPack',
                        pathParameters: {'packId': 'kids_basics'},
                      ),
                    ),
                    if (!isChildProfile)
                      SectionHubAction(
                        title: l10n.crosswordAdultModeTitle,
                        subtitle: l10n.crosswordAdultModeSubtitle,
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFFE8E8D8),
                        accentColor: const Color(0xFF55624D),
                        onTap: () => context.pushNamed(
                          'learnCrosswordPack',
                          pathParameters: {'packId': 'adult_foundations'},
                        ),
                      ),
                    if (!isChildProfile)
                      SectionHubAction(
                        title: l10n.crosswordDailyModeTitle,
                        subtitle: daily == null
                            ? l10n.crosswordDailyModeSubtitle
                            : dailyProgress?.isCompleted == true
                            ? l10n.crosswordDailyCompletedSubtitle(
                                crosswordLocalizedCategory(
                                  l10n,
                                  daily.weekdayTheme,
                                ),
                              )
                            : l10n.crosswordDailyThemeLabel(
                                crosswordLocalizedCategory(
                                  l10n,
                                  daily.weekdayTheme,
                                ),
                              ),
                        icon: Icons.today_rounded,
                        color: const Color(0xFFE2ECE6),
                        accentColor: const Color(0xFF3F6956),
                        onTap: () => context.pushNamed('learnCrosswordDaily'),
                      ),
                  ],
                ),
                if (!isChildProfile && daily != null) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.crosswordDailyModeTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dailyProgress?.isCompleted == true
                              ? l10n.crosswordDailyCompletedSubtitle(
                                  crosswordLocalizedCategory(
                                    l10n,
                                    daily.weekdayTheme,
                                  ),
                                )
                              : l10n.crosswordDailyThemeLabel(
                                  crosswordLocalizedCategory(
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
                              l10n.crosswordDailyStreakLabel(
                                dailyStreak.currentStreak.toString(),
                              ),
                            ),
                            if ((dailyProgress?.startedAtIso ?? '')
                                    .isNotEmpty &&
                                dailyProgress?.isCompleted != true)
                              _chip(context, l10n.crosswordResumeBadge),
                            if (dailyProgress?.isCompleted == true)
                              _chip(context, l10n.crosswordDailyCompleteBadge),
                            if ((dailyProgress
                                        ?.bonusCompletedObjectiveIds
                                        .length ??
                                    0) >
                                0)
                              _chip(
                                context,
                                l10n.crosswordDailyBonusAchievedLabel(
                                  dailyProgress!
                                      .bonusCompletedObjectiveIds
                                      .length
                                      .toString(),
                                ),
                              ),
                          ],
                        ),
                        if (dailyProgress?.isCompleted == true) ...[
                          const SizedBox(height: 10),
                          Text(
                            buildCompactRewardSummary(
                              l10n,
                              xp:
                                  (dailyProgress!.perfectCompletedAtIso ?? '')
                                      .isNotEmpty
                                  ? 2
                                  : 1,
                              drops: _dailyContributionDrops(
                                daily.puzzle,
                                dailyProgress,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: context.palette.onSurfaceSubtle,
                                ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              context.pushNamed('learnCrosswordDaily'),
                          icon: Icon(
                            dailyProgress?.isCompleted == true
                                ? Icons.check_circle_rounded
                                : Icons.today_rounded,
                          ),
                          label: Text(
                            dailyProgress?.isCompleted == true
                                ? l10n.crosswordOpenTodayAction
                                : (dailyProgress?.startedAtIso ?? '').isNotEmpty
                                ? l10n.crosswordContinueAction
                                : l10n.crosswordStartAction,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (!isChildProfile && recentDailyHistory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.crosswordDailyHistoryTitle,
                    subtitle: l10n.crosswordDailyHistorySubtitle,
                  ),
                  const SizedBox(height: 8),
                  PremiumCard(
                    child: Column(
                      children: recentDailyHistory
                          .map((item) {
                            final puzzle = catalog.puzzlesById[item.puzzleId];
                            final themeLabel = crosswordLocalizedCategory(
                              l10n,
                              item.weekdayTheme ?? 'mixed',
                            );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DailyHistoryRow(
                                dateKey: item.dateKey,
                                themeLabel: themeLabel,
                                title: puzzle == null
                                    ? l10n.crosswordDailyModeTitle
                                    : crosswordPuzzleTitle(l10n, puzzle),
                                isCompleted: item.isCompleted,
                                isPerfect: (item.perfectCompletedAtIso ?? '')
                                    .isNotEmpty,
                                bonusCount:
                                    item.bonusCompletedObjectiveIds.length,
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (continuePuzzle.isNotEmpty) ...[
                  LearnSectionHeader(
                    title: l10n.crosswordContinueSectionTitle,
                    subtitle: l10n.crosswordContinueSectionSubtitle,
                  ),
                  const SizedBox(height: 8),
                  _ContinuePuzzleCard(
                    puzzle: continuePuzzle.first,
                    progress: progress.progressFor(continuePuzzle.first.id),
                    pack: continuePack,
                    onOpen: () => context.pushNamed(
                      'learnCrosswordPuzzle',
                      pathParameters: {'puzzleId': continuePuzzle.first.id},
                      queryParameters: {
                        if (continuePack != null) 'pack': continuePack.id,
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                LearnSectionHeader(
                  title: l10n.crosswordOverviewTitle,
                  subtitle: l10n.crosswordOverviewSubtitle,
                ),
                const SizedBox(height: 8),
                _OverviewCard(
                  title: l10n.crosswordKidsModeTitle,
                  subtitle: l10n.crosswordKidsModeSubtitle,
                  summary: kidsSummary,
                  onOpen: kidsSummary.nextPuzzleId == null
                      ? null
                      : () => context.pushNamed(
                          'learnCrosswordPuzzle',
                          pathParameters: {
                            'puzzleId': kidsSummary.nextPuzzleId!,
                          },
                        ),
                ),
                if (!isChildProfile) ...[
                  const SizedBox(height: 10),
                  _OverviewCard(
                    title: l10n.crosswordAdultModeTitle,
                    subtitle: l10n.crosswordAdultModeSubtitle,
                    summary: adultSummary!,
                    onOpen: adultSummary.nextPuzzleId == null
                        ? null
                        : () => context.pushNamed(
                            'learnCrosswordPuzzle',
                            pathParameters: {
                              'puzzleId': adultSummary.nextPuzzleId!,
                            },
                          ),
                  ),
                ],
                const SizedBox(height: 12),
                if (featuredPacks.isNotEmpty) ...[
                  LearnSectionHeader(
                    title: l10n.crosswordFeaturedPacksTitle,
                    subtitle: l10n.crosswordFeaturedPacksSubtitle,
                  ),
                  const SizedBox(height: 8),
                  ...featuredPacks.map(
                    (pack) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PackCard(
                        pack: pack,
                        summary: catalog.progressForPack(pack.id, progress),
                        onOpen: () => context.pushNamed(
                          'learnCrosswordPack',
                          pathParameters: {'packId': pack.id},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (themedPacks.isNotEmpty) ...[
                  LearnSectionHeader(
                    title: l10n.crosswordThemesTitle,
                    subtitle: l10n.crosswordThemesSubtitle,
                  ),
                  const SizedBox(height: 8),
                  ...themedPacks.map(
                    (pack) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PackCard(
                        pack: pack,
                        summary: catalog.progressForPack(pack.id, progress),
                        onOpen: () => context.pushNamed(
                          'learnCrosswordPack',
                          pathParameters: {'packId': pack.id},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                PremiumCard(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(
                        context,
                        l10n.crosswordPuzzleCountLabel(totalCount.toString()),
                      ),
                      _chip(
                        context,
                        l10n.crosswordCompletedCountLabel(
                          completedCount.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.crosswordTodayXpLabel(
                          xpSummary.todayXp.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.crosswordTodayDropsLabel(
                          dropSummary.todayDrops.toString(),
                        ),
                      ),
                      if (!isChildProfile)
                        _chip(
                          context,
                          l10n.crosswordDailyStreakLabel(
                            dailyStreak.currentStreak.toString(),
                          ),
                        ),
                    ],
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

  int _dailyContributionDrops(
    CrosswordPuzzle puzzle,
    CrosswordDailyProgress dailyProgress,
  ) {
    final bonusDrops =
        (dailyProgress.dailyBonusRewardGrantedAtIso ?? '').isEmpty ? 0 : 2;
    return puzzle.wordCount + bonusDrops;
  }
}

class _ContinuePuzzleCard extends StatelessWidget {
  const _ContinuePuzzleCard({
    required this.puzzle,
    required this.progress,
    required this.onOpen,
    this.pack,
  });

  final CrosswordPuzzle puzzle;
  final CrosswordPuzzleProgress progress;
  final CrosswordPuzzlePack? pack;
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
              if (pack != null) _tag(context, crosswordPackTitle(l10n, pack!)),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onOpen,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.crosswordContinueAction),
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

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.subtitle,
    required this.summary,
    this.onOpen,
  });

  final String title;
  final String subtitle;
  final CrosswordCollectionProgressSummary summary;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag(
                context,
                l10n.crosswordPackProgressLabel(
                  summary.completedPuzzles.toString(),
                  summary.totalPuzzles.toString(),
                ),
              ),
              if (summary.inProgressPuzzles > 0)
                _tag(
                  context,
                  l10n.crosswordResumeSectionCount(
                    summary.inProgressPuzzles.toString(),
                  ),
                ),
              if (summary.perfectPuzzles > 0)
                _tag(
                  context,
                  l10n.crosswordPerfectCountLabel(
                    summary.perfectPuzzles.toString(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ProgressBar(value: summary.completionFraction, height: 8),
          if (onOpen != null) ...[
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: onOpen,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                summary.inProgressPuzzles > 0
                    ? l10n.crosswordContinueAction
                    : l10n.crosswordRecommendedAction,
              ),
            ),
          ],
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

class _PackCard extends StatelessWidget {
  const _PackCard({
    required this.pack,
    required this.summary,
    required this.onOpen,
  });

  final CrosswordPuzzlePack pack;
  final CrosswordPackProgressSummary summary;
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
              _tag(context, crosswordLocalizedCategory(l10n, pack.category)),
              _tag(
                context,
                l10n.crosswordPackDifficultyLabel(
                  pack.minDifficulty.toString(),
                  pack.maxDifficulty.toString(),
                ),
              ),
              if (pack.isDailyEligible)
                _tag(context, l10n.crosswordDailyModeTitle),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            crosswordPackTitle(l10n, pack),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            crosswordPackSubtitle(l10n, pack),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 10),
          ProgressBar(value: summary.completionFraction, height: 8),
          const SizedBox(height: 10),
          Text(
            l10n.crosswordPackProgressLabel(
              summary.completedPuzzles.toString(),
              summary.totalPuzzles.toString(),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onOpen,
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(
              summary.inProgressPuzzles > 0
                  ? l10n.crosswordContinuePackAction
                  : l10n.crosswordOpenPackAction,
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

class _DailyHistoryRow extends StatelessWidget {
  const _DailyHistoryRow({
    required this.dateKey,
    required this.themeLabel,
    required this.title,
    required this.isCompleted,
    required this.isPerfect,
    required this.bonusCount,
  });

  final String dateKey;
  final String themeLabel;
  final String title;
  final bool isCompleted;
  final bool isPerfect;
  final int bonusCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateKey,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                themeLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (isCompleted)
              _HistoryChip(label: l10n.crosswordDailyCompleteBadge),
            if (isPerfect) _HistoryChip(label: l10n.crosswordPerfectBadge),
            if (bonusCount > 0)
              _HistoryChip(
                label: l10n.crosswordDailyBonusAchievedLabel(
                  bonusCount.toString(),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
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
