import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/major_page_shortcuts.dart';
import '../../../shared/widgets/premium_card.dart';
import 'data/learn_category_catalog.dart';
import 'models/learn_category_item.dart';
import '../shared/application/learn_system_engine_provider.dart';
import '../shared/domain/learn_system_models.dart';
import 'widgets/learn_category_grid.dart';
import 'widgets/learn_discovery_search_field.dart';
import 'widgets/learn_hub_page_scaffold.dart';
import 'widgets/learn_section_header.dart';

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
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final summary = ref.watch(learnUnifiedSummaryV2Provider);
    final themes = ref.watch(learnSharedThemesProvider);
    final paths = ref.watch(learnUnifiedPathsProvider);
    final savedItems = ref.watch(learnUnifiedSavedItemsProvider);
    final relations = ref.watch(learnUnifiedRelationshipsProvider);
    final searchFilters = ref.watch(learnUnifiedSearchProvider);
    final searchResults = ref.watch(learnUnifiedSearchResultsProvider);
    final catalogItems = LearnCategoryCatalog.activeItems;
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
      ownsBackground: false,
      headerIcon: Icons.school_rounded,
      title: l10n.learnHubTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.learnHub,
        kidsMode: isKidsMode,
      ),
      shortcutActions: buildMajorPageShortcutActions(
        context,
        ref,
        MajorPageShortcutFamily.learn,
      ),
      children: [
        const LearningHubRabbiZidniIlmaHeader(),
        _buildDailyLearning(summary, l10n),
        const SizedBox(height: 12),
        _buildSearchFilters(
          context,
          l10n: l10n,
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
          _buildSearchResults(
            context,
            l10n: l10n,
            results: searchResults,
            numberFormat: numberFormat,
          ),
          const SizedBox(height: 12),
        ],
        _sectionTitle(
          context,
          l10n.learnHubExploreCategoriesTitle,
          l10n.learnHubExploreCategoriesSubtitle,
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
          l10n.learnHubExploreByThemeTitle,
          l10n.learnHubExploreByThemeSubtitle,
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
          l10n.learnHubGuidedPathsTitle,
          l10n.learnHubGuidedPathsSubtitle,
        ),
        const SizedBox(height: 8),
        ...paths.map((path) => _pathCard(context, l10n, numberFormat, path)),
        const SizedBox(height: 12),
        _sectionTitle(
          context,
          l10n.learnHubSavedAndNotesTitle,
          l10n.learnHubSavedAndNotesSubtitle,
        ),
        const SizedBox(height: 8),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnHubSavedNotesSummary(
                  numberFormat.format(summary.savedCount),
                  numberFormat.format(summary.noteCount),
                  numberFormat.format(summary.savedCount + summary.noteCount),
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (savedItems.isEmpty)
                Text(l10n.learnHubNoSavedItems)
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
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
          l10n.learningJourneyBrowseKnowledgeConstellationTitle,
          l10n.learnHubKnowledgeConstellationSubtitle,
        ),
        const SizedBox(height: 8),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnHubIndexedRelationshipsCount(
                  numberFormat.format(relations.length),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('knowledgeConstellation'),
                icon: const Icon(Icons.hub_outlined),
                label: Text(l10n.learnHubOpenKnowledgeConstellation),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyLearning(
    LearnUnifiedSummaryV2 summary,
    AppLocalizations l10n,
  ) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubDailyLearningTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.learnHubDailyThemeLabel(summary.dailyItem.theme.label),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 6),
          Text(
            summary.dailyItem.item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
                label: Text(l10n.learnHubOpenDailyLearningAction),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('journalCreate'),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l10n.learnHubWriteReflectionAction),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilters(
    BuildContext context, {
    required AppLocalizations l10n,
    required LearnSearchFilterState searchFilters,
    required List<LearnSharedTheme> themes,
    required List<LearnUnifiedPath> paths,
  }) {
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: surfaceStyle.decoration(radius: 16),
      child: Column(
        children: [
          LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.learnDiscoverySearchLessonsHint,
            onChanged: (value) =>
                ref.read(learnUnifiedSearchProvider.notifier).setQuery(value),
            onClear: () =>
                ref.read(learnUnifiedSearchProvider.notifier).clear(),
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
                  tooltip: l10n.learnHubFilterTypeTooltip,
                  label: searchFilters.type == null
                      ? l10n.learnHubTypeAnyLabel
                      : l10n.learnHubTypeValueLabel(
                          _itemTypeLabel(l10n, searchFilters.type!),
                          _itemTypeLabel(l10n, searchFilters.type!),
                        ),
                  items: [
                    PopupMenuItem(
                      value: null,
                      child: Text(l10n.learnHubAnyTypeOption),
                    ),
                    ...LearnItemType.values.map(
                      (value) => PopupMenuItem(
                        value: value,
                        child: Text(_itemTypeLabel(l10n, value)),
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
                  tooltip: l10n.learnHubFilterThemeTooltip,
                  label: searchFilters.themeId == null
                      ? l10n.learnHubThemeAnyLabel
                      : l10n.learnHubThemeValueLabel(
                          _themeLabel(themes, searchFilters.themeId!),
                          _themeLabel(themes, searchFilters.themeId!),
                        ),
                  items: [
                    PopupMenuItem(
                      value: null,
                      child: Text(l10n.learnHubAnyThemeOption),
                    ),
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
                  tooltip: l10n.learnHubFilterDifficultyTooltip,
                  label: searchFilters.difficulty == null
                      ? l10n.learnHubDifficultyAnyLabel
                      : l10n.learnHubDifficultyValueLabel(
                          _difficultyLabel(l10n, searchFilters.difficulty!),
                          _difficultyLabel(l10n, searchFilters.difficulty!),
                        ),
                  items: [
                    PopupMenuItem(
                      value: null,
                      child: Text(l10n.learnHubAnyDifficultyOption),
                    ),
                    ...LearnDifficulty.values.map(
                      (difficulty) => PopupMenuItem(
                        value: difficulty,
                        child: Text(_difficultyLabel(l10n, difficulty)),
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
                  tooltip: l10n.learnHubFilterPathTooltip,
                  label: searchFilters.pathId == null
                      ? l10n.learnHubPathAnyLabel
                      : l10n.learnHubPathActiveLabel,
                  items: [
                    PopupMenuItem(
                      value: null,
                      child: Text(l10n.learnHubAnyPathOption),
                    ),
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
                  label: Text(l10n.learnHubSavedOnlyFilter),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context, {
    required AppLocalizations l10n,
    required List<LearnUnifiedContentItem> results,
    required NumberFormat numberFormat,
  }) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHubResultsCount(numberFormat.format(results.length)),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (results.isEmpty)
            Text(l10n.learnHubNoMatchingItems)
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
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item.subtitle,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryGroups
            .map((group) {
              final selected = _selectedCategoryGroup == group;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categoryGroupLabel(l10n, group)),
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

  Widget _pathCard(
    BuildContext context,
    AppLocalizations l10n,
    NumberFormat numberFormat,
    LearnUnifiedPath path,
  ) {
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  path.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.learnHubPathProgress(
                    numberFormat.format(completed),
                    numberFormat.format(path.steps.length),
                    numberFormat.format(completed),
                    numberFormat.format(path.steps.length),
                  ),
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
    return LearnSectionHeader(title: title, subtitle: subtitle);
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
    String? tooltip,
  }) {
    return PopupMenuButton<T>(
      tooltip: tooltip,
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

  String _itemTypeLabel(AppLocalizations l10n, LearnItemType value) {
    switch (value) {
      case LearnItemType.verse:
        return l10n.learnHubItemTypeVerse;
      case LearnItemType.hadith:
        return l10n.learnHubItemTypeHadith;
      case LearnItemType.prophet:
        return l10n.learnHubItemTypeProphet;
      case LearnItemType.lifeLesson:
        return l10n.learnHubItemTypeLifeLesson;
      case LearnItemType.salahPrayer:
        return l10n.learnHubItemTypeSalahPrayer;
      case LearnItemType.surah:
        return l10n.learnHubItemTypeSurah;
      case LearnItemType.recitation:
        return l10n.learnHubItemTypeRecitation;
      case LearnItemType.name:
        return l10n.learnHubItemTypeNameOfAllah;
      case LearnItemType.babyName:
        return l10n.learnHubItemTypeBabyName;
      case LearnItemType.quiz:
        return l10n.learnHubItemTypeQuiz;
      case LearnItemType.note:
        return l10n.learnHubItemTypeNote;
      case LearnItemType.reflection:
        return l10n.learnHubItemTypeReflection;
      case LearnItemType.pathStep:
        return l10n.learnHubItemTypePathStep;
    }
  }

  String _themeLabel(List<LearnSharedTheme> themes, String id) {
    for (final theme in themes) {
      if (theme.id == id) return theme.label;
    }
    return id;
  }

  String _difficultyLabel(AppLocalizations l10n, LearnDifficulty value) {
    switch (value) {
      case LearnDifficulty.beginner:
        return l10n.learnTrackBeginner;
      case LearnDifficulty.intermediate:
        return l10n.learnHubDifficultyIntermediate;
      case LearnDifficulty.advanced:
        return l10n.learnHubDifficultyAdvanced;
    }
  }

  String _categoryGroupLabel(AppLocalizations l10n, String categoryGroup) {
    switch (categoryGroup) {
      case _allCategoryGroups:
        return l10n.learnHubCategoryGroupAll;
      case 'core':
        return l10n.learnHubCategoryGroupCore;
      case 'worship':
        return l10n.learnHubCategoryGroupWorship;
      case 'family_utility':
        return l10n.learnHubCategoryGroupFamilyUtility;
      case 'new_muslim':
        return l10n.learnHubCategoryGroupNewMuslim;
      case 'pilgrimage':
        return l10n.learnHubCategoryGroupPilgrimage;
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
