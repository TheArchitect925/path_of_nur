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
import '../application/ayah_completion_progress_provider.dart';
import '../application/ayah_completion_repository.dart';
import '../domain/ayah_completion_models.dart';
import 'ayah_completion_ui_helpers.dart';

class AyahCompletionHomePage extends ConsumerWidget {
  const AyahCompletionHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(ayahCompletionCatalogProvider);
    final dailyAsync = ref.watch(ayahCompletionDailyPuzzleProvider);
    final progress = ref.watch(ayahCompletionProgressProvider);
    final xpSummary = ref.watch(journeyXpSummaryProvider);
    final dropSummary = ref.watch(journeyDropSummaryProvider);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: l10n.ayahCompletionHomeTitle,
      subtitle: l10n.ayahCompletionHomeSubtitle,
      children: [
        catalogAsync.when(
          loading: () => const PremiumCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.ayahCompletionLoadErrorTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.ayahCompletionLoadErrorSubtitle,
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
                .where((pack) => !isChildProfile || pack.mode == 'kids')
                .toList(growable: false);
            final otherPacks = catalog.packs
                .where((pack) => !pack.isFeatured)
                .where((pack) => !isChildProfile || pack.mode == 'kids')
                .toList(growable: false);
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
            final recentHistory = progress.recentDailyHistory(limit: 7);
            final completedCount = progress.progressByPuzzleId.values
                .where((item) => item.isCompleted)
                .length;
            final daily = dailyAsync.valueOrNull;
            final dailyProgress = daily == null
                ? null
                : progress.dailyProgressFor(daily.dateKey);
            final dailyStreak = progress.dailyStreakSummary(DateTime.now());

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
                        l10n.ayahCompletionPuzzleCountLabel(
                          catalog.puzzles.length.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.ayahCompletionCompletedCountLabel(
                          completedCount.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.ayahCompletionXpLabel(
                          xpSummary.totalXp.toString(),
                        ),
                      ),
                      _chip(
                        context,
                        l10n.ayahCompletionDropsLabel(
                          dropSummary.totalDrops.toString(),
                        ),
                      ),
                      if (dailyStreak.currentStreak > 0)
                        _chip(
                          context,
                          l10n.ayahCompletionDailyStreakLabel(
                            dailyStreak.currentStreak.toString(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (continuePuzzle.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.ayahCompletionContinueSectionTitle,
                    subtitle: l10n.ayahCompletionContinueSectionSubtitle,
                  ),
                  const SizedBox(height: 8),
                  _ContinueCard(
                    puzzle: continuePuzzle.first,
                    progress: progress.progressFor(continuePuzzle.first.id),
                  ),
                ],
                if (recentHistory.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  LearnSectionHeader(
                    title: l10n.ayahCompletionDailyHistoryTitle,
                    subtitle: l10n.ayahCompletionDailyHistorySubtitle,
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
                                  Text(ayahCompletionPuzzleTitle(l10n, puzzle)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.dateKey} • ${ayahCompletionLocalizedCategory(l10n, item.weekdayTheme ?? puzzle.category)}',
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
                  title: l10n.ayahCompletionFeaturedPacksTitle,
                  subtitle: l10n.ayahCompletionFeaturedPacksSubtitle,
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
                  title: l10n.ayahCompletionThemesTitle,
                  subtitle: l10n.ayahCompletionThemesSubtitle,
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

class _ModeGrid extends ConsumerWidget {
  const _ModeGrid({required this.daily, required this.dailyProgress});

  final AyahCompletionDailyPuzzle? daily;
  final AyahCompletionDailyProgress? dailyProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isChildProfile = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy.isChildProfile,
      ),
    );
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _actionCard(
          context,
          title: l10n.ayahCompletionKidsModeTitle,
          subtitle: l10n.ayahCompletionKidsModeSubtitle,
          icon: Icons.child_friendly_rounded,
          onTap: () => context.pushNamed(
            'learnAyahCompletionPack',
            pathParameters: {'packId': 'ayah_kids_short_surahs'},
          ),
        ),
        if (!isChildProfile)
          _actionCard(
            context,
            title: l10n.ayahCompletionAdultModeTitle,
            subtitle: l10n.ayahCompletionAdultModeSubtitle,
            icon: Icons.menu_book_rounded,
            onTap: () => context.pushNamed(
              'learnAyahCompletionPack',
              pathParameters: {'packId': 'ayah_adult_short_surahs'},
            ),
          ),
        _actionCard(
          context,
          title: l10n.ayahCompletionDailyModeTitle,
          subtitle: daily == null
              ? l10n.ayahCompletionDailyModeSubtitle
              : dailyProgress?.isCompleted == true
              ? l10n.ayahCompletionDailyCompletedSubtitle(
                  ayahCompletionLocalizedCategory(l10n, daily!.weekdayTheme),
                )
              : l10n.ayahCompletionDailyThemeLabel(
                  ayahCompletionLocalizedCategory(l10n, daily!.weekdayTheme),
                ),
          icon: Icons.today_rounded,
          onTap: () => context.pushNamed('learnAyahCompletionDaily'),
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 260,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(subtitle),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.puzzle, required this.progress});

  final AyahCompletionPuzzle puzzle;
  final AyahCompletionPuzzleProgress progress;

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
                ayahCompletionLocalizedCategory(l10n, puzzle.category),
              ),
              _chip(
                context,
                ayahCompletionDifficultyLabel(l10n, puzzle.difficulty),
              ),
              _chip(
                context,
                l10n.ayahCompletionProgressCountLabel(
                  progress.filledWordsByBlankIndex.length.toString(),
                  puzzle.blanks.length.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ayahCompletionPuzzleTitle(l10n, puzzle),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.ayahCompletionReferenceLabel(puzzle.ref.locationLabel)),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnAyahCompletionPuzzle',
              pathParameters: {'puzzleId': puzzle.id},
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.ayahCompletionContinueAction),
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

class _PackCard extends StatelessWidget {
  const _PackCard({required this.pack, required this.progress});

  final AyahCompletionPuzzlePack pack;
  final AyahCompletionProgressState progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(ayahCompletionCatalogProvider).valueOrNull;
    final summary =
        catalog?.progressForPack(pack.id, progress) ??
        const AyahCompletionPackProgressSummary(
          totalPuzzles: 0,
          completedPuzzles: 0,
          perfectPuzzles: 0,
          inProgressPuzzles: 0,
          nextPuzzleId: null,
        );
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
                ayahCompletionLocalizedCategory(l10n, pack.category),
              ),
              _chip(
                context,
                l10n.ayahCompletionPackProgressLabel(
                  summary.completedPuzzles.toString(),
                  summary.totalPuzzles.toString(),
                ),
              ),
              if (summary.perfectPuzzles > 0)
                _chip(
                  context,
                  l10n.ayahCompletionPackPerfectLabel(
                    summary.perfectPuzzles.toString(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ayahCompletionPackTitle(l10n, pack),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(ayahCompletionPackSubtitle(l10n, pack)),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnAyahCompletionPack',
              pathParameters: {'packId': pack.id},
            ),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.ayahCompletionOpenPackAction),
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
