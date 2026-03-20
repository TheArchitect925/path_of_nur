import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/dua_progress_provider.dart';
import '../application/dua_repository.dart';
import '../domain/dua_models.dart';
import 'dua_category_theme.dart';

enum DuaHubTab { duas, categories, saved, daily }

enum DuaHubEntryContext { learn, worship }

class DuaHubPage extends ConsumerStatefulWidget {
  const DuaHubPage({super.key, this.entryContext = DuaHubEntryContext.learn});

  final DuaHubEntryContext entryContext;

  @override
  ConsumerState<DuaHubPage> createState() => _DuaHubPageState();
}

class _DuaHubPageState extends ConsumerState<DuaHubPage> {
  late final TextEditingController _searchController;
  DuaHubTab _tab = DuaHubTab.duas;
  String? _selectedCategoryId;

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
    final datasetAsync = ref.watch(duaDatasetProvider);
    final categoriesAsync = ref.watch(duaCategorySummariesProvider);
    final userState = ref.watch(duaLearningProvider);
    final visibleTabs = _visibleTabs;

    return LearnHubPageScaffold(
      headerIcon: Icons.pan_tool_alt_rounded,
      title: l10n.duaHubTitle,
      subtitle: l10n.duaHubSubtitle,
      children: [
        PremiumCard(
          child: SegmentedPillControl<DuaHubTab>(
            items: visibleTabs,
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
            final daily = _dailyItem(dataset);
            final saved = verified
                .where((item) => userState.savedIds.contains(item.id))
                .toList(growable: false);
            return Column(
              children: [
                _overviewCard(context, l10n, dataset),
                if (_showsCategorySelection) ...[
                  const SizedBox(height: 10),
                  categoriesAsync.when(
                    data: (categories) =>
                        _categoryScroller(context, l10n, categories),
                    loading: () => const SizedBox.shrink(),
                    error: (_, stackTrace) => const SizedBox.shrink(),
                  ),
                ],
                const SizedBox(height: 12),
                if (_tab == DuaHubTab.duas) ...[
                  if (verified.isEmpty)
                    _emptyCard(l10n.duaHubEmptyFiltered)
                  else
                    ...verified.map((item) => _duaCard(context, item)),
                ] else if (_tab == DuaHubTab.categories) ...[
                  categoriesAsync.when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return _emptyCard(l10n.duaHubEmptyCategories);
                      }
                      return Column(
                        children: categories
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
                    ...saved.map((item) => _duaCard(context, item)),
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

  List<DuaHubTab> get _visibleTabs {
    if (_showsCategorySelection) return DuaHubTab.values;
    return const <DuaHubTab>[DuaHubTab.duas, DuaHubTab.saved, DuaHubTab.daily];
  }

  bool get _showsCategorySelection =>
      widget.entryContext == DuaHubEntryContext.learn;

  Widget _searchCard(BuildContext context, AppLocalizations l10n) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: LearnDiscoverySearchField(
        controller: _searchController,
        hintText: l10n.searchDuasHint,
        onChanged: (_) => setState(() {}),
        onClear: () => setState(() => _searchController.clear()),
      ),
    );
  }

  Widget _overviewCard(
    BuildContext context,
    AppLocalizations l10n,
    DuaDataset dataset,
  ) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duaHubOverviewTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip(l10n.duaHubOverviewVerifiedNow(dataset.completeItems)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.duaHubOverviewBody,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
        ],
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
            child: ChoiceChip(
              label: Text(l10n.duaHubAllCategories),
              selected: _selectedCategoryId == null,
              onSelected: (_) => setState(() => _selectedCategoryId = null),
            ),
          ),
          ...categories.map(
            (summary) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(summary.label),
                selected: _selectedCategoryId == summary.id,
                onSelected: (_) =>
                    setState(() => _selectedCategoryId = summary.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DuaItem> _filteredVerifiedItems(DuaDataset dataset) {
    final query = _searchController.text.trim().toLowerCase();
    final items =
        dataset.verifiedItems
            .where((item) {
              if (_selectedCategoryId != null &&
                  item.category != _selectedCategoryId) {
                return false;
              }
              if (query.isEmpty) return true;
              final haystack = [
                item.title,
                item.arabic,
                item.transliteration,
                item.translation,
                item.sourceType,
                item.sourceRef,
                item.whenToSay,
                item.category,
                item.subcategory,
                item.subcategoryLabel,
                ...item.tags,
              ].join(' ').toLowerCase();
              return haystack.contains(query);
            })
            .toList(growable: false)
          ..sort((a, b) {
            if (a.isCore != b.isCore) return a.isCore ? -1 : 1;
            return a.title.compareTo(b.title);
          });
    return items;
  }

  DuaItem? _dailyItem(DuaDataset dataset) {
    final items = dataset.verifiedItems;
    if (items.isEmpty) return null;
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final index = Random(seed).nextInt(items.length);
    return items[index];
  }

  Widget _duaCard(BuildContext context, DuaItem item) {
    final saved = ref.watch(duaLearningProvider).savedIds.contains(item.id);
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
              title: item.title,
              subtitle: item.sourceRef,
              trailing: IconButton(
                tooltip: saved ? l10n.duaHubRemoveSaved : l10n.duaHubSave,
                onPressed: () =>
                    ref.read(duaLearningProvider.notifier).toggleSaved(item.id),
                icon: Icon(
                  saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: colors.accent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(item.whenToSay),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _metaChip(
                  item.isQuran ? l10n.duaSourceQuran : l10n.duaSourceSunnah,
                  colors: colors,
                ),
                _metaChip(item.subcategoryLabel, colors: colors),
                _metaChip(
                  _difficultyLabel(l10n, item.difficulty),
                  colors: colors,
                ),
                if (item.isCore)
                  _metaChip(l10n.duaCoreVerified, colors: colors),
              ],
            ),
          ],
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
          _tab = DuaHubTab.duas;
        });
      },
      semanticsLabel: l10n.duaHubOpenCategorySemantics(summary.label),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardBanner(
              context: context,
              colors: colors,
              title: summary.label,
              subtitle: l10n.duaHubOverviewVerifiedNow(summary.completeCount),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: summary.subcategories.entries
                  .map(
                    (entry) => _metaChip(
                      l10n.duaHubCategoryTag(entry.key, entry.value),
                      colors: colors,
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

  Widget _statChip(String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999),
      child: Text(label),
    );
  }

  Widget _metaChip(String label, {required DuaCategoryThemeData colors}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.iconBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: colors.accent)),
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
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  String _difficultyLabel(AppLocalizations l10n, DuaDifficulty difficulty) {
    switch (difficulty) {
      case DuaDifficulty.beginner:
        return l10n.learnTrackBeginner;
      case DuaDifficulty.intermediate:
        return l10n.learnHubDifficultyIntermediate;
      case DuaDifficulty.advanced:
        return l10n.learnHubDifficultyAdvanced;
    }
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
}
