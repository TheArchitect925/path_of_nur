import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/hadith_daily_reflection_service.dart';
import '../application/hadith_foundation_repository.dart';
import '../application/hadith_learning_paths_service.dart';
import '../application/hadith_path_quiz_service.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_learning_path.dart';
import 'widgets/hadith_content_block.dart';

enum _HadithTab { themes, collections, saved, daily, review, paths }

class HadithLandingPage extends ConsumerStatefulWidget {
  const HadithLandingPage({super.key, this.initialTabName});

  final String? initialTabName;

  @override
  ConsumerState<HadithLandingPage> createState() => _HadithLandingPageState();
}

class _HadithLandingPageState extends ConsumerState<HadithLandingPage> {
  _HadithTab _selectedTab = _HadithTab.themes;
  late final QuranQuote _entryQuote;

  @override
  void initState() {
    super.initState();
    _entryQuote = buildMessengerGuidanceQuoteForAccess();
    // trigger an assignment once after the first frame; the bundle provider no
    // longer performs this side effect itself.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialTab = _parseInitialTab(widget.initialTabName);
      if (initialTab != null) {
        setState(() => _selectedTab = initialTab);
      }
      final entries = ref.read(hadithEntriesProvider);
      ref
          .read(hadithDailyReflectionControllerProvider.notifier)
          .assignTodayEntry(entries);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _HadithTab? _parseInitialTab(String? value) {
    switch (value) {
      case 'themes':
        return _HadithTab.themes;
      case 'collections':
        return _HadithTab.collections;
      case 'saved':
        return _HadithTab.saved;
      case 'daily':
        return _HadithTab.daily;
      case 'review':
        return _HadithTab.review;
      case 'paths':
        return _HadithTab.paths;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themes = ref.watch(hadithThemesProvider);
    final collections = ref.watch(hadithCollectionBrowseSummariesProvider);
    final savedEntries = ref.watch(savedHadithEntriesProvider);
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final dailyBundle = ref.watch(hadithDailyReflectionBundleProvider);
    final learningPaths = ref.watch(hadithLearningPathsProvider);
    final pathProgress = ref.watch(hadithLearningPathsProgressProvider);
    final dueReviews = ref.watch(hadithDueReviewsProvider);
    final dueReviewEntries = ref.watch(hadithDueReviewEntriesProvider);
    final reviewState = ref.watch(hadithQuizReviewControllerProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.hadithPageTitle,
      subtitle: l10n.hadithPageSubtitle,
      quote: _entryQuote,
      children: [
        SegmentedPillControl<_HadithTab>(
          items: _HadithTab.values,
          selectedItem: _selectedTab,
          labelBuilder: (tab) => _tabLabel(tab, l10n),
          onChanged: (tab) => setState(() => _selectedTab = tab),
        ),
        const SizedBox(height: 12),
        if (_selectedTab == _HadithTab.themes) ...[
          if (dailyBundle.entry != null) ...[
            _DailyHadithHero(bundle: dailyBundle),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: _HadithFeatureTile(
                  icon: Icons.play_arrow_rounded,
                  label: l10n.hadithTitleEssentialStarter,
                  onTap: () => context.pushNamed('learnHadithImportant'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HadithFeatureTile(
                  icon: Icons.tune_rounded,
                  label: l10n.hadithActionBrowseAllHadith,
                  onTap: () => context.pushNamed('hadithBrowse'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HadithFeatureTile(
                  icon: Icons.library_books_rounded,
                  label: l10n.hadithActionBrowseSources,
                  onTap: () => context.pushNamed('hadithSourceBrowse'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HadithFeatureTile(
                  icon: Icons.search_rounded,
                  label: l10n.hadithSearchTitle,
                  onTap: () => context.pushNamed('hadithSearch'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildThemeRows(context, themes, savedIds),
        ],
        if (_selectedTab == _HadithTab.collections) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleCollections,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithSubtitleCollections,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('hadithBrowse'),
                icon: const Icon(Icons.tune_rounded),
                label: Text(l10n.hadithActionBrowseAllHadith),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('hadithSourceBrowse'),
                icon: const Icon(Icons.library_books_rounded),
                label: Text(l10n.hadithActionBrowseSources),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...collections.map(
            (collection) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(collection.title),
                  subtitle: Text(
                    l10n.hadithCollectionCardSummary(
                      collection.subtitle,
                      collection.entryCount,
                    ),
                  ),
                  onTap: () => context.pushNamed(
                    'hadithCollectionDetail',
                    pathParameters: {'collectionId': collection.id},
                  ),
                ),
              ),
            ),
          ),
        ],
        if (_selectedTab == _HadithTab.saved) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleSaved,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithSubtitleSaved,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (savedEntries.isEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hadithEmptySavedTitle,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(l10n.hadithEmptySavedSubtitle),
                ],
              ),
            )
          else
            ...savedEntries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.title),
                    subtitle: Text('${entry.source} • ${entry.grading}'),
                    onTap: () => context.pushNamed(
                      'hadithLessonDetail',
                      pathParameters: {'lessonId': entry.id},
                    ),
                  ),
                ),
              ),
            ),
        ],
        if (_selectedTab == _HadithTab.daily) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleDailyReflection,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  MaterialLocalizations.of(
                    context,
                  ).formatFullDate(dailyBundle.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (dailyBundle.entry == null)
            PremiumCard(child: Text(l10n.hadithEmptyDaily))
          else ...[
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dailyBundle.entry!.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${dailyBundle.entry!.displaySourceCollection}${dailyBundle.entry!.displaySourceReference == null ? '' : ' • ${dailyBundle.entry!.displaySourceReference}'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.hadithGradeLabel(dailyBundle.entry!.grading),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      'hadithLessonDetail',
                      pathParameters: {'lessonId': dailyBundle.entry!.id},
                    ),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(l10n.hadithActionOpenDetail),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _DailySection(
              title: l10n.hadithSectionText,
              child: HadithContentBlock(
                entry: dailyBundle.entry!,
                compact: true,
              ),
            ),
            _DailySection(
              title: l10n.hadithSectionMeaning,
              child: Text(dailyBundle.entry!.meaning),
            ),
            _DailySection(
              title: l10n.hadithSectionQuranConnection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dailyBundle.entry!.quranConnections
                    .map(
                      (item) => QuranReferenceLinkTile(
                        referenceLabel:
                            '${item.surahName} ${item.surahNumber}:${item.verseRange}',
                        surahNumber: item.surahNumber,
                        verseRange: item.verseRange,
                        subtitle: item.label,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        borderRadius: 10,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            _DailySection(
              title: l10n.hadithSectionReflectionPrompts,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dailyBundle.entry!.reflectionPrompts
                    .map(
                      (prompt) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• $prompt'),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            _DailySection(
              title: l10n.hadithSectionPracticeAction,
              child: Text(dailyBundle.entry!.practiceAction),
            ),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hadithCurrentStreakLabel(
                      dailyBundle.currentStreak,
                      dailyBundle.currentStreak == 1 ? '' : 's',
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.hadithBestStreakLabel(
                      dailyBundle.bestStreak,
                      dailyBundle.bestStreak == 1 ? '' : 's',
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (dailyBundle.isCompletedToday)
                    FilledButton.tonalIcon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Text(l10n.hadithActionCompletedToday),
                    )
                  else
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        final awarded = await completeHadithDailyReflection(
                          ref,
                        );
                        if (!context.mounted) return;
                        final xp = JourneyXpRules.xpPerReflectionEntry;
                        final message = awarded
                            ? l10n.hadithReflectionCompletedXp(xp)
                            : l10n.hadithReflectionAlreadyCompletedToday;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      },
                      icon: const Icon(Icons.task_alt_rounded),
                      label: Text(l10n.hadithActionCompleteReflection),
                    ),
                ],
              ),
            ),
          ],
        ],
        if (_selectedTab == _HadithTab.review) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleReview,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithSubtitleReview,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.hadithCompletedChapterQuizzes(
                    reviewState.completedQuizIds.length,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'hadithReviewQuiz',
                    queryParameters: {'mode': 'random'},
                  ),
                  icon: const Icon(Icons.shuffle_rounded),
                  label: Text(l10n.hadithActionRandomReview),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'hadithReviewQuiz',
                    queryParameters: {'mode': 'weekly'},
                  ),
                  icon: const Icon(Icons.calendar_view_week_rounded),
                  label: Text(l10n.hadithActionWeeklyKnowledgeCheck),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _openThemeReviewSelector(context, ref, themes),
                  icon: const Icon(Icons.palette_outlined),
                  label: Text(l10n.hadithActionReviewByTheme),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _openPathReviewSelector(context, ref, learningPaths),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(l10n.hadithActionReviewByLearningPath),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleSpacedRepetition,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  dueReviews.isEmpty
                      ? l10n.hadithNoLessonsDueReview
                      : l10n.hadithLessonsDueReview(dueReviews.length),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (dueReviewEntries.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...dueReviewEntries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.displaySourceCollection} • ${entry.grading}',
                    ),
                    onTap: () => context.pushNamed(
                      'hadithLessonDetail',
                      pathParameters: {'lessonId': entry.id},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
        if (_selectedTab == _HadithTab.paths) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleLearningPaths,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithSubtitleLearningPaths,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...learningPaths.map((path) {
            final summary = ref.watch(
              hadithLearningPathProgressProvider(path.id),
            );
            final completed = summary?.completedLessons ?? 0;
            final total = summary?.totalLessons ?? path.lessonIds.length;
            final ratio = summary?.ratio ?? 0.0;
            final isDone = summary?.isCompleted ?? false;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.pushNamed(
                    'hadithPathDetail',
                    pathParameters: {'pathId': path.id},
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                path.title,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : Icons.chevron_right_rounded,
                              color: isDone
                                  ? AppColors.onSurface
                                  : AppColors.onSurfaceSubtle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(path.subtitle ?? path.description),
                        const SizedBox(height: 10),
                        Text(
                          l10n.hadithPathLessonCount(completed, total),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 7,
                            value: ratio,
                            backgroundColor: AppColors.surface.withValues(
                              alpha: 0.4,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onSurface.withValues(alpha: 0.72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          PremiumCard(
            child: Text(
              l10n.hadithPathStreakLabel(
                pathProgress.currentStreakDays,
                pathProgress.currentStreakDays == 1 ? '' : 's',
                pathProgress.bestStreakDays,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildThemeRows(
    BuildContext context,
    List<HadithTheme> themes,
    Set<String> savedIds,
  ) {
    if (themes.isEmpty) {
      return [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).learnHubSearchEmptyTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).learnHubSearchEmptySubtitle),
            ],
          ),
        ),
      ];
    }

    return [
      for (var index = 0; index < themes.length; index += 1) ...[
        _ThemeCard(theme: themes[index], savedIds: savedIds),
        if (index < themes.length - 1) const SizedBox(height: 10),
      ],
    ];
  }

  String _tabLabel(_HadithTab tab, AppLocalizations l10n) {
    switch (tab) {
      case _HadithTab.themes:
        return l10n.hadithTabThemes;
      case _HadithTab.collections:
        return l10n.hadithTabCollections;
      case _HadithTab.saved:
        return l10n.hadithTabSaved;
      case _HadithTab.daily:
        return l10n.hadithTabDaily;
      case _HadithTab.review:
        return l10n.hadithTabReview;
      case _HadithTab.paths:
        return l10n.hadithTabPaths;
    }
  }

  Future<void> _openThemeReviewSelector(
    BuildContext context,
    WidgetRef ref,
    List<HadithTheme> themes,
  ) async {
    final eligibleThemeIds = ref.read(hadithReviewEligibleThemeIdsProvider);
    final eligible = themes
        .where((theme) => eligibleThemeIds.contains(theme.id))
        .toList(growable: false);
    if (eligible.isEmpty) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: eligible.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final theme = eligible[index];
              return ListTile(
                title: Text(theme.title),
                subtitle: Text(theme.subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).pop();
                  this.context.pushNamed(
                    'hadithReviewQuiz',
                    queryParameters: {'mode': 'theme', 'themeId': theme.id},
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openPathReviewSelector(
    BuildContext context,
    WidgetRef ref,
    List<HadithLearningPath> paths,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: paths.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final path = paths[index];
              return ListTile(
                title: Text(path.title),
                subtitle: Text(path.subtitle ?? path.description),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).pop();
                  this.context.pushNamed(
                    'hadithReviewQuiz',
                    queryParameters: {'mode': 'path', 'pathId': path.id},
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _DailySection extends StatelessWidget {
  const _DailySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends ConsumerWidget {
  const _ThemeCard({required this.theme, required this.savedIds});

  final HadithTheme theme;
  final Set<String> savedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(hadithEntriesForThemeProvider(theme.id));
    final savedInTheme = entries
        .where((entry) => savedIds.contains(entry.id))
        .length;
    final accent = _hadithThemeAccentColor(theme.id);
    final iconBase = _hadithThemeIconBaseColor(theme.id);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.island,
      tintColor: accent,
    );
    final statusStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: accent,
    );
    final innerCardTop =
        Color.lerp(iconBase, Colors.white, 0.38) ?? Colors.white;
    final innerCardBottom = Color.lerp(iconBase, accent, 0.16) ?? accent;
    final innerBorderColor =
        Color.lerp(
          Colors.white.withValues(alpha: 0.88),
          accent.withValues(alpha: 0.30),
          0.36,
        ) ??
        Colors.white.withValues(alpha: 0.88);
    final progressRatio = entries.isEmpty
        ? 0.0
        : (savedInTheme / entries.length).clamp(0.0, 1.0);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        'hadithThemeDetail',
        pathParameters: {'themeId': theme.id},
      ),
      child: PremiumCard(
        padding: const EdgeInsets.all(4),
        surfaceVariant: AppSurfaceVariant.island,
        surfaceTintColor: accent,
        includeShadow: true,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: innerBorderColor),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                innerCardTop.withValues(alpha: 0.94),
                innerCardBottom.withValues(alpha: 0.88),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Color.alphaBlend(
                        iconBase.withValues(alpha: 0.88),
                        surfaceStyle.iconBackgroundColor,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: surfaceStyle.borderColor),
                    ),
                    child: Icon(theme.icon, color: accent),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: statusStyle.decoration(
                      radius: 999,
                      includeShadow: false,
                    ),
                    child: Text(
                      AppLocalizations.of(context).hadithThemeCardCounts(
                        entries.length,
                        theme.quranAnchors.length,
                      ),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                theme.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                theme.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 7,
                  backgroundColor: surfaceStyle.iconBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                savedInTheme > 0
                    ? AppLocalizations.of(
                        context,
                      ).hadithThemeCardProgress(savedInTheme, entries.length)
                    : AppLocalizations.of(context).hadithThemeCardStart,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _hadithThemeAccentColor(String themeId) {
  switch (themeId) {
    case 'faith_intention':
      return const Color(0xFF8A5A44);
    case 'prayer':
      return const Color(0xFF2A7A78);
    case 'character_manners':
      return const Color(0xFF7A5C33);
    case 'mercy_compassion':
      return const Color(0xFF2F8F76);
    case 'knowledge':
      return const Color(0xFF2C6E5B);
    case 'dua_remembrance':
      return const Color(0xFF4B7A52);
    case 'family':
      return const Color(0xFF8B6B44);
    case 'justice_trust':
      return const Color(0xFF6A5A9A);
    case 'repentance':
      return const Color(0xFF9A5A52);
    case 'patience_gratitude':
      return const Color(0xFFA06A2C);
    case 'death_hereafter':
      return const Color(0xFF5B617A);
    default:
      return const Color(0xFF8B6B44);
  }
}

Color _hadithThemeIconBaseColor(String themeId) {
  switch (themeId) {
    case 'faith_intention':
      return const Color(0xFFF2E2D7);
    case 'prayer':
      return const Color(0xFFE1ECEA);
    case 'character_manners':
      return const Color(0xFFF1E6D7);
    case 'mercy_compassion':
      return const Color(0xFFE2F0EB);
    case 'knowledge':
      return const Color(0xFFE2ECE8);
    case 'dua_remembrance':
      return const Color(0xFFE8F1E3);
    case 'family':
      return const Color(0xFFF0E7DA);
    case 'justice_trust':
      return const Color(0xFFE7E4F4);
    case 'repentance':
      return const Color(0xFFF3E1DE);
    case 'patience_gratitude':
      return const Color(0xFFF4E8D6);
    case 'death_hereafter':
      return const Color(0xFFE4E7EE);
    default:
      return const Color(0xFFECE5D7);
  }
}

class _DailyHadithHero extends ConsumerWidget {
  const _DailyHadithHero({required this.bundle});

  final HadithDailyReflectionBundle bundle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = bundle.entry!;
    final sourceLine =
        '${entry.displaySourceCollection}'
        '${entry.displaySourceReference == null ? '' : ' \u2022 ${entry.displaySourceReference}'}';
    return PremiumCard(
      density: PremiumCardDensity.compact,
      onTap: () => context.pushNamed(
        'hadithLessonDetail',
        pathParameters: {'lessonId': entry.id},
      ),
      leading: const Icon(Icons.wb_twilight_rounded),
      title: Text(l10n.hadithTitleDailyReflection),
      trailing: const Icon(Icons.chevron_right_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(sourceLine, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HadithFeatureTile extends StatelessWidget {
  const _HadithFeatureTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      density: PremiumCardDensity.compact,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
