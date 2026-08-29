import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/application/family_learning_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../presentation/widgets/learn_section_header.dart';
import '../application/hadith_reflection_progress_provider.dart';
import '../application/hadith_reflection_repository.dart';
import '../domain/hadith_reflection_models.dart';
import 'hadith_reflection_ui_helpers.dart';

class HadithReflectionHomePage extends ConsumerWidget {
  const HadithReflectionHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(hadithReflectionCatalogProvider);
    final dailyAsync = ref.watch(hadithReflectionDailyPuzzleProvider);
    final progress = ref.watch(hadithReflectionProgressProvider);
    final xpSummary = ref.watch(journeyXpSummaryProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.hadithReflectionHomeTitle,
      subtitle: l10n.hadithReflectionHomeSubtitle,
      children: [
        catalogAsync.when(
          loading: () => const PremiumCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.hadithReflectionLoadErrorTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithReflectionLoadErrorSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          data: (catalog) {
            final visiblePuzzles = isChildProfile
                ? catalog.kidsPuzzles
                : catalog.puzzles;
            final featuredPacks = catalog.packs
                .where((pack) => pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode != 'adult')
                .toList(growable: false);
            final themedPacks = catalog.packs
                .where((pack) => !pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode != 'adult')
                .toList(growable: false);
            final inProgress =
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
            final bestCount = progress.progressByPuzzleId.values
                .where((item) => item.isBestChoice)
                .length;

            return Column(
              children: [
                _ModeGrid(daily: daily, dailyProgress: dailyProgress),
                const SizedBox(height: 12),
                PremiumCard(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(
                        context,
                        l10n.hadithReflectionPuzzleCountLabel(
                          visiblePuzzles.length.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionCompletedCountLabel(
                          completedCount.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionBestChoiceCountLabel(
                          bestCount.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionXpLabel(
                          xpSummary.totalXp.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.hadithReflectionDropsLabel(
                          dropSummary.totalDrops.toString(),
                        ),
                      ),
                      if (dailyStreak.currentStreak > 0)
                        _chip(
                          context,
                          l10n.hadithReflectionDailyStreakLabel(
                            dailyStreak.currentStreak.toString(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (inProgress.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.hadithReflectionContinueSectionTitle,
                    subtitle: l10n.hadithReflectionContinueSectionSubtitle,
                  ),
                  const SizedBox(height: 8),
                  _ContinueCard(
                    puzzle: inProgress.first,
                    progress: progress.progressFor(inProgress.first.id),
                  ),
                ],
                if (recentHistory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.hadithReflectionDailyHistoryTitle,
                    subtitle: l10n.hadithReflectionDailyHistorySubtitle,
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
                                  Text(puzzle.scenarioTitle),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.dateKey} • ${hadithReflectionLocalizedCategory(l10n, item.weekdayTheme ?? puzzle.category)}',
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
                  title: l10n.hadithReflectionFeaturedPacksTitle,
                  subtitle: l10n.hadithReflectionFeaturedPacksSubtitle,
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
                  title: l10n.hadithReflectionThemesTitle,
                  subtitle: l10n.hadithReflectionThemesSubtitle,
                ),
                const SizedBox(height: 8),
                ...themedPacks.map(
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
}

class _ModeGrid extends ConsumerWidget {
  const _ModeGrid({required this.daily, required this.dailyProgress});

  final HadithReflectionDailyPuzzle? daily;
  final HadithReflectionDailyProgress? dailyProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return Column(
      children: [
        _CardButton(
          onTap: () => context.pushNamed('learnHadithReflectionDaily'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithReflectionDailyModeTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(l10n.hadithReflectionDailyModeSubtitle),
              if (daily != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _modeChip(
                      context,
                      l10n.hadithReflectionDailyThemeLabel(
                        hadithReflectionLocalizedCategory(
                          l10n,
                          daily!.weekdayTheme,
                        ),
                      ),
                    ),
                    if (dailyProgress?.isCompleted == true)
                      _modeChip(
                        context,
                        l10n.hadithReflectionDailyCompleteBadge,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _CardButton(
                onTap: () => context.pushNamed(
                  'learnHadithReflectionPack',
                  pathParameters: {'packId': 'hadith_reflection_kids_kindness'},
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hadithReflectionKidsModeTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.hadithReflectionKidsModeSubtitle),
                  ],
                ),
              ),
            ),
            if (!isChildProfile) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _CardButton(
                  onTap: () => context.pushNamed(
                    'learnHadithReflectionPack',
                    pathParameters: {
                      'packId': 'hadith_reflection_honesty_trust',
                    },
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.hadithReflectionAdultModeTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.hadithReflectionAdultModeSubtitle),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.puzzle, required this.progress});

  final HadithReflectionPuzzle puzzle;
  final HadithReflectionPuzzleProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CardButton(
      onTap: () => context.pushNamed(
        'learnHadithReflectionPuzzle',
        pathParameters: {'puzzleId': puzzle.id},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 10),
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
              if (progress.selectedChoiceId != null)
                _chip(context, l10n.hadithReflectionResumeBadge),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackCard extends ConsumerWidget {
  const _PackCard({required this.pack, required this.progress});

  final HadithReflectionPuzzlePack pack;
  final HadithReflectionProgressState progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(hadithReflectionCatalogProvider).valueOrNull;
    final summary = catalog?.progressForPack(pack.id, progress);
    return _CardButton(
      onTap: () => context.pushNamed(
        'learnHadithReflectionPack',
        pathParameters: {'packId': pack.id},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hadithReflectionPackTitle(l10n, pack),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(hadithReflectionPackSubtitle(l10n, pack)),
          const SizedBox(height: 10),
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
              if (summary != null)
                _chip(
                  context,
                  l10n.hadithReflectionPackProgressLabel(
                    summary.completedPuzzles.toString(),
                    summary.totalPuzzles.toString(),
                  ),
                ),
            ],
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

Widget _modeChip(BuildContext context, String label) => _chip(context, label);

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
