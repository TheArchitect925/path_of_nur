import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/premium_card.dart';
import 'data/learn_category_catalog.dart';
import 'models/learn_category_item.dart';
import '../shared/application/learn_system_engine_provider.dart';
import '../shared/domain/learn_system_models.dart';
import 'widgets/learn_category_grid.dart';
import 'widgets/learn_hub_page_scaffold.dart';

class LearnPage extends ConsumerStatefulWidget {
  const LearnPage({super.key});

  @override
  ConsumerState<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends ConsumerState<LearnPage> {
  static const String _allCategoryGroups = 'all';
  static const List<String> _categoryGroupOrder = [
    'core',
    'worship',
    'family_utility',
    'new_muslim',
    'pilgrimage',
  ];

  late final TextEditingController _searchController;
  String _selectedCategoryGroup = _allCategoryGroups;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(learnUnifiedSummaryV2Provider);
    final themes = ref.watch(learnSharedThemesProvider);
    final paths = ref.watch(learnUnifiedPathsProvider);
    final savedItems = ref.watch(learnUnifiedSavedItemsProvider);
    final relations = ref.watch(learnUnifiedRelationshipsProvider);
    final searchFilters = ref.watch(learnUnifiedSearchProvider);
    final searchResults = ref.watch(learnUnifiedSearchResultsProvider);
    final catalogItems = LearnCategoryCatalog.items;
    final categoryGroups = _buildCategoryGroups(catalogItems);
    final visibleCatalogItems = _selectedCategoryGroup == _allCategoryGroups
        ? catalogItems
        : catalogItems
              .where((item) => item.categoryGroup == _selectedCategoryGroup)
              .toList(growable: false);

    if (_searchController.text != searchFilters.query) {
      _searchController.value = TextEditingValue(
        text: searchFilters.query,
        selection: TextSelection.collapsed(offset: searchFilters.query.length),
      );
    }

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.quran,
      title: 'Learning Hub',
      subtitle:
          'One unified learning experience across Qur’an, Hadith, Prophets, lessons, names, quizzes, and notes.',
      children: [
        _buildContinueAndDaily(summary),
        const SizedBox(height: 12),
        _buildSearchFilters(
          context,
          searchFilters: searchFilters,
          themes: themes,
          paths: paths,
        ),
        if (searchFilters.query.trim().isNotEmpty ||
            searchFilters.savedOnly ||
            searchFilters.type != null ||
            searchFilters.themeId != null ||
            searchFilters.difficulty != null ||
            searchFilters.pathId != null) ...[
          const SizedBox(height: 10),
          _buildSearchResults(context, searchResults),
          const SizedBox(height: 12),
        ],
        _sectionTitle(
          context,
          'Explore Categories',
          'Browse all Learn categories and filter by section.',
        ),
        const SizedBox(height: 8),
        _buildCategoryGroupScrollBar(context, categoryGroups),
        const SizedBox(height: 8),
        LearnCategoryGrid(
          items: visibleCatalogItems,
          onTap: (item) {
            context.pushNamed(
              item.routeName,
              pathParameters: item.pathParameters,
              queryParameters: item.queryParameters,
            );
          },
        ),
        const SizedBox(height: 12),
        _sectionTitle(
          context,
          'Explore by Theme',
          'Use a shared taxonomy across all learning domains.',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: themes
              .map(
                (theme) => ActionChip(
                  label: Text(theme.label),
                  onPressed: () {
                    ref
                        .read(learnUnifiedSearchProvider.notifier)
                        .setTheme(theme.id);
                  },
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 12),
        _sectionTitle(
          context,
          'Guided Paths',
          'Mixed-content paths powered by one path engine.',
        ),
        const SizedBox(height: 8),
        ...paths.map((path) => _pathCard(context, path)),
        const SizedBox(height: 12),
        _sectionTitle(
          context,
          'Saved & Notes',
          'Unified saved and note view across Learn domains.',
        ),
        const SizedBox(height: 8),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved items: ${summary.savedCount} • Notes: ${summary.noteCount}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (savedItems.isEmpty)
                const Text(
                  'No saved items yet. Save any lesson, verse, hadith, or prophet to keep it here.',
                )
              else
                ...savedItems.take(5).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () => _openItem(context, item),
                      child: Row(
                        children: [
                          const Icon(Icons.bookmark_rounded, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item.title)),
                          const Icon(Icons.chevron_right_rounded, size: 16),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _sectionTitle(
          context,
          'Knowledge Constellation',
          'Explore the shared relationship graph across domains.',
        ),
        const SizedBox(height: 8),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${relations.length} indexed relationships',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('knowledgeConstellation'),
                icon: const Icon(Icons.hub_outlined),
                label: const Text('Open Knowledge Constellation'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueAndDaily(LearnUnifiedSummaryV2 summary) {
    return Column(
      children: [
        if (summary.continueItem != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Continue where you left of',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(summary.continueItem!.title),
                const SizedBox(height: 2),
                Text(
                  summary.continueItem!.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => _openItem(context, summary.continueItem!),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Resume'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Learning',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Theme: ${summary.dailyItem.theme.label}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 6),
              Text(summary.dailyItem.item.title),
              const SizedBox(height: 2),
              Text(
                summary.dailyItem.item.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _openItem(context, summary.dailyItem.item),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Open Daily Reflection'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('journalCreate'),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('Write Reflection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFilters(
    BuildContext context, {
    required LearnSearchFilterState searchFilters,
    required List<LearnSharedTheme> themes,
    required List<LearnUnifiedPath> paths,
  }) {
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
                size: 34,
                color: AppColors.onSurface.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setQuery(value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        'Search across Qur’an, Hadith, Prophets, lessons, names...',
                    isCollapsed: true,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (searchFilters.query.isNotEmpty)
                IconButton(
                  onPressed: () =>
                      ref.read(learnUnifiedSearchProvider.notifier).clear(),
                  icon: const Icon(Icons.close_rounded),
                ),
            ],
          ),
          Container(
            height: 1,
            color: AppColors.onSurface.withValues(alpha: 0.55),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterMenuChip<LearnItemType?>(
                  context,
                  label: searchFilters.type == null
                      ? 'Type: Any'
                      : 'Type: ${_itemTypeLabel(searchFilters.type!)}',
                  items: [
                    const PopupMenuItem(value: null, child: Text('Any type')),
                    ...LearnItemType.values.map(
                      (value) => PopupMenuItem(
                        value: value,
                        child: Text(_itemTypeLabel(value)),
                      ),
                    ),
                  ],
                  onSelected: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setType(value),
                ),
                const SizedBox(width: 8),
                _filterMenuChip<String?>(
                  context,
                  label: searchFilters.themeId == null
                      ? 'Theme: Any'
                      : 'Theme: ${_themeLabel(themes, searchFilters.themeId!)}',
                  items: [
                    const PopupMenuItem(value: null, child: Text('Any theme')),
                    ...themes.map(
                      (theme) => PopupMenuItem(
                        value: theme.id,
                        child: Text(theme.label),
                      ),
                    ),
                  ],
                  onSelected: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setTheme(value),
                ),
                const SizedBox(width: 8),
                _filterMenuChip<LearnDifficulty?>(
                  context,
                  label: searchFilters.difficulty == null
                      ? 'Difficulty: Any'
                      : 'Difficulty: ${_difficultyLabel(searchFilters.difficulty!)}',
                  items: [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Any difficulty'),
                    ),
                    ...LearnDifficulty.values.map(
                      (difficulty) => PopupMenuItem(
                        value: difficulty,
                        child: Text(_difficultyLabel(difficulty)),
                      ),
                    ),
                  ],
                  onSelected: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setDifficulty(value),
                ),
                const SizedBox(width: 8),
                _filterMenuChip<String?>(
                  context,
                  label: searchFilters.pathId == null
                      ? 'Path: Any'
                      : 'Path: Active',
                  items: [
                    const PopupMenuItem(value: null, child: Text('Any path')),
                    ...paths.map(
                      (path) => PopupMenuItem(
                        value: path.id,
                        child: Text(path.title),
                      ),
                    ),
                  ],
                  onSelected: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setPathId(value),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  selected: searchFilters.savedOnly,
                  onSelected: (value) => ref
                      .read(learnUnifiedSearchProvider.notifier)
                      .setSavedOnly(value),
                  label: const Text('Saved only'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    List<LearnUnifiedContentItem> results,
  ) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${results.length} results',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Text('No matching items. Try broader filters.')
          else
            ...results
                .take(8)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _openItem(context, item),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title),
                                Text(
                                  item.subtitle,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  List<String> _buildCategoryGroups(List<LearnCategoryItem> items) {
    final foundGroups = <String>{for (final item in items) item.categoryGroup};
    final orderedGroups = [
      _allCategoryGroups,
      ..._categoryGroupOrder.where(foundGroups.contains),
      ...foundGroups.where((group) => !_categoryGroupOrder.contains(group)),
    ];
    return orderedGroups;
  }

  Widget _buildCategoryGroupScrollBar(
    BuildContext context,
    List<String> categoryGroups,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryGroups
            .map((group) {
              final selected = _selectedCategoryGroup == group;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categoryGroupLabel(group)),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedCategoryGroup = group),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }

  Widget _pathCard(BuildContext context, LearnUnifiedPath path) {
    final progress = ref.watch(learnUnifiedProgressProvider);
    final completed = path.steps
        .where((step) => progress.completedIds.contains(step.itemId))
        .length;
    final ratio = path.steps.isEmpty
        ? 0.0
        : (completed / path.steps.length).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ref.read(learnUnifiedSearchProvider.notifier).setPathId(path.id);
            if (path.steps.isNotEmpty) {
              final first = path.steps.first;
              final item = ref.read(learnUnifiedItemByIdProvider(first.itemId));
              if (item != null) {
                _openItem(context, item);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(path.summary),
                const SizedBox(height: 8),
                Text(
                  '$completed / ${path.steps.length} completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 7,
                    value: ratio,
                    backgroundColor: AppColors.surface.withValues(alpha: 0.4),
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
  }

  Widget _sectionTitle(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
      ],
    );
  }

  void _openItem(BuildContext context, LearnUnifiedContentItem item) {
    ref.read(learnUnifiedProgressProvider.notifier).markStarted(item.id);
    final routeName = item.routeName;
    if (routeName == null || routeName.isEmpty) return;
    context.pushNamed(
      routeName,
      pathParameters: item.pathParameters,
      queryParameters: item.queryParameters,
    );
  }

  Widget _filterMenuChip<T>(
    BuildContext context, {
    required String label,
    required List<PopupMenuEntry<T>> items,
    required ValueChanged<T> onSelected,
  }) {
    return PopupMenuButton<T>(
      itemBuilder: (_) => items,
      onSelected: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.35),
          ),
          color: AppColors.surface.withValues(alpha: 0.25),
        ),
        child: Row(
          children: [
            Text(label),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }

  String _itemTypeLabel(LearnItemType value) {
    switch (value) {
      case LearnItemType.verse:
        return 'Verse';
      case LearnItemType.hadith:
        return 'Hadith';
      case LearnItemType.prophet:
        return 'Prophet';
      case LearnItemType.lifeLesson:
        return 'Life Lesson';
      case LearnItemType.name:
        return 'Name of Allah';
      case LearnItemType.babyName:
        return 'Baby Name';
      case LearnItemType.quiz:
        return 'Quiz';
      case LearnItemType.note:
        return 'Note';
      case LearnItemType.reflection:
        return 'Reflection';
      case LearnItemType.pathStep:
        return 'Path Step';
    }
  }

  String _themeLabel(List<LearnSharedTheme> themes, String id) {
    for (final theme in themes) {
      if (theme.id == id) return theme.label;
    }
    return id;
  }

  String _difficultyLabel(LearnDifficulty value) {
    switch (value) {
      case LearnDifficulty.beginner:
        return 'Beginner';
      case LearnDifficulty.intermediate:
        return 'Intermediate';
      case LearnDifficulty.advanced:
        return 'Advanced';
    }
  }

  String _categoryGroupLabel(String categoryGroup) {
    switch (categoryGroup) {
      case _allCategoryGroups:
        return 'All';
      case 'core':
        return 'Core';
      case 'worship':
        return 'Worship';
      case 'family_utility':
        return 'Family & Utility';
      case 'new_muslim':
        return 'New Muslim';
      case 'pilgrimage':
        return 'Pilgrimage';
      default:
        return categoryGroup
            .replaceAll('_', ' ')
            .split(' ')
            .where((word) => word.isNotEmpty)
            .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
            .join(' ');
    }
  }
}
