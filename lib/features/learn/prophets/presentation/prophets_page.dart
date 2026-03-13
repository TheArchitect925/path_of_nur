import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/data/learn_icon_registry.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/prophet_detail_repository.dart';
import '../application/daily_learning_service.dart';
import '../application/prophets_repository.dart';
import '../application/prophets_ui_state.dart';
import '../domain/daily_learning_item.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophets_tab.dart';
import 'prophet_detail_page.dart';
import 'journey_of_revelation_page.dart';
import 'prophetic_family_tree_page.dart';
import 'prophets_map_view.dart';
import 'prophets_quiz_view.dart';
import 'prophets_stories_view.dart';
import 'prophets_timeline_view.dart';
import 'widgets/daily_prophet_quiz_card.dart';
import 'widgets/daily_revelation_card.dart';

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
    final allProphets = ref.watch(prophetsProvider);
    final ui = ref.watch(prophetsUiControllerProvider);
    final controller = ref.read(prophetsUiControllerProvider.notifier);
    final isQuiz = ui.selectedTab == ProphetsTab.quiz;
    final isJourney = ui.selectedTab == ProphetsTab.journey;
    final isFamilyTree = ui.selectedTab == ProphetsTab.familyTree;
    final dailyBundle = ref.watch(todayDailyLearningBundleProvider);
    final dailyController = ref.read(dailyLearningControllerProvider.notifier);
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
      title: 'Stories of the Prophets',
      subtitle:
          'Explore prophetic lives through stories, chronology, and carefully labeled regions.',
      children: [
        if (!isFamilyTree)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DailyRevelationCard(
              item: dailyBundle.item,
              isOpened: dailyBundle.status.cardOpened,
              onOpen: () => _openDailyItem(
                item: dailyBundle.item,
                allProphets: allProphets,
              ),
              onTakeQuiz: () {
                if (ui.selectedTab == ProphetsTab.quiz) return;
                ref
                    .read(prophetsUiControllerProvider.notifier)
                    .setSelectedTab(ProphetsTab.quiz);
              },
              showPracticeLesson: dailyBundle.item.linkedGrowthHabitId != null,
              onPracticeLesson: () {
                final habitId = dailyBundle.item.linkedGrowthHabitId;
                if (habitId != null && habitId.trim().isNotEmpty) {
                  context.go('/journey/habit/$habitId');
                  return;
                }
                context.go('/journey/growth/habits');
              },
            ),
          ),
        if (!isFamilyTree)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DailyProphetQuizCard(
              question: dailyBundle.quizQuestion,
              isAnswered: dailyBundle.status.quizAnswered,
              selectedIndex: dailyBundle.status.quizSelectedIndex,
              onSelectAnswer: (selected) {
                dailyController.answerTodayQuiz(
                  questionId: dailyBundle.quizQuestion.id,
                  selectedIndex: selected,
                  correctIndex: dailyBundle.quizQuestion.correctAnswerIndex,
                );
              },
              onReviewProphet: () {
                final prophet = allProphets
                    .where(
                      (item) =>
                          item.id == dailyBundle.quizQuestion.relatedProphetId,
                    )
                    .firstOrNull;
                if (prophet == null) return;
                _openDetail(prophet);
              },
              onOpenFullQuiz: () {
                ref
                    .read(prophetsUiControllerProvider.notifier)
                    .setSelectedTab(ProphetsTab.quiz);
              },
            ),
          ),
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
                        const Text(
                          'Continue where you left of',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lastOpened.name} · ${lastOpened.eraTitle}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openDetail(lastOpened),
                    child: const Text('Open'),
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
                TextField(
                  onChanged: controller.setSearchQuery,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search prophet, Arabic name, era, or region',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip(
                        label: 'All',
                        selected: ui.filterScope == ProphetFilterScope.all,
                        onTap: () =>
                            controller.setFilterScope(ProphetFilterScope.all),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: 'Featured',
                        selected: ui.filterScope == ProphetFilterScope.featured,
                        onTap: () => controller.setFilterScope(
                          ProphetFilterScope.featured,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: 'Era: ${ui.eraFilter?.title ?? 'Any'}',
                        selected: ui.eraFilter != null,
                        onTap: () => _showEraPicker(context, ui.eraFilter),
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: 'Region: ${ui.regionFilter ?? 'Any'}',
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
                          label: 'Clear',
                          selected: false,
                          onTap: controller.clearFilters,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${filtered.length} prophets',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else if (isQuiz) ...[
                const SizedBox(height: 8),
                Text(
                  'Test stories, timeline, lessons, and references in a calm learning flow.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else if (isFamilyTree) ...[
                const SizedBox(height: 8),
                Text(
                  'Explore major lineage connections with careful, non-speculative family context.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  'Follow a guided chronological journey across eras, regions, and core prophetic calls.',
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
          prophet.arabicName.contains(ui.searchQuery.trim()) ||
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
                title: const Text('Any Era'),
                trailing: selected == null
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(null),
              ),
              ...ProphetEraGroup.values.map(
                (era) => ListTile(
                  title: Text(era.title),
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
                title: const Text('Any Region'),
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

  void _openDailyItem({
    required DailyLearningItem item,
    required List<ProphetEntry> allProphets,
  }) {
    ref.read(dailyLearningControllerProvider.notifier).markTodayCardOpened();
    if (item.linkedProphetId != null) {
      final prophet = allProphets
          .where((entry) => entry.id == item.linkedProphetId)
          .firstOrNull;
      if (prophet == null) return;
      ref
          .read(dailyLearningControllerProvider.notifier)
          .markTodayLinkedProphetOpened(prophet.id);
      _openDetail(prophet);
      return;
    }

    if (item.linkedEraId != null) {
      setState(() => _focusEraId = item.linkedEraId);
      ref
          .read(prophetsUiControllerProvider.notifier)
          .setSelectedTab(ProphetsTab.journey);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Today\'s reflection is marked as opened.')),
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
              previousProphetLabel: previous?.name,
              nextProphetLabel: next?.name,
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
