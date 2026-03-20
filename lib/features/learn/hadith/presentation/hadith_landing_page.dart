import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose();
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
    final entries = ref.watch(hadithEntriesProvider);
    final collections = ref.watch(hadithCollectionsProvider);
    final savedEntries = ref.watch(savedHadithEntriesProvider);
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final dailyBundle = ref.watch(hadithDailyReflectionBundleProvider);
    final learningPaths = ref.watch(hadithLearningPathsProvider);
    final pathProgress = ref.watch(hadithLearningPathsProgressProvider);
    final dueReviews = ref.watch(hadithDueReviewsProvider);
    final dueReviewEntries = ref.watch(hadithDueReviewEntriesProvider);
    final reviewState = ref.watch(hadithQuizReviewControllerProvider);

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final filteredThemes = normalizedQuery.isEmpty
        ? themes
        : themes
              .where(
                (theme) => _matchesThemeSearch(
                  theme: theme,
                  entries: entries,
                  normalizedQuery: normalizedQuery,
                ),
              )
              .toList();
    final featuredThemes = normalizedQuery.isEmpty
        ? filteredThemes.where((theme) => theme.isFeatured).toList()
        : <HadithTheme>[];
    final allThemes = normalizedQuery.isEmpty
        ? filteredThemes.where((theme) => !theme.isFeatured).toList()
        : filteredThemes;

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.hadithPageTitle,
      subtitle: l10n.hadithPageSubtitle,
      children: [
        SegmentedPillControl<_HadithTab>(
          items: _HadithTab.values,
          selectedItem: _selectedTab,
          labelBuilder: (tab) => _tabLabel(tab, l10n),
          onChanged: (tab) => setState(() => _selectedTab = tab),
        ),
        const SizedBox(height: 12),
        if (_selectedTab == _HadithTab.themes) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithTitleEssentialStarter,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithSubtitleEssentialStarter,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('learnHadithImportant'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.hadithActionStartEssential),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            surfaceVariant: AppSurfaceVariant.panel,
            child: LearnDiscoverySearchField(
              controller: _searchController,
              hintText: l10n.searchHadithHint,
              onChanged: (value) => setState(() => _searchQuery = value),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),
          const SizedBox(height: 10),
          if (normalizedQuery.isNotEmpty) ...[
            ..._buildThemeRows(context, filteredThemes, savedIds),
          ] else ...[
            if (featuredThemes.isNotEmpty) ...[
              Text(
                l10n.hadithTitleFeaturedThemes,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._buildThemeRows(context, featuredThemes, savedIds),
              const SizedBox(height: 12),
            ],
            Text(
              l10n.hadithAllThemesTitle(allThemes.length),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ..._buildThemeRows(context, allThemes, savedIds),
          ],
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
                      collection.hadithIds.length,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed(
                    'hadithSubcategoryDetail',
                    pathParameters: {'subcategoryId': collection.id},
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
                    trailing: const Icon(Icons.chevron_right_rounded),
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
                    trailing: const Icon(Icons.chevron_right_rounded),
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

  bool _matchesThemeSearch({
    required HadithTheme theme,
    required List<HadithEntry> entries,
    required String normalizedQuery,
  }) {
    final directHaystack = [
      theme.title,
      theme.subtitle,
      theme.description,
      ...theme.quranAnchors.map(
        (anchor) =>
            '${anchor.surahName} ${anchor.surahNumber}:${anchor.verseRange} ${anchor.label}',
      ),
    ].join(' ').toLowerCase();
    if (directHaystack.contains(normalizedQuery)) {
      return true;
    }

    for (final entry in entries) {
      if (entry.themeId != theme.id) continue;
      final entryHaystack = [
        entry.title,
        entry.excerpt,
        entry.translation,
        entry.arabicMatn ?? '',
        entry.transliteratedText ?? '',
        entry.displaySourceCollection,
        entry.displaySourceReference ?? '',
        entry.sourceLabel,
        entry.narrator ?? '',
        entry.meaning,
        ...entry.tags,
        ...entry.lessons,
        ...entry.quranConnections.map(
          (connection) =>
              '${connection.surahName} ${connection.surahNumber}:${connection.verseRange} ${connection.label}',
        ),
      ].join(' ').toLowerCase();
      if (entryHaystack.contains(normalizedQuery)) {
        return true;
      }
    }

    return false;
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

    final rows = <Widget>[];
    var index = 0;
    while (index < themes.length) {
      final left = themes[index];
      final right = index + 1 < themes.length ? themes[index + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ThemeCard(theme: left, savedIds: savedIds),
            ),
            if (right != null) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _ThemeCard(theme: right, savedIds: savedIds),
              ),
            ],
            if (right == null) const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
      index += 2;
      if (index < themes.length) {
        rows.add(const SizedBox(height: 10));
      }
    }

    return rows;
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

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        'hadithThemeDetail',
        pathParameters: {'themeId': theme.id},
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(theme.icon, size: 20, color: AppColors.onSurface),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    theme.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(theme.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).hadithThemeCardCounts(
                entries.length,
                theme.quranAnchors.length,
              ),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 4),
            Text(
              savedInTheme > 0
                  ? AppLocalizations.of(
                      context,
                    ).hadithThemeCardProgress(savedInTheme, entries.length)
                  : AppLocalizations.of(context).hadithThemeCardStart,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
          ],
        ),
      ),
    );
  }
}
