import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/hadith_daily_reflection_service.dart';
import '../application/hadith_foundation_repository.dart';
import '../application/hadith_learning_paths_service.dart';
import '../application/hadith_path_quiz_service.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_learning_path.dart';

enum _HadithTab { themes, collections, saved, daily, review, paths }

class HadithLandingPage extends ConsumerStatefulWidget {
  const HadithLandingPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final themes = ref.watch(hadithThemesProvider);
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
                (theme) =>
                    theme.title.toLowerCase().contains(normalizedQuery) ||
                    theme.subtitle.toLowerCase().contains(normalizedQuery),
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
      title: 'Hadith',
      subtitle:
          'Teachings of the Prophet ﷺ organized by theme and connected to the Qur’an.',
      children: [
        SegmentedPillControl<_HadithTab>(
          items: _HadithTab.values,
          selectedItem: _selectedTab,
          labelBuilder: _tabLabel,
          onChanged: (tab) => setState(() => _selectedTab = tab),
        ),
        const SizedBox(height: 12),
        if (_selectedTab == _HadithTab.themes) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start with Essential Hadith',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Begin with a curated starter path focused on foundations of faith, worship, and character.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('learnHadithImportant'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start with Essential Hadith'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SearchCard(
            controller: _searchController,
            hintText: 'Search theme, lesson, or anchor...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 10),
          if (normalizedQuery.isNotEmpty) ...[
            Text(
              '${filteredThemes.length} matching themes',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            ..._buildThemeRows(filteredThemes, savedIds),
          ] else ...[
            if (featuredThemes.isNotEmpty) ...[
              Text(
                'Featured Themes',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._buildThemeRows(featuredThemes, savedIds),
              const SizedBox(height: 12),
            ],
            Text(
              'All Themes (${allThemes.length})',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ..._buildThemeRows(allThemes, savedIds),
          ],
        ],
        if (_selectedTab == _HadithTab.collections) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collections',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Curated hadith sets for focused reading and future phased expansion.',
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
                    '${collection.subtitle}\n${collection.hadithIds.length} hadith',
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
                  'Saved',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep important hadith close for repeated reading and reflection.',
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
                children: const [
                  Text(
                    'No saved hadith yet',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Save hadith from theme and detail pages to build your personal reflection set.',
                  ),
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
                  'Daily Hadith Reflection',
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
            const PremiumCard(
              child: Text('No daily hadith is available right now.'),
            )
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
                    'Grade: ${dailyBundle.entry!.grading}',
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
                    label: const Text('Open Hadith Detail'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _DailySection(
              title: 'Hadith Text',
              child: Text(dailyBundle.entry!.displayEnglishText),
            ),
            _DailySection(
              title: 'Meaning',
              child: Text(dailyBundle.entry!.meaning),
            ),
            _DailySection(
              title: 'Qur’an Connection',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dailyBundle.entry!.quranConnections
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _openQuranAnchor(
                            surahNumber: item.surahNumber,
                            verseRange: item.verseRange,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.surface.withValues(alpha: 0.24),
                              border: Border.all(
                                color: AppColors.accentGoldSoft.withValues(
                                  alpha: 0.32,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.surahName} ${item.surahNumber}:${item.verseRange} • ${item.label}',
                                  ),
                                ),
                                const Icon(Icons.open_in_new_rounded, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            _DailySection(
              title: 'Reflection Prompts',
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
              title: 'Practice Action',
              child: Text(dailyBundle.entry!.practiceAction),
            ),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current streak: ${dailyBundle.currentStreak} day${dailyBundle.currentStreak == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Best streak: ${dailyBundle.bestStreak} day${dailyBundle.bestStreak == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (dailyBundle.isCompletedToday)
                    FilledButton.tonalIcon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Completed Today'),
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
                            ? 'Reflection completed • +$xp XP'
                            : 'Already completed today';
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      },
                      icon: const Icon(Icons.task_alt_rounded),
                      label: const Text('Complete Reflection'),
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
                  'Review',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Revisit chapter quizzes and strengthen retention with spaced review.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Completed chapter quizzes: ${reviewState.completedQuizIds.length}',
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
                  label: const Text('Random Review'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'hadithReviewQuiz',
                    queryParameters: {'mode': 'weekly'},
                  ),
                  icon: const Icon(Icons.calendar_view_week_rounded),
                  label: const Text('Weekly Knowledge Check'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _openThemeReviewSelector(context, ref, themes),
                  icon: const Icon(Icons.palette_outlined),
                  label: const Text('Review by Theme'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _openPathReviewSelector(context, ref, learningPaths),
                  icon: const Icon(Icons.route_rounded),
                  label: const Text('Review by Learning Path'),
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
                  'Spaced Repetition',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  dueReviews.isEmpty
                      ? 'No lessons are due today. Complete more lessons to build your review queue.'
                      : '${dueReviews.length} lessons are due for review today.',
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
                  'Hadith Learning Paths',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Follow curated paths to study hadith in a structured sequence with steady progress.',
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
                          '$completed / $total lessons',
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
              'Path streak: ${pathProgress.currentStreakDays} day${pathProgress.currentStreakDays == 1 ? '' : 's'} • Best: ${pathProgress.bestStreakDays}',
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildThemeRows(List<HadithTheme> themes, Set<String> savedIds) {
    if (themes.isEmpty) {
      return [
        const PremiumCard(
          child: Text('No matching themes found. Try a broader search.'),
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

  String _tabLabel(_HadithTab tab) {
    switch (tab) {
      case _HadithTab.themes:
        return 'Themes';
      case _HadithTab.collections:
        return 'Collections';
      case _HadithTab.saved:
        return 'Saved';
      case _HadithTab.daily:
        return 'Daily';
      case _HadithTab.review:
        return 'Review';
      case _HadithTab.paths:
        return 'Paths';
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

  void _openQuranAnchor({
    required int surahNumber,
    required String verseRange,
  }) {
    final (startAyah, endAyah) = _parseAyahRange(verseRange);
    final queryParameters = <String, String>{};
    if (startAyah != null && startAyah > 0) {
      queryParameters['ayah'] = '$startAyah';
    }
    if (endAyah != null && endAyah > 0 && endAyah >= (startAyah ?? endAyah)) {
      queryParameters['endAyah'] = '$endAyah';
    }
    context.pushNamed(
      'quranReader',
      pathParameters: {'surahNumber': '$surahNumber'},
      queryParameters: queryParameters,
    );
  }

  (int?, int?) _parseAyahRange(String range) {
    final normalized = range.replaceAll('–', '-').replaceAll('—', '-').trim();
    if (normalized.isEmpty) return (null, null);
    final firstChunk = normalized.split(',').first.trim();
    if (firstChunk.isEmpty) return (null, null);
    if (firstChunk.contains(':')) {
      final ayahPart = firstChunk.split(':').last.trim();
      return _parseAyahRange(ayahPart);
    }
    if (!firstChunk.contains('-')) {
      final single = int.tryParse(firstChunk);
      return (single, single);
    }
    final parts = firstChunk.split('-');
    final start = int.tryParse(parts.first.trim());
    final end = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;
    return (start, end ?? start);
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
              '${entries.length} hadith • ${theme.quranAnchors.length} anchors',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 4),
            Text(
              savedInTheme > 0
                  ? 'Progress: $savedInTheme / ${entries.length}'
                  : 'Start theme',
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

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.glassSurfaceAlpha),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentGold.withValues(
            alpha: AppColors.glassBorderAlpha,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 32,
                color: AppColors.onSurface.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    isCollapsed: true,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: AppColors.onSurface.withValues(alpha: 0.55),
          ),
        ],
      ),
    );
  }
}
