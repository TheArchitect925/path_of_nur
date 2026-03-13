import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/dua_progress_provider.dart';
import '../application/dua_repository.dart';
import '../domain/dua_models.dart';

enum DuaHubTab { duas, categories, saved, daily }

class DuaHubPage extends ConsumerStatefulWidget {
  const DuaHubPage({super.key});

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
    final datasetAsync = ref.watch(duaDatasetProvider);
    final categoriesAsync = ref.watch(duaCategorySummariesProvider);
    final userState = ref.watch(duaLearningProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.pan_tool_alt_rounded,
      title: 'Duas',
      subtitle:
          'Verified Qur’anic and Prophetic supplications, organized for daily life, worship, family, travel, and hardship.',
      children: [
        PremiumCard(
          child: SegmentedPillControl<DuaHubTab>(
            items: DuaHubTab.values,
            selectedItem: _tab,
            labelBuilder: _tabLabel,
            onChanged: (tab) => setState(() => _tab = tab),
          ),
        ),
        const SizedBox(height: 10),
        _searchCard(context),
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
                _overviewCard(context, dataset),
                const SizedBox(height: 10),
                categoriesAsync.when(
                  data: (categories) => _categoryScroller(categories),
                  loading: () => const SizedBox.shrink(),
                  error: (_, stackTrace) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                if (_tab == DuaHubTab.duas) ...[
                  if (verified.isEmpty)
                    _emptyCard('No verified duas match this filter yet.')
                  else
                    ...verified.map((item) => _duaCard(context, item)),
                ] else if (_tab == DuaHubTab.categories) ...[
                  categoriesAsync.when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return _emptyCard('No dua categories available yet.');
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
                    _emptyCard(
                      'Save duas here to build your personal collection.',
                    )
                  else
                    ...saved.map((item) => _duaCard(context, item)),
                ] else ...[
                  if (daily == null)
                    _emptyCard('No daily dua available right now.')
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

  Widget _searchCard(BuildContext context) {
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
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 24,
            color: AppColors.onSurface.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search duas, sources, categories, tags...',
                isCollapsed: true,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () => setState(() => _searchController.clear()),
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }

  Widget _overviewCard(BuildContext context, DuaDataset dataset) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dataset overview',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip('${dataset.completeItems} verified now'),
              _statChip('${dataset.stubItems} planned in scaffold'),
              _statChip('${dataset.totalItems} total tracked'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Only verified entries are surfaced as readable duas right now. The remaining scaffold items stay tracked for later scholarly completion.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }

  Widget _categoryScroller(List<DuaCategorySummary> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All categories'),
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
                item.sourceRef,
                item.whenToSay,
                item.category,
                item.subcategory,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.sourceRef,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(duaLearningProvider.notifier)
                      .toggleSaved(item.id),
                  icon: Icon(
                    saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.whenToSay),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _metaChip(item.isQuran ? 'Qur’an' : 'Sunnah'),
                _metaChip(item.subcategoryLabel),
                _metaChip(item.difficulty.label),
                if (item.isCore) _metaChip('Core verified'),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () {
                context.pushNamed(
                  'learnDuaDetail',
                  pathParameters: {'duaId': item.id},
                );
              },
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Open dua'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, DuaCategorySummary summary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    summary.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _statChip('${summary.completeCount} ready'),
                const SizedBox(width: 8),
                _statChip('${summary.stubCount} planned'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: summary.subcategories.entries
                  .map((entry) => _metaChip('${entry.key} · ${entry.value}'))
                  .toList(growable: false),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () {
                setState(() {
                  _selectedCategoryId = summary.id;
                  _tab = DuaHubTab.duas;
                });
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('View verified duas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyCard(BuildContext context, DuaItem item) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily dua',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(item.title),
          const SizedBox(height: 4),
          Text(
            item.whenToSay,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () {
              context.pushNamed(
                'learnDuaDetail',
                pathParameters: {'duaId': item.id},
              );
            },
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Open today\'s dua'),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(String message) {
    return PremiumCard(child: Text(message));
  }

  Widget _errorCard(Object error) {
    return PremiumCard(child: Text('Unable to load duas right now. $error'));
  }

  Widget _statChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.2)),
      ),
      child: Text(label),
    );
  }

  Widget _metaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.glassSurfaceAlpha),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  String _tabLabel(DuaHubTab tab) {
    switch (tab) {
      case DuaHubTab.duas:
        return 'Learn';
      case DuaHubTab.categories:
        return 'Categories';
      case DuaHubTab.saved:
        return 'Saved';
      case DuaHubTab.daily:
        return 'Daily';
    }
  }
}
