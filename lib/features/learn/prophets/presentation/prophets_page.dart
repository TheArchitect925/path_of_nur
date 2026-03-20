import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/data/learn_icon_registry.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/prophet_detail_repository.dart';
import '../application/prophets_repository.dart';
import '../application/prophets_ui_state.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophets_tab.dart';
import 'prophet_detail_page.dart';
import 'journey_of_revelation_page.dart';
import 'prophets_metadata_localization.dart';
import 'prophetic_family_tree_page.dart';
import 'prophets_map_view.dart';
import 'prophets_quiz_view.dart';
import 'prophets_stories_view.dart';
import 'prophets_timeline_view.dart';

class ProphetsPage extends ConsumerStatefulWidget {
  const ProphetsPage({
    super.key,
    this.initialTab,
    this.initialProphetId,
    this.initialQuizModeName,
    this.initialQuizDifficultyName,
  });

  final ProphetsTab? initialTab;
  final String? initialProphetId;
  final String? initialQuizModeName;
  final String? initialQuizDifficultyName;

  @override
  ConsumerState<ProphetsPage> createState() => _ProphetsPageState();
}

class _ProphetsPageState extends ConsumerState<ProphetsPage> {
  String? _focusProphetId;
  String? _focusEraId;
  late final TextEditingController _searchController;
  bool _openedInitialProphet = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tab = widget.initialTab;
      if (tab != null) {
        ref.read(prophetsUiControllerProvider.notifier).setSelectedTab(tab);
      }
      final initialProphetId = widget.initialProphetId;
      if (_openedInitialProphet ||
          initialProphetId == null ||
          initialProphetId.trim().isEmpty) {
        return;
      }
      final allProphets = ref.read(prophetsProvider);
      final prophet = allProphets
          .where((item) => item.id == initialProphetId.trim())
          .firstOrNull;
      if (prophet == null) return;
      _openedInitialProphet = true;
      ref
          .read(prophetsUiControllerProvider.notifier)
          .setSelectedTab(ProphetsTab.stories);
      _openDetail(prophet);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allProphets = ref.watch(prophetsProvider);
    final ui = ref.watch(prophetsUiControllerProvider);
    final controller = ref.read(prophetsUiControllerProvider.notifier);
    final isQuiz = ui.selectedTab == ProphetsTab.quiz;
    final isJourney = ui.selectedTab == ProphetsTab.journey;
    final isFamilyTree = ui.selectedTab == ProphetsTab.familyTree;
    final regions = _regions(allProphets);
    final filtered = _applyFilters(allProphets, ui);
    final lastOpened = ui.lastOpenedProphetId == null
        ? null
        : allProphets.where((p) => p.id == ui.lastOpenedProphetId).firstOrNull;
    if (_searchController.text != ui.searchQuery) {
      _searchController.value = TextEditingValue(
        text: ui.searchQuery,
        selection: TextSelection.collapsed(offset: ui.searchQuery.length),
      );
    }

    return LearnHubPageScaffold(
      headerIcon: LearnIconRegistry.iconFor('prophets'),
      title: l10n.prophetsPageTitle,
      subtitle: l10n.prophetsPageSubtitle,
      children: [
        if (lastOpened != null && !isQuiz && !isJourney && !isFamilyTree)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    color: Color(0xFF7C5D39),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.prophetsContinueLastOpenedTitle,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.prophetsContinueLastOpenedSubtitle(
                            lastOpened.honoredName,
                            localizedProphetEraTitle(l10n, lastOpened.eraGroup),
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openDetail(lastOpened),
                    child: Text(l10n.prophetsOpenAction),
                  ),
                ],
              ),
            ),
          ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProphetsSegmentedControl(
                selected: ui.selectedTab,
                onChanged: controller.setSelectedTab,
              ),
              const SizedBox(height: 10),
              if (!isQuiz && !isJourney && !isFamilyTree) ...[
                LearnDiscoverySearchField(
                  controller: _searchController,
                  hintText: l10n.searchProphetsHint,
                  onChanged: controller.setSearchQuery,
                  onClear: () {
                    _searchController.clear();
                    controller.setSearchQuery('');
                  },
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip(
                        label: l10n.prophetsFilterAll,
                        selected: ui.filterScope == ProphetFilterScope.all,
                        onTap: () =>
                            controller.setFilterScope(ProphetFilterScope.all),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: l10n.prophetsFilterFeatured,
                        selected: ui.filterScope == ProphetFilterScope.featured,
                        onTap: () => controller.setFilterScope(
                          ProphetFilterScope.featured,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: l10n.prophetsFilterEra(
                          ui.eraFilter == null
                              ? l10n.prophetsFilterAny
                              : localizedProphetEraTitle(l10n, ui.eraFilter!),
                        ),
                        selected: ui.eraFilter != null,
                        onTap: () => _showEraPicker(context, ui.eraFilter),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: l10n.prophetsFilterRegion(
                          ui.regionFilter ?? l10n.prophetsFilterAny,
                        ),
                        selected: ui.regionFilter != null,
                        onTap: () => _showRegionPicker(
                          context,
                          regions,
                          ui.regionFilter,
                        ),
                      ),
                      if (ui.eraFilter != null || ui.regionFilter != null) ...[
                        const SizedBox(width: 8),
                        _filterChip(
                          label: l10n.prophetsFilterClear,
                          selected: false,
                          onTap: controller.clearFilters,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.prophetsCount(filtered.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else if (isQuiz) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.prophetsQuizTabSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else if (isFamilyTree) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.prophetsFamilyTreeTabSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  l10n.prophetsJourneyTabSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (ui.selectedTab == ProphetsTab.stories)
          ProphetsStoriesView(
            prophets: filtered,
            bookmarkedIds: ui.bookmarkedIds,
            onToggleBookmark: controller.toggleBookmark,
            onOpenDetail: _openDetail,
          )
        else if (ui.selectedTab == ProphetsTab.timeline)
          ProphetsTimelineView(
            prophets: filtered,
            focusedProphetId: _focusProphetId,
            onOpenDetail: _openDetail,
          )
        else if (ui.selectedTab == ProphetsTab.map)
          ProphetsMapView(
            prophets: filtered,
            focusedProphetId: _focusProphetId,
            onOpenDetail: _openDetail,
          )
        else if (ui.selectedTab == ProphetsTab.quiz)
          ProphetsQuizView(
            initialModeName: widget.initialQuizModeName,
            initialDifficultyName: widget.initialQuizDifficultyName,
            onReviewProphets: () {
              ref
                  .read(prophetsUiControllerProvider.notifier)
                  .setSelectedTab(ProphetsTab.stories);
            },
          )
        else if (ui.selectedTab == ProphetsTab.familyTree)
          PropheticFamilyTreePage(
            prophets: allProphets,
            focusedProphetId: _focusProphetId,
            onOpenDetail: _openDetail,
          )
        else
          JourneyOfRevelationPage(
            prophets: allProphets,
            focusedEraId: _focusEraId,
            onOpenDetail: _openDetail,
            onSwitchTab: (tab) => ref
                .read(prophetsUiControllerProvider.notifier)
                .setSelectedTab(tab),
          ),
      ],
    );
  }

  List<ProphetEntry> _applyFilters(List<ProphetEntry> all, ProphetsUiState ui) {
    return all.where((prophet) {
      if (ui.filterScope == ProphetFilterScope.featured &&
          !prophet.isFeatured) {
        return false;
      }
      if (ui.eraFilter != null && prophet.eraGroup != ui.eraFilter) {
        return false;
      }
      if (ui.regionFilter != null && prophet.regionLabel != ui.regionFilter) {
        return false;
      }
      final q = ui.searchQuery.trim().toLowerCase();
      if (q.isEmpty) return true;
      return prophet.name.toLowerCase().contains(q) ||
          prophet.honoredName.toLowerCase().contains(q) ||
          prophet.arabicName.contains(ui.searchQuery.trim()) ||
          prophet.honoredArabicName.contains(ui.searchQuery.trim()) ||
          prophet.eraTitle.toLowerCase().contains(q) ||
          prophet.regionLabel.toLowerCase().contains(q) ||
          (prophet.locationLabel?.toLowerCase().contains(q) ?? false) ||
          prophet.shortSummary.toLowerCase().contains(q);
    }).toList();
  }

  List<String> _regions(List<ProphetEntry> prophets) {
    final set = <String>{};
    for (final item in prophets) {
      if (item.regionLabel.trim().isNotEmpty) set.add(item.regionLabel);
    }
    final list = set.toList()..sort();
    return list;
  }

  Future<void> _showEraPicker(
    BuildContext context,
    ProphetEraGroup? selected,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(prophetsUiControllerProvider.notifier);
    final result = await showModalBottomSheet<ProphetEraGroup?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(l10n.prophetsAnyEra),
                trailing: selected == null
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(null),
              ),
              ...ProphetEraGroup.values.map(
                (era) => ListTile(
                  title: Text(localizedProphetEraTitle(l10n, era)),
                  trailing: selected == era
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => Navigator.of(context).pop(era),
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.setEraFilter(result);
  }

  Future<void> _showRegionPicker(
    BuildContext context,
    List<String> regions,
    String? selected,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(prophetsUiControllerProvider.notifier);
    final result = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(l10n.prophetsAnyRegion),
                trailing: selected == null
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(null),
              ),
              ...regions.map(
                (region) => ListTile(
                  title: Text(region),
                  trailing: selected == region
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => Navigator.of(context).pop(region),
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.setRegionFilter(result);
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? AppColors.accentGold.withValues(alpha: 0.22)
              : AppColors.surface.withValues(alpha: 0.3),
          border: Border.all(
            color: selected
                ? AppColors.accentGold.withValues(alpha: 0.6)
                : AppColors.accentGoldSoft.withValues(alpha: 0.32),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.3)),
      ),
    );
  }

  void _openDetail(ProphetEntry prophet) {
    final allProphets = ref.read(prophetsProvider);
    final detailRepo = ref.read(prophetDetailRepositoryProvider);
    final detailContent = detailRepo.forProphet(prophet);
    final uiController = ref.read(prophetsUiControllerProvider.notifier);

    uiController.setLastOpened(prophet.id);
    setState(() => _focusProphetId = prophet.id);

    final index = allProphets.indexWhere((item) => item.id == prophet.id);
    final previous = index > 0 ? allProphets[index - 1] : null;
    final next = index >= 0 && index < allProphets.length - 1
        ? allProphets[index + 1]
        : null;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Consumer(
          builder: (context, ref, _) {
            final ui = ref.watch(prophetsUiControllerProvider);
            final isSaved = ui.bookmarkedIds.contains(prophet.id);
            return ProphetDetailPage(
              prophet: prophet,
              content: detailContent,
              allProphets: allProphets,
              isBookmarked: isSaved,
              onToggleBookmark: () => ref
                  .read(prophetsUiControllerProvider.notifier)
                  .toggleBookmark(prophet.id),
              onOpenRelatedProphet: (relatedId) {
                final related = allProphets
                    .where((item) => item.id == relatedId)
                    .firstOrNull;
                if (related == null) return;
                Navigator.of(context).pop();
                _openDetail(related);
              },
              previousProphetLabel: previous?.honoredName,
              nextProphetLabel: next?.honoredName,
              onOpenPreviousProphet: previous == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _openDetail(previous);
                    },
              onOpenNextProphet: next == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _openDetail(next);
                    },
              onViewInTimeline: () {
                Navigator.of(context).pop();
                ref
                    .read(prophetsUiControllerProvider.notifier)
                    .setSelectedTab(ProphetsTab.timeline);
                setState(() => _focusProphetId = prophet.id);
              },
              onViewOnMap: prophet.hasMapLocation
                  ? () {
                      Navigator.of(context).pop();
                      ref
                          .read(prophetsUiControllerProvider.notifier)
                          .setSelectedTab(ProphetsTab.map);
                      setState(() => _focusProphetId = prophet.id);
                    }
                  : null,
              onViewInFamilyTree: () {
                Navigator.of(context).pop();
                ref
                    .read(prophetsUiControllerProvider.notifier)
                    .setSelectedTab(ProphetsTab.familyTree);
                setState(() => _focusProphetId = prophet.id);
              },
            );
          },
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}

class _ProphetsSegmentedControl extends StatelessWidget {
  const _ProphetsSegmentedControl({
    required this.selected,
    required this.onChanged,
  });

  final ProphetsTab selected;
  final ValueChanged<ProphetsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedPillControl<ProphetsTab>(
      items: ProphetsTab.values,
      selectedItem: selected,
      labelBuilder: _label,
      onChanged: onChanged,
    );
  }

  String _label(ProphetsTab tab) {
    switch (tab) {
      case ProphetsTab.stories:
        return 'Stories';
      case ProphetsTab.timeline:
        return 'Timeline';
      case ProphetsTab.map:
        return 'Map';
      case ProphetsTab.quiz:
        return 'Quiz';
      case ProphetsTab.journey:
        return 'Journey';
      case ProphetsTab.familyTree:
        return 'Family';
    }
  }
}
