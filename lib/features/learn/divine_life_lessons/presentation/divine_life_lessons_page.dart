// FREE ACCESS: no path-gating — all content accessible ✓
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/divine_life_lessons_provider.dart';
import '../data/divine_life_lessons_data.dart';
import '../domain/divine_life_models.dart';

enum DivineLifeTab { lessons, themes, situations, reflection }

enum DivineLessonSort { recommended, aToZ, shortestRead }

class DivineLifeLessonsPage extends ConsumerStatefulWidget {
  const DivineLifeLessonsPage({
    super.key,
    this.initialThemeId,
    this.initialSituationId,
    this.section,
    this.initialTab,
  });

  final String? initialThemeId;
  final String? initialSituationId;

  /// Null keeps the lesson list as the landing; the other three tabs are
  /// destinations reachable from the list under the header.
  final String? section;
  final DivineLifeTab? initialTab;

  @override
  ConsumerState<DivineLifeLessonsPage> createState() =>
      _DivineLifeLessonsPageState();
}

class _DivineLifeLessonsPageState extends ConsumerState<DivineLifeLessonsPage> {
  late final TextEditingController _searchController;
  DivineLifeTab _tab = DivineLifeTab.lessons;
  DivineLessonSort _lessonSort = DivineLessonSort.recommended;
  String? _selectedThemeId;
  String? _selectedSituationId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedThemeId = widget.initialThemeId;
    _selectedSituationId = widget.initialSituationId;
    final sectionTab = _sectionFor(widget.section);
    if (sectionTab != null) {
      _tab = sectionTab;
    } else if (widget.initialTab != null) {
      _tab = widget.initialTab!;
    } else if (widget.initialThemeId != null) {
      _tab = DivineLifeTab.themes;
    } else if (widget.initialSituationId != null) {
      _tab = DivineLifeTab.situations;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(divineLifeProgressProvider);
    final recent = ref.watch(divineLifeRecentLessonsProvider);
    final bookmarked = ref.watch(divineLifeBookmarkedLessonsProvider);
    final withNotes = ref.watch(divineLifeLessonsWithNotesProvider);
    final daily = ref.watch(divineLifeDailyLessonProvider);
    final journeys = ref.watch(divineLifeJourneyPathsProvider);

    final query = _searchController.text.trim().toLowerCase();

    final lessons = divineLifeLessons
        .where((lesson) {
          if (_selectedThemeId != null && lesson.themeId != _selectedThemeId) {
            return false;
          }
          if (_selectedSituationId != null &&
              !lesson.situationIds.contains(_selectedSituationId)) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack = [
            lesson.title,
            lesson.shortSummary,
            lesson.quranReference,
            lesson.surahName,
            lesson.translationText ?? '',
            lesson.reflection,
            lesson.practicalTakeaway,
            ...lesson.actionSteps,
            ...lesson.tags,
          ].join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);
    final sortedLessons = [...lessons];
    switch (_lessonSort) {
      case DivineLessonSort.recommended:
        sortedLessons.sort((a, b) {
          final priority = a.featuredPriority.compareTo(b.featuredPriority);
          if (priority != 0) return priority;
          return a.estimatedReadMinutes.compareTo(b.estimatedReadMinutes);
        });
      case DivineLessonSort.aToZ:
        sortedLessons.sort((a, b) => a.title.compareTo(b.title));
      case DivineLessonSort.shortestRead:
        sortedLessons.sort(
          (a, b) => a.estimatedReadMinutes.compareTo(b.estimatedReadMinutes),
        );
    }
    final featuredLessons = sortedLessons
        .where((lesson) => lesson.featuredPriority <= 8)
        .take(6)
        .toList(growable: false);
    final lessonGroups = divineLifeThemes
        .map((theme) {
          final groupLessons = sortedLessons
              .where((lesson) => lesson.themeId == theme.id)
              .toList(growable: false);
          return _ThemeLessonGroup(theme: theme, lessons: groupLessons);
        })
        .where((group) => group.lessons.isNotEmpty)
        .toList(growable: false);
    final filteredThemes = divineLifeThemes
        .where((theme) {
          if (_selectedThemeId != null && theme.id != _selectedThemeId) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack = [
            theme.title,
            theme.description,
          ].join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);
    final filteredSituations = divineLifeSituations
        .where((situation) {
          if (_selectedSituationId != null &&
              situation.id != _selectedSituationId) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack = [
            situation.title,
            situation.description,
          ].join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.lightbulb_rounded,
      title: l10n.learnCategoryDivineLifeLessonsTitle,
      subtitle: l10n.learnCategoryDivineLifeLessonsSubtitle,
      children: [
        if (widget.section == null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HubListGroup(
                  title: l10n.learnLandingBrowseTitle,
                  children: [
                    for (final tab in DivineLifeTab.values)
                      if (tab != DivineLifeTab.lessons)
                        CompactListTile(
                          title: _tabLabel(tab),
                          leading: HubLeadingIcon(_sectionIcon(tab)),
                          onTap: () => context.pushNamed(
                            'learnLifeLanding',
                            queryParameters: {'section': tab.name},
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.searchDivineLessonsHint,
            onChanged: (_) => setState(() {}),
            onClear: () {
              _searchController.clear();
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _ThemeCategoryScroller(
                themes: divineLifeThemes,
                selectedThemeId: _selectedThemeId,
                onSelected: (themeId) =>
                    setState(() => _selectedThemeId = themeId),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _filterChip(
                    label: _selectedSituationId == null
                        ? 'Situation: Any'
                        : 'Situation: ${divineLifeSituationById(_selectedSituationId!)?.title ?? _selectedSituationId}',
                    onTap: _showSituationPicker,
                  ),
                  if (_selectedThemeId != null ||
                      _selectedSituationId != null ||
                      query.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedThemeId = null;
                          _selectedSituationId = null;
                          _searchController.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Continue reflection',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (recent.isEmpty)
                const Text('Open a lesson to continue where you left off.')
              else
                ...recent
                    .take(3)
                    .map(
                      (lesson) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(lesson.title),
                        subtitle: Text(lesson.quranReference),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openLesson(context, lesson.id),
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statPill('Saved', '${bookmarked.length}'),
              _statPill('With notes', '${withNotes.length}'),
              _statPill('Recently viewed', '${recent.length}'),
              _statPill('Opened', '${progress.openedAtIsoByLessonId.length}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learning journeys',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: journeys.entries
                    .map((entry) {
                      return ActionChip(
                        label: Text(entry.key),
                        onPressed: () {
                          final firstLessonId = entry.value.isEmpty
                              ? null
                              : entry.value.first;
                          if (firstLessonId == null) return;
                          _openLesson(context, firstLessonId);
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_tab == DivineLifeTab.lessons)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort lessons',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                SegmentedPillControl<DivineLessonSort>(
                  items: DivineLessonSort.values,
                  selectedItem: _lessonSort,
                  labelBuilder: _sortLabel,
                  onChanged: (value) => setState(() => _lessonSort = value),
                ),
              ],
            ),
          ),
        if (_tab == DivineLifeTab.lessons) const SizedBox(height: 12),
        if (_tab == DivineLifeTab.lessons)
          _LessonsTab(
            lessons: sortedLessons,
            featuredLessons: featuredLessons,
            groups: lessonGroups,
            onOpenLesson: (id) => _openLesson(context, id),
            emptyTitle: l10n.learnHubSearchEmptyTitle,
            emptySubtitle: l10n.learnHubSearchEmptySubtitle,
          ),
        if (_tab == DivineLifeTab.themes)
          _ThemesTab(
            themes: filteredThemes,
            selectedThemeId: _selectedThemeId,
            onSelectTheme: (id) => setState(() => _selectedThemeId = id),
            onOpenLesson: (id) => _openLesson(context, id),
          ),
        if (_tab == DivineLifeTab.situations)
          _SituationsTab(
            situations: filteredSituations,
            selectedSituationId: _selectedSituationId,
            onSelectSituation: (id) =>
                setState(() => _selectedSituationId = id),
            onOpenLesson: (id) => _openLesson(context, id),
          ),
        if (_tab == DivineLifeTab.reflection)
          _ReflectionTab(
            daily: daily,
            onOpenLesson: (id) => _openLesson(context, id),
            onOpenMode: () => context.pushNamed('divineLifeReflection'),
          ),
      ],
    );
  }

  void _openLesson(BuildContext context, String lessonId) {
    context.pushNamed(
      'lifeLessonDetail',
      pathParameters: {'lessonId': lessonId},
    );
  }

  DivineLifeTab? _sectionFor(String? id) {
    for (final tab in DivineLifeTab.values) {
      if (tab.name == id) return tab;
    }
    return null;
  }

  IconData _sectionIcon(DivineLifeTab tab) {
    switch (tab) {
      case DivineLifeTab.lessons:
        return Icons.menu_book_rounded;
      case DivineLifeTab.themes:
        return Icons.category_rounded;
      case DivineLifeTab.situations:
        return Icons.emoji_people_rounded;
      case DivineLifeTab.reflection:
        return Icons.self_improvement_rounded;
    }
  }

  String _tabLabel(DivineLifeTab tab) {
    switch (tab) {
      case DivineLifeTab.lessons:
        return 'Lessons';
      case DivineLifeTab.themes:
        return 'Themes';
      case DivineLifeTab.situations:
        return 'Situations';
      case DivineLifeTab.reflection:
        return 'Reflection';
    }
  }

  String _sortLabel(DivineLessonSort sort) {
    switch (sort) {
      case DivineLessonSort.recommended:
        return 'Recommended';
      case DivineLessonSort.aToZ:
        return 'A-Z';
      case DivineLessonSort.shortestRead:
        return 'Shortest';
    }
  }

  Widget _filterChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFCEB07D)),
          color: const Color(0xFFFAF3E8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.5)),
      ),
    );
  }

  Widget _statPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFFAF3E8),
        border: Border.all(color: const Color(0xFFCEB07D)),
      ),
      child: Text('$label: $value'),
    );
  }

  void _showSituationPicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('Any situation'),
              onTap: () {
                setState(() => _selectedSituationId = null);
                Navigator.of(context).pop();
              },
            ),
            ...divineLifeSituations.map(
              (situation) => ListTile(
                title: Text(situation.title),
                onTap: () {
                  setState(() => _selectedSituationId = situation.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCategoryScroller extends StatelessWidget {
  const _ThemeCategoryScroller({
    required this.themes,
    required this.selectedThemeId,
    required this.onSelected,
  });

  final List<DivineLifeTheme> themes;
  final String? selectedThemeId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final allSelected = selectedThemeId == null;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryPill(
            label: 'All',
            selected: allSelected,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...themes.map(
            (theme) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _CategoryPill(
                label: theme.title,
                selected: selectedThemeId == theme.id,
                onTap: () => onSelected(theme.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: context.palette.accent,
    );
    final defaultStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      splashColor: defaultStyle.splashColor,
      highlightColor: defaultStyle.highlightColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? selectedStyle.iconBackgroundColor
              : defaultStyle.backgroundColor,
          gradient: selected ? selectedStyle.gradient : defaultStyle.gradient,
          border: Border.all(
            color: selected
                ? selectedStyle.borderColor
                : defaultStyle.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LessonsTab extends StatelessWidget {
  const _LessonsTab({
    required this.lessons,
    required this.featuredLessons,
    required this.groups,
    required this.onOpenLesson,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final List<DivineLifeLesson> lessons;
  final List<DivineLifeLesson> featuredLessons;
  final List<_ThemeLessonGroup> groups;
  final ValueChanged<String> onOpenLesson;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emptyTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(emptySubtitle),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (featuredLessons.isNotEmpty) ...[
          Text(
            'Featured Lessons',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...featuredLessons.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CompactListTile(
                title: lesson.title,
                subtitle:
                    '${lesson.quranReference} • ${lesson.estimatedReadMinutes} min',
                onTap: () => onOpenLesson(lesson.id),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.theme.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(group.theme.description),
                  const SizedBox(height: 8),
                  ...group.lessons
                      .take(4)
                      .map(
                        (lesson) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(lesson.title),
                          subtitle: Text(
                            '${lesson.quranReference} • ${lesson.estimatedReadMinutes} min',
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => onOpenLesson(lesson.id),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeLessonGroup {
  const _ThemeLessonGroup({required this.theme, required this.lessons});

  final DivineLifeTheme theme;
  final List<DivineLifeLesson> lessons;
}

class _ThemesTab extends StatelessWidget {
  const _ThemesTab({
    required this.themes,
    required this.selectedThemeId,
    required this.onSelectTheme,
    required this.onOpenLesson,
  });

  final List<DivineLifeTheme> themes;
  final String? selectedThemeId;
  final ValueChanged<String?> onSelectTheme;
  final ValueChanged<String> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final filtered = selectedThemeId == null
        ? themes
        : themes
              .where((theme) => theme.id == selectedThemeId)
              .toList(growable: false);

    return Column(
      children: filtered
          .map(
            (theme) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(theme.title),
                      subtitle: Text(
                        '${theme.description}\n${theme.lessonIds.length} lessons',
                      ),
                      trailing: selectedThemeId == theme.id
                          ? TextButton(
                              onPressed: () => onSelectTheme(null),
                              child: const Text('Clear'),
                            )
                          : TextButton(
                              onPressed: () => onSelectTheme(theme.id),
                              child: const Text('Focus'),
                            ),
                    ),
                    ...theme.lessonIds.take(3).map((id) {
                      final lesson = divineLifeLessonById(id);
                      if (lesson == null) return const SizedBox.shrink();
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(lesson.title),
                        subtitle: Text(lesson.quranReference),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => onOpenLesson(lesson.id),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SituationsTab extends StatelessWidget {
  const _SituationsTab({
    required this.situations,
    required this.selectedSituationId,
    required this.onSelectSituation,
    required this.onOpenLesson,
  });

  final List<DivineLifeSituation> situations;
  final String? selectedSituationId;
  final ValueChanged<String?> onSelectSituation;
  final ValueChanged<String> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final filtered = selectedSituationId == null
        ? situations
        : situations
              .where((situation) => situation.id == selectedSituationId)
              .toList(growable: false);

    return Column(
      children: filtered
          .map(
            (situation) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(situation.title),
                      subtitle: Text(
                        '${situation.description}\n${situation.lessonIds.length} lessons',
                      ),
                      trailing: selectedSituationId == situation.id
                          ? TextButton(
                              onPressed: () => onSelectSituation(null),
                              child: const Text('Clear'),
                            )
                          : TextButton(
                              onPressed: () => onSelectSituation(situation.id),
                              child: const Text('Focus'),
                            ),
                    ),
                    ...situation.lessonIds.take(3).map((id) {
                      final lesson = divineLifeLessonById(id);
                      if (lesson == null) return const SizedBox.shrink();
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(lesson.title),
                        subtitle: Text(lesson.quranReference),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => onOpenLesson(lesson.id),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ReflectionTab extends StatelessWidget {
  const _ReflectionTab({
    required this.daily,
    required this.onOpenLesson,
    required this.onOpenMode,
  });

  final DivineLifeLesson daily;
  final ValueChanged<String> onOpenLesson;
  final VoidCallback onOpenMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily reflection',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(daily.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              QuranReferenceBlock(
                surahNumber: daily.surahNumber,
                surahName: daily.surahName,
                ayahStart: daily.ayahStart,
                ayahEnd: daily.ayahEnd,
                dense: true,
              ),
              const SizedBox(height: 8),
              Text(daily.reflection),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => onOpenLesson(daily.id),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open full lesson'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onOpenMode,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Reflection mode'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
