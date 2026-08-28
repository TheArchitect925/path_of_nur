import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/filter_chip_row.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/dua_progress_provider.dart';
import '../application/dua_repository.dart';
import '../domain/dua_models.dart';
import 'dua_category_theme.dart';

enum DuaHubTab { duas, categories, saved, daily }

class DuaHubPage extends ConsumerStatefulWidget {
  const DuaHubPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  ConsumerState<DuaHubPage> createState() => _DuaHubPageState();
}

class _DuaHubPageState extends ConsumerState<DuaHubPage> {
  late final TextEditingController _searchController;
  String _query = '';
  DuaHubTab _tab = DuaHubTab.duas;
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  String? _selectedSituation;

  /// Canonical presentation order for the emotion/situation index; the row
  /// only shows situations that actually occur in the dataset.
  static const List<String> _situationOrder = [
    'anxiety',
    'sadness',
    'anger',
    'hardship',
    'illness',
    'gratitude',
    'forgiveness',
    'protection',
    'guidance',
    'good_news',
    'sneezing',
    'social_interactions',
  ];

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void didUpdateWidget(covariant DuaHubPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery == widget.initialQuery) return;
    _query = widget.initialQuery;
    _searchController.value = TextEditingValue(
      text: widget.initialQuery,
      selection: TextSelection.collapsed(offset: widget.initialQuery.length),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final datasetAsync = ref.watch(duaDatasetProvider);
    final categoriesAsync = ref.watch(duaCategorySummariesProvider);
    final userState = ref.watch(duaLearningProvider);
    final savedIds = userState.savedIds;
    return LearnHubPageScaffold(
      headerIcon: Icons.pan_tool_alt_rounded,
      title: l10n.duaHubTitle,
      subtitle: l10n.duaHubSubtitle,
      children: [
        PremiumCard(
          child: SegmentedPillControl<DuaHubTab>(
            items: DuaHubTab.values,
            selectedItem: _tab,
            labelBuilder: (tab) => _tabLabel(l10n, tab),
            onChanged: (tab) => setState(() => _tab = tab),
          ),
        ),
        const SizedBox(height: 10),
        _searchCard(context, l10n),
        const SizedBox(height: 10),
        datasetAsync.when(
          data: (dataset) {
            final verified = _filteredVerifiedItems(dataset);
            final selectedCategorySummary = _selectedCategorySummary(
              categoriesAsync.valueOrNull,
            );
            final daily = _dailyItem(dataset);
            final saved = verified
                .where((item) => savedIds.contains(item.id))
                .toList(growable: false);
            return Column(
              children: [
                categoriesAsync.when(
                  data: (categories) =>
                      _categoryScroller(context, l10n, categories),
                  loading: () => const SizedBox.shrink(),
                  error: (_, stackTrace) => const SizedBox.shrink(),
                ),
                if (selectedCategorySummary != null &&
                    selectedCategorySummary.subcategories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _subcategoryScroller(context, selectedCategorySummary),
                ],
                if (_tab == DuaHubTab.duas) ...[
                  const SizedBox(height: 12),
                  _situationRow(context, l10n, dataset),
                ],
                const SizedBox(height: 12),
                if (_tab == DuaHubTab.duas) ...[
                  if (verified.isEmpty)
                    _emptyCard(l10n.duaHubEmptyFiltered)
                  else
                    ...verified.map(
                      (item) => _duaTile(
                        context,
                        item,
                        saved: savedIds.contains(item.id),
                      ),
                    ),
                ] else if (_tab == DuaHubTab.categories) ...[
                  categoriesAsync.when(
                    data: (categories) {
                      final filteredCategories = _filteredCategorySummaries(
                        categories,
                      );
                      if (filteredCategories.isEmpty) {
                        return _emptyCard(l10n.duaHubEmptyCategories);
                      }
                      return Column(
                        children: filteredCategories
                            .map((summary) => _categoryCard(context, summary))
                            .toList(growable: false),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => _errorCard(error),
                  ),
                ] else if (_tab == DuaHubTab.saved) ...[
                  if (saved.isEmpty)
                    _emptyCard(l10n.duaHubEmptySaved)
                  else
                    ...saved.map(
                      (item) => _duaTile(
                        context,
                        item,
                        saved: savedIds.contains(item.id),
                      ),
                    ),
                ] else ...[
                  if (daily == null)
                    _emptyCard(l10n.duaHubEmptyDaily)
                  else
                    _dailyCard(context, daily),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _errorCard(error),
        ),
      ],
    );
  }

  Widget _searchCard(BuildContext context, AppLocalizations l10n) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: LearnDiscoverySearchField(
        controller: _searchController,
        hintText: l10n.searchDuasHint,
        onClear: _searchController.clear,
      ),
    );
  }

  Widget _categoryScroller(
    BuildContext context,
    AppLocalizations l10n,
    List<DuaCategorySummary> categories,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _duaFilterChip(
              label: l10n.duaHubAllCategories,
              selected: _selectedCategoryId == null,
              onTap: () => setState(() {
                _selectedCategoryId = null;
                _selectedSubcategoryId = null;
              }),
            ),
          ),
          ...categories.map(
            (summary) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _duaFilterChip(
                label: summary.label,
                selected: _selectedCategoryId == summary.id,
                onTap: () => setState(() {
                  final selected = _selectedCategoryId != summary.id;
                  _selectedCategoryId = selected ? summary.id : null;
                  _selectedSubcategoryId = null;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subcategoryScroller(
    BuildContext context,
    DuaCategorySummary summary,
  ) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: summary.subcategories
            .map(
              (subcategory) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _duaFilterChip(
                  label: l10n.duaHubCategoryTag(
                    subcategory.label,
                    subcategory.completeCount,
                  ),
                  selected: _selectedSubcategoryId == subcategory.id,
                  onTap: () => setState(() {
                    final selected = _selectedSubcategoryId != subcategory.id;
                    _selectedSubcategoryId = selected ? subcategory.id : null;
                  }),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  List<DuaItem> _filteredVerifiedItems(DuaDataset dataset) {
    final query = _normalizedQuery;
    final items =
        dataset.verifiedItems
            .where((item) {
              if (_selectedCategoryId != null &&
                  !item.matchesCategoryId(_selectedCategoryId!)) {
                return false;
              }
              if (_selectedSubcategoryId != null &&
                  item.subcategory != _selectedSubcategoryId) {
                return false;
              }
              if (_selectedSituation != null &&
                  !item.situationContexts.contains(_selectedSituation)) {
                return false;
              }
              return item.matchesQuery(
                query,
                categoryLabel: dataset.categoryLabel(item.category),
                primaryCategoryLabel: dataset.primaryCategoryLabel(
                  item.effectivePrimaryCategory,
                ),
                secondaryCategoryLabels: item.secondaryCategories.map(
                  dataset.primaryCategoryLabel,
                ),
              );
            })
            .toList(growable: false)
          ..sort((a, b) {
            if (a.isCore != b.isCore) return a.isCore ? -1 : 1;
            return a.title.compareTo(b.title);
          });
    return items;
  }

  List<DuaCategorySummary> _filteredCategorySummaries(
    List<DuaCategorySummary> categories,
  ) {
    final query = _normalizedQuery;
    return categories
        .where((summary) {
          if (_selectedCategoryId != null &&
              summary.id != _selectedCategoryId) {
            return false;
          }
          if (query.isEmpty) return true;
          if (summary.matchesQuery(query)) return true;
          return summary.subcategories.any(
            (subcategory) => subcategory.matchesQuery(query),
          );
        })
        .toList(growable: false);
  }

  DuaItem? _dailyItem(DuaDataset dataset) {
    final items = dataset.verifiedItems;
    if (items.isEmpty) return null;
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final index = Random(seed).nextInt(items.length);
    return items[index];
  }

  Widget _situationRow(
    BuildContext context,
    AppLocalizations l10n,
    DuaDataset dataset,
  ) {
    final present = <String>{};
    for (final item in dataset.verifiedItems) {
      present.addAll(item.situationContexts);
    }
    final situations = _situationOrder
        .where(present.contains)
        .toList(growable: false);
    if (situations.isEmpty) return const SizedBox.shrink();
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l10n.duaHubFeelingLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: appearance?.backgroundForegroundSubtle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FilterChipRow<String>(
          items: [
            for (final situation in situations)
              FilterChipItem(
                value: situation,
                label: _situationLabel(l10n, situation),
                icon: _situationIcon(situation),
              ),
          ],
          selected: _selectedSituation,
          onSelected: (value) => setState(() => _selectedSituation = value),
        ),
      ],
    );
  }

  String _situationLabel(AppLocalizations l10n, String situation) {
    switch (situation) {
      case 'forgiveness':
        return l10n.duaSituationForgiveness;
      case 'gratitude':
        return l10n.duaSituationGratitude;
      case 'anxiety':
        return l10n.duaSituationAnxiety;
      case 'sadness':
        return l10n.duaSituationSadness;
      case 'anger':
        return l10n.duaSituationAnger;
      case 'hardship':
        return l10n.duaSituationHardship;
      case 'illness':
        return l10n.duaSituationIllness;
      case 'good_news':
        return l10n.duaSituationGoodNews;
      case 'sneezing':
        return l10n.duaSituationSneezing;
      case 'protection':
        return l10n.duaSituationProtection;
      case 'guidance':
        return l10n.duaSituationGuidance;
      case 'social_interactions':
        return l10n.duaSituationSocial;
    }
    return situation
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  IconData _situationIcon(String situation) {
    switch (situation) {
      case 'forgiveness':
        return Icons.volunteer_activism_outlined;
      case 'gratitude':
        return Icons.favorite_outline_rounded;
      case 'anxiety':
        return Icons.psychology_outlined;
      case 'sadness':
        return Icons.water_drop_outlined;
      case 'anger':
        return Icons.whatshot_outlined;
      case 'hardship':
        return Icons.terrain_outlined;
      case 'illness':
        return Icons.healing_outlined;
      case 'good_news':
        return Icons.celebration_outlined;
      case 'sneezing':
        return Icons.air_rounded;
      case 'protection':
        return Icons.shield_outlined;
      case 'guidance':
        return Icons.explore_outlined;
      case 'social_interactions':
        return Icons.groups_outlined;
    }
    return Icons.label_outline_rounded;
  }

  Widget _duaTile(BuildContext context, DuaItem item, {required bool saved}) {
    final colors = DuaCategoryTheme.resolve(context, item.category);
    final l10n = AppLocalizations.of(context);
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: colors.accent,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        label: l10n.duaHubOpenDuaSemantics(item.title),
        child: CompactListTile(
          title: item.title,
          subtitle: item.whenToSay,
          leading: Container(
            width: 40,
            height: 40,
            decoration: iconStyle.decoration(radius: 13, includeShadow: false),
            child: Icon(colors.icon, size: 20, color: colors.accent),
          ),
          trailing: IconButton(
            tooltip: saved ? l10n.duaHubRemoveSaved : l10n.duaHubSave,
            visualDensity: VisualDensity.compact,
            onPressed: () =>
                ref.read(duaLearningProvider.notifier).toggleSaved(item.id),
            icon: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: colors.accent,
            ),
          ),
          onTap: () {
            context.pushNamed(
              'learnDuaDetail',
              pathParameters: {'duaId': item.id},
            );
          },
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, DuaCategorySummary summary) {
    final colors = DuaCategoryTheme.resolve(context, summary.id);
    final l10n = AppLocalizations.of(context);
    return _interactiveCard(
      onTap: () {
        setState(() {
          _selectedCategoryId = summary.id;
          _selectedSubcategoryId = null;
          _tab = DuaHubTab.duas;
        });
      },
      semanticsLabel: l10n.duaHubOpenCategorySemantics(summary.label),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardBanner(context: context, colors: colors, title: summary.label),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: summary.subcategories
                  .map(
                    (subcategory) => _duaActionChip(
                      label: l10n.duaHubCategoryTag(
                        subcategory.label,
                        subcategory.completeCount,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = summary.id;
                          _selectedSubcategoryId = subcategory.id;
                          _tab = DuaHubTab.duas;
                        });
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyCard(BuildContext context, DuaItem item) {
    final colors = DuaCategoryTheme.resolve(context, item.category);
    final l10n = AppLocalizations.of(context);
    return _interactiveCard(
      onTap: () {
        context.pushNamed('learnDuaDetail', pathParameters: {'duaId': item.id});
      },
      semanticsLabel: l10n.duaHubOpenDuaSemantics(item.title),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardBanner(
              context: context,
              colors: colors,
              title: l10n.duaHubDailyTitle,
              subtitle: item.title,
            ),
            const SizedBox(height: 10),
            Text(
              item.whenToSay,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _metaChip(item.subcategoryLabel, colors: colors),
                _metaChip(
                  item.isQuran ? l10n.duaSourceQuran : l10n.duaSourceSunnah,
                  colors: colors,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(String message) {
    return PremiumCard(child: Text(message));
  }

  Widget _errorCard(Object error) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(child: Text(l10n.duaHubLoadError(error.toString())));
  }

  Widget _metaChip(String label, {required DuaCategoryThemeData colors}) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: colors.accent,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(label, style: TextStyle(fontSize: 12, color: colors.accent)),
    );
  }

  Widget _duaFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: style
            .decoration(radius: 999, includeShadow: false)
            .copyWith(
              color: selected
                  ? AppSurfaceTheme.adaptiveColor(
                      context,
                      AppColors.accentGold,
                      alpha: 0.18,
                      solidAlphaWhenDisabled: 0.28,
                    )
                  : style.backgroundColor,
              gradient: selected ? null : style.gradient,
              border: Border.all(
                color: selected ? AppColors.accentGold : style.borderColor,
              ),
            ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.onSurface : AppColors.onSurfaceSubtle,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _duaActionChip({required String label, required VoidCallback onTap}) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: style.decoration(radius: 999, includeShadow: false),
        child: Text(label),
      ),
    );
  }

  Widget _interactiveCard({
    required VoidCallback onTap,
    required String semanticsLabel,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        button: true,
        label: semanticsLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _cardBanner({
    required BuildContext context,
    required DuaCategoryThemeData colors,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    final bannerStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: colors.accent,
    );
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: colors.accent,
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: bannerStyle.decoration(radius: 18, includeShadow: false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: iconStyle.decoration(radius: 14, includeShadow: false),
            child: Icon(colors.icon, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.accent,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  String _tabLabel(AppLocalizations l10n, DuaHubTab tab) {
    switch (tab) {
      case DuaHubTab.duas:
        return l10n.duaHubTabLearn;
      case DuaHubTab.categories:
        return l10n.duaHubTabCategories;
      case DuaHubTab.saved:
        return l10n.duaHubTabSaved;
      case DuaHubTab.daily:
        return l10n.duaHubTabDaily;
    }
  }

  DuaCategorySummary? _selectedCategorySummary(
    List<DuaCategorySummary>? categories,
  ) {
    if (categories == null || _selectedCategoryId == null) return null;
    for (final summary in categories) {
      if (summary.id == _selectedCategoryId) {
        return summary;
      }
    }
    return null;
  }

  void _handleSearchChanged() {
    final nextQuery = _searchController.text.trim().toLowerCase();
    if (_query == nextQuery || !mounted) return;
    setState(() {
      _query = nextQuery;
    });
  }

  String get _normalizedQuery => _query;
}
