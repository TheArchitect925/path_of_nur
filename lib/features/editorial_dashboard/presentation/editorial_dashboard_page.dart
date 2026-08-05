import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/editorial_dashboard_access_provider.dart';
import '../application/editorial_dashboard_providers.dart';
import '../domain/editorial_dashboard_models.dart';
import '../domain/editorial_content_version_models.dart';
import 'editorial_content_browser_page.dart';

class EditorialDashboardPage extends ConsumerStatefulWidget {
  const EditorialDashboardPage({super.key});

  @override
  ConsumerState<EditorialDashboardPage> createState() =>
      _EditorialDashboardPageState();
}

class _EditorialDashboardPageState
    extends ConsumerState<EditorialDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  EditorialDashboardDomain? _selectedDomain;
  EditorialDashboardItemStatus? _selectedStatus;
  EditorialPriorityLevel? _selectedPriority;
  EditorialReadinessState? _selectedReadiness;
  EditorialIssueCode? _selectedIssueCode;
  EditorialScoreBand? _selectedScoreBand;
  String? _selectedPackId;
  bool _missingOnly = false;
  bool _needsReviewOnly = false;
  bool _kidsMissingOnly = false;
  bool _localizationMissingOnly = false;
  bool _sourceMissingOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scoredItems = ref.watch(editorialDashboardScoredItemsProvider);
    final queues = ref.watch(editorialDashboardReviewQueuesProvider);
    final packHealth = ref.watch(editorialDashboardPackHealthProvider);
    final triageSummary = ref.watch(editorialDashboardTriageSummaryProvider);
    final version = ref.watch(editorialDashboardPackageInfoProvider);
    final visibleItems = _filterItems(scoredItems);
    final grouped = <EditorialDashboardDomain, List<EditorialScoredItem>>{};
    for (final item in visibleItems) {
      grouped
          .putIfAbsent(item.item.domain, () => <EditorialScoredItem>[])
          .add(item);
    }
    final filteredPacks = packHealth
        .where((pack) {
          if (_selectedDomain != null && pack.domain != _selectedDomain) {
            return false;
          }
          if (_selectedPackId != null && pack.packId != _selectedPackId) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
    final packIds =
        packHealth.map((pack) => pack.packId).toSet().toList(growable: false)
          ..sort();

    return AppPageScaffold(
      headerIcon: Icons.dashboard_customize_outlined,
      title: l10n.editorialDashboardTitle,
      subtitle: version.when(
        data: (value) => l10n.editorialDashboardSubtitle(value),
        loading: () => l10n.editorialDashboardSubtitleLoading,
        error: (_, _) => l10n.editorialDashboardSubtitleUnknown,
      ),
      headerActions: [
        IconButton(
          tooltip: l10n.editorialDashboardLockAction,
          onPressed: () {
            ref.read(editorialDashboardAccessProvider.notifier).lock();
            context.goNamed('settingsAbout');
          },
          icon: const Icon(Icons.lock_reset_rounded),
        ),
      ],
      children: [
        _OverviewCard(
          totalDomains: grouped.length,
          totalItems: scoredItems.length,
          visibleItems: visibleItems.length,
          summary: triageSummary,
        ),
        const SizedBox(height: 16),
        _QueueSection(queues: queues, onSelectQueue: _applyQueueFilter),
        const SizedBox(height: 16),
        _FiltersCard(
          searchController: _searchController,
          selectedDomain: _selectedDomain,
          selectedStatus: _selectedStatus,
          selectedPriority: _selectedPriority,
          selectedReadiness: _selectedReadiness,
          selectedIssueCode: _selectedIssueCode,
          selectedScoreBand: _selectedScoreBand,
          selectedPackId: _selectedPackId,
          missingOnly: _missingOnly,
          needsReviewOnly: _needsReviewOnly,
          kidsMissingOnly: _kidsMissingOnly,
          localizationMissingOnly: _localizationMissingOnly,
          sourceMissingOnly: _sourceMissingOnly,
          packIds: packIds,
          visibleCount: visibleItems.length,
          totalCount: scoredItems.length,
          onChanged: () => setState(() {}),
          onDomainChanged: (value) => setState(() => _selectedDomain = value),
          onStatusChanged: (value) => setState(() => _selectedStatus = value),
          onPriorityChanged: (value) =>
              setState(() => _selectedPriority = value),
          onReadinessChanged: (value) =>
              setState(() => _selectedReadiness = value),
          onIssueChanged: (value) => setState(() => _selectedIssueCode = value),
          onScoreBandChanged: (value) =>
              setState(() => _selectedScoreBand = value),
          onPackChanged: (value) => setState(() => _selectedPackId = value),
          onMissingChanged: (value) => setState(() => _missingOnly = value),
          onNeedsReviewChanged: (value) =>
              setState(() => _needsReviewOnly = value),
          onKidsMissingChanged: (value) =>
              setState(() => _kidsMissingOnly = value),
          onLocalizationMissingChanged: (value) =>
              setState(() => _localizationMissingOnly = value),
          onSourceMissingChanged: (value) =>
              setState(() => _sourceMissingOnly = value),
          onClearFilters: _clearFilters,
        ),
        const SizedBox(height: 16),
        _PackHealthSection(
          packs: filteredPacks,
          onSelectPack: (packId) => setState(() => _selectedPackId = packId),
        ),
        const SizedBox(height: 16),
        if (visibleItems.isEmpty)
          PremiumCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.editorialDashboardEmptyTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.editorialDashboardEmptySubtitle),
                ],
              ),
            ),
          )
        else
          ...grouped.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _DomainSectionCard(
                domain: entry.key,
                items: entry.value,
                onSaveNote: _openNoteDialog,
                onSetReadiness: (itemId, readiness) {
                  ref
                      .read(editorialDashboardMetadataProvider.notifier)
                      .setReadiness(itemId, readiness);
                },
              ),
            ),
          ),
      ],
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedDomain = null;
      _selectedStatus = null;
      _selectedPriority = null;
      _selectedReadiness = null;
      _selectedIssueCode = null;
      _selectedScoreBand = null;
      _selectedPackId = null;
      _missingOnly = false;
      _needsReviewOnly = false;
      _kidsMissingOnly = false;
      _localizationMissingOnly = false;
      _sourceMissingOnly = false;
    });
  }

  void _applyQueueFilter(EditorialTriageCategory category) {
    setState(() {
      _selectedIssueCode = switch (category) {
        EditorialTriageCategory.criticalIssues => null,
        EditorialTriageCategory.needsReview => EditorialIssueCode.needsReview,
        EditorialTriageCategory.kidsSafetyGaps =>
          EditorialIssueCode.missingKids,
        EditorialTriageCategory.missingLocalization =>
          EditorialIssueCode.missingLocalization,
        EditorialTriageCategory.missingSourceMetadata =>
          EditorialIssueCode.missingSourceRef,
        EditorialTriageCategory.incompleteContentPacks =>
          EditorialIssueCode.weakPackCoverage,
        EditorialTriageCategory.lowQuality => null,
        EditorialTriageCategory.readyForVerification => null,
        EditorialTriageCategory.recentlyUpdated => null,
        EditorialTriageCategory.staleContent => EditorialIssueCode.staleContent,
      };
      _selectedPriority = category == EditorialTriageCategory.criticalIssues
          ? EditorialPriorityLevel.critical
          : _selectedPriority;
      _selectedScoreBand = category == EditorialTriageCategory.lowQuality
          ? EditorialScoreBand.weak
          : _selectedScoreBand;
      _selectedReadiness =
          category == EditorialTriageCategory.readyForVerification
          ? EditorialReadinessState.reviewed
          : _selectedReadiness;
      _missingOnly = category == EditorialTriageCategory.incompleteContentPacks
          ? true
          : _missingOnly;
      _needsReviewOnly = category == EditorialTriageCategory.needsReview
          ? true
          : _needsReviewOnly;
      _kidsMissingOnly = category == EditorialTriageCategory.kidsSafetyGaps
          ? true
          : _kidsMissingOnly;
      _localizationMissingOnly =
          category == EditorialTriageCategory.missingLocalization
          ? true
          : _localizationMissingOnly;
      _sourceMissingOnly =
          category == EditorialTriageCategory.missingSourceMetadata
          ? true
          : _sourceMissingOnly;
    });
  }

  Future<void> _openNoteDialog(
    BuildContext context,
    EditorialScoredItem item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: item.note ?? '');
    final saved = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editorialDashboardNoteDialogTitle),
          content: TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: l10n.editorialDashboardNoteDialogHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.editorialDashboardCancelAction),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(''),
              child: Text(l10n.editorialDashboardClearNoteAction),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(l10n.editorialDashboardSaveNoteAction),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (saved == null) return;
    ref
        .read(editorialDashboardMetadataProvider.notifier)
        .saveNote(item.item.id, saved);
  }

  List<EditorialScoredItem> _filterItems(List<EditorialScoredItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = items
        .where((item) {
          if (_selectedDomain != null && item.item.domain != _selectedDomain) {
            return false;
          }
          if (_selectedStatus != null && item.item.status != _selectedStatus) {
            return false;
          }
          if (_selectedPriority != null &&
              item.quality.priority != _selectedPriority) {
            return false;
          }
          if (_selectedReadiness != null &&
              item.readiness != _selectedReadiness) {
            return false;
          }
          if (_selectedIssueCode != null &&
              !item.quality.issues.any(
                (issue) => issue.code == _selectedIssueCode,
              )) {
            return false;
          }
          if (_selectedScoreBand != null &&
              item.quality.band != _selectedScoreBand) {
            return false;
          }
          if (_selectedPackId != null && item.item.packId != _selectedPackId) {
            return false;
          }
          if (_missingOnly && !item.item.missingContent) return false;
          if (_needsReviewOnly && !item.item.needsReview) return false;
          if (_kidsMissingOnly &&
              (!item.item.kidsExpected || item.item.kidsSafe)) {
            return false;
          }
          if (_localizationMissingOnly &&
              (!item.item.localizationExpected ||
                  item.item.localizationReady)) {
            return false;
          }
          if (_sourceMissingOnly &&
              (!item.item.sourcesExpected || item.item.hasSources)) {
            return false;
          }
          if (query.isEmpty) return true;
          final note = item.note?.toLowerCase() ?? '';
          final issueCodes = item.quality.issues
              .map((issue) => issue.code.name.toLowerCase())
              .join(' ');
          final readiness = item.readiness.name.toLowerCase();
          final priority = item.quality.priority.name.toLowerCase();
          return item.item.matchesQuery(query) ||
              note.contains(query) ||
              issueCodes.contains(query) ||
              readiness.contains(query) ||
              priority.contains(query);
        })
        .toList(growable: false);
    filtered.sort((a, b) {
      final priorityCompare = a.quality.priority.index.compareTo(
        b.quality.priority.index,
      );
      if (priorityCompare != 0) return priorityCompare;
      return a.quality.score.compareTo(b.quality.score);
    });
    return filtered;
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.totalDomains,
    required this.totalItems,
    required this.visibleItems,
    required this.summary,
  });

  final int totalDomains;
  final int totalItems;
  final int visibleItems;
  final EditorialTriageSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editorialDashboardOverviewTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(l10n.editorialDashboardOverviewSubtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewDomains,
                  value: totalDomains,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewItems,
                  value: totalItems,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewVisible,
                  value: visibleItems,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewCritical,
                  value: summary.criticalIssuesCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewHighPriority,
                  value: summary.highPriorityCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewKidsGaps,
                  value: summary.kidsSafetyGapCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewSourceGaps,
                  value: summary.missingSourceCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewLocalizationGaps,
                  value: summary.localizationGapCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewIncompletePacks,
                  value: summary.incompletePackCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewReadyToVerify,
                  value: summary.readyForVerificationCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewRecentlyUpdated,
                  value: summary.recentlyUpdatedCount,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewStale,
                  value: summary.staleCount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueSection extends StatelessWidget {
  const _QueueSection({required this.queues, required this.onSelectQueue});

  final List<EditorialReviewQueue> queues;
  final ValueChanged<EditorialTriageCategory> onSelectQueue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nonEmpty = queues
        .where((queue) => queue.items.isNotEmpty)
        .toList(growable: false);
    if (nonEmpty.isEmpty) {
      return const SizedBox.shrink();
    }
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editorialDashboardQueuesTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(l10n.editorialDashboardQueuesSubtitle),
            const SizedBox(height: 12),
            ...nonEmpty.map(
              (queue) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelectQueue(queue.category),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _queueLabel(l10n, queue.category),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              _MetricBadge(
                                label: l10n.editorialDashboardQueueItemsLabel,
                                value: queue.count,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...queue.items
                              .take(3)
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    '${_itemTitle(l10n, item.scoredItem.item)} · '
                                    '${_priorityLabel(l10n, item.scoredItem.quality.priority)} · '
                                    '${item.scoredItem.quality.score}',
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersCard extends StatelessWidget {
  const _FiltersCard({
    required this.searchController,
    required this.selectedDomain,
    required this.selectedStatus,
    required this.selectedPriority,
    required this.selectedReadiness,
    required this.selectedIssueCode,
    required this.selectedScoreBand,
    required this.selectedPackId,
    required this.missingOnly,
    required this.needsReviewOnly,
    required this.kidsMissingOnly,
    required this.localizationMissingOnly,
    required this.sourceMissingOnly,
    required this.packIds,
    required this.visibleCount,
    required this.totalCount,
    required this.onChanged,
    required this.onDomainChanged,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onReadinessChanged,
    required this.onIssueChanged,
    required this.onScoreBandChanged,
    required this.onPackChanged,
    required this.onMissingChanged,
    required this.onNeedsReviewChanged,
    required this.onKidsMissingChanged,
    required this.onLocalizationMissingChanged,
    required this.onSourceMissingChanged,
    required this.onClearFilters,
  });

  final TextEditingController searchController;
  final EditorialDashboardDomain? selectedDomain;
  final EditorialDashboardItemStatus? selectedStatus;
  final EditorialPriorityLevel? selectedPriority;
  final EditorialReadinessState? selectedReadiness;
  final EditorialIssueCode? selectedIssueCode;
  final EditorialScoreBand? selectedScoreBand;
  final String? selectedPackId;
  final bool missingOnly;
  final bool needsReviewOnly;
  final bool kidsMissingOnly;
  final bool localizationMissingOnly;
  final bool sourceMissingOnly;
  final List<String> packIds;
  final int visibleCount;
  final int totalCount;
  final VoidCallback onChanged;
  final ValueChanged<EditorialDashboardDomain?> onDomainChanged;
  final ValueChanged<EditorialDashboardItemStatus?> onStatusChanged;
  final ValueChanged<EditorialPriorityLevel?> onPriorityChanged;
  final ValueChanged<EditorialReadinessState?> onReadinessChanged;
  final ValueChanged<EditorialIssueCode?> onIssueChanged;
  final ValueChanged<EditorialScoreBand?> onScoreBandChanged;
  final ValueChanged<String?> onPackChanged;
  final ValueChanged<bool> onMissingChanged;
  final ValueChanged<bool> onNeedsReviewChanged;
  final ValueChanged<bool> onKidsMissingChanged;
  final ValueChanged<bool> onLocalizationMissingChanged;
  final ValueChanged<bool> onSourceMissingChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.editorialDashboardFiltersTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: onClearFilters,
                  child: Text(l10n.editorialDashboardClearFiltersAction),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.editorialDashboardSearchHint,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.editorialDashboardFilterMissingContent),
                  selected: missingOnly,
                  onSelected: onMissingChanged,
                ),
                FilterChip(
                  label: Text(l10n.editorialDashboardFilterNeedsReview),
                  selected: needsReviewOnly,
                  onSelected: onNeedsReviewChanged,
                ),
                FilterChip(
                  label: Text(l10n.editorialDashboardFilterKidsMissing),
                  selected: kidsMissingOnly,
                  onSelected: onKidsMissingChanged,
                ),
                FilterChip(
                  label: Text(l10n.editorialDashboardFilterLocalizationMissing),
                  selected: localizationMissingOnly,
                  onSelected: onLocalizationMissingChanged,
                ),
                FilterChip(
                  label: Text(l10n.editorialDashboardFilterSourceMissing),
                  selected: sourceMissingOnly,
                  onSelected: onSourceMissingChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialDashboardDomain>(
              allLabel: l10n.editorialDashboardFilterAllDomains,
              values: EditorialDashboardDomain.values,
              selectedValue: selectedDomain,
              labelFor: (domain) => _domainLabel(l10n, domain),
              onChanged: onDomainChanged,
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialDashboardItemStatus>(
              allLabel: l10n.editorialDashboardFilterAllStatuses,
              values: EditorialDashboardItemStatus.values,
              selectedValue: selectedStatus,
              labelFor: (status) => _statusLabel(l10n, status),
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialPriorityLevel>(
              allLabel: l10n.editorialDashboardFilterAllPriorities,
              values: EditorialPriorityLevel.values,
              selectedValue: selectedPriority,
              labelFor: (priority) => _priorityLabel(l10n, priority),
              onChanged: onPriorityChanged,
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialReadinessState>(
              allLabel: l10n.editorialDashboardFilterAllReadinessStates,
              values: EditorialReadinessState.values,
              selectedValue: selectedReadiness,
              labelFor: (readiness) => _readinessLabel(l10n, readiness),
              onChanged: onReadinessChanged,
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialScoreBand>(
              allLabel: l10n.editorialDashboardFilterAllScoreBands,
              values: EditorialScoreBand.values,
              selectedValue: selectedScoreBand,
              labelFor: (band) => _scoreBandLabel(l10n, band),
              onChanged: onScoreBandChanged,
            ),
            const SizedBox(height: 12),
            _ChoiceChipRow<EditorialIssueCode>(
              allLabel: l10n.editorialDashboardFilterAllIssueTypes,
              values: EditorialIssueCode.values,
              selectedValue: selectedIssueCode,
              labelFor: (issue) => _issueLabel(l10n, issue),
              onChanged: onIssueChanged,
            ),
            if (packIds.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ChoiceChipRow<String>(
                allLabel: l10n.editorialDashboardFilterAllPacks,
                values: packIds,
                selectedValue: selectedPackId,
                labelFor: (packId) => _packLabel(packId),
                onChanged: onPackChanged,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              l10n.editorialDashboardResultsCount(visibleCount, totalCount),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceChipRow<T> extends StatelessWidget {
  const _ChoiceChipRow({
    required this.allLabel,
    required this.values,
    required this.selectedValue,
    required this.labelFor,
    required this.onChanged,
  });

  final String allLabel;
  final List<T> values;
  final T? selectedValue;
  final String Function(T value) labelFor;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: Text(allLabel),
            selected: selectedValue == null,
            onSelected: (_) => onChanged(null),
          ),
          const SizedBox(width: 8),
          ...values.map(
            (value) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labelFor(value)),
                selected: selectedValue == value,
                onSelected: (_) => onChanged(value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackHealthSection extends StatelessWidget {
  const _PackHealthSection({required this.packs, required this.onSelectPack});

  final List<EditorialPackHealth> packs;
  final ValueChanged<String> onSelectPack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (packs.isEmpty) {
      return const SizedBox.shrink();
    }
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editorialDashboardPackHealthTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(l10n.editorialDashboardPackHealthSubtitle),
            const SizedBox(height: 12),
            ...packs.map(
              (pack) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelectPack(pack.packId),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _packLabel(pack.packId),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              _FlagBadge(
                                label: _readinessLabel(l10n, pack.readiness),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_domainLabel(l10n, pack.domain)} · '
                            '${l10n.editorialDashboardScoreLabel(pack.overallScore)}',
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _MetricBadge(
                                label: l10n.editorialDashboardMetricEntries,
                                value: pack.totalItems,
                              ),
                              _MetricBadge(
                                label: l10n.editorialDashboardMetricReviewed,
                                value: pack.reviewedItems,
                              ),
                              _MetricBadge(
                                label: l10n.editorialDashboardMetricVerified,
                                value: pack.verifiedItems,
                              ),
                              _MetricBadge(
                                label: l10n
                                    .editorialDashboardPackMetricMissingRequired,
                                value: pack.missingRequiredFieldsCount,
                              ),
                              _MetricBadge(
                                label: l10n
                                    .editorialDashboardPackMetricKidsCoverage,
                                value: pack.kidsSafeCoveragePercent,
                              ),
                              _MetricBadge(
                                label: l10n
                                    .editorialDashboardPackMetricSourceCoverage,
                                value: pack.sourceCoveragePercent,
                              ),
                              _MetricBadge(
                                label: l10n
                                    .editorialDashboardPackMetricLocalizationCoverage,
                                value: pack.localizationCoveragePercent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainSectionCard extends StatelessWidget {
  const _DomainSectionCard({
    required this.domain,
    required this.items,
    required this.onSaveNote,
    required this.onSetReadiness,
  });

  final EditorialDashboardDomain domain;
  final List<EditorialScoredItem> items;
  final Future<void> Function(BuildContext, EditorialScoredItem) onSaveNote;
  final void Function(String itemId, EditorialReadinessState readiness)
  onSetReadiness;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final missing = items.where((item) => item.item.missingContent).length;
    final needsReview = items.where((item) => item.item.needsReview).length;
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _domainLabel(l10n, domain),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewItems,
                  value: items.length,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewMissing,
                  value: missing,
                ),
                _MetricBadge(
                  label: l10n.editorialDashboardOverviewNeedsReview,
                  value: needsReview,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => _DashboardItemTile(
                item: item,
                onSaveNote: onSaveNote,
                onSetReadiness: onSetReadiness,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItemTile extends StatelessWidget {
  const _DashboardItemTile({
    required this.item,
    required this.onSaveNote,
    required this.onSetReadiness,
  });

  final EditorialScoredItem item;
  final Future<void> Function(BuildContext, EditorialScoredItem) onSaveNote;
  final void Function(String itemId, EditorialReadinessState readiness)
  onSetReadiness;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
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
                          _itemTitle(l10n, item.item),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_typeLabel(l10n, item.item.type)} · ${item.item.id}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (item.item.packId != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.editorialDashboardPackLabel}: '
                            '${_packLabel(item.item.packId!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _FlagBadge(
                        label: l10n.editorialDashboardScoreLabel(
                          item.quality.score,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _FlagBadge(
                        label: _priorityLabel(l10n, item.quality.priority),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FlagBadge(label: _statusLabel(l10n, item.item.status)),
                  _FlagBadge(label: _readinessLabel(l10n, item.readiness)),
                  _FlagBadge(label: _scoreBandLabel(l10n, item.quality.band)),
                  if (item.item.kidsSafe)
                    _FlagBadge(label: l10n.editorialDashboardFlagKidsSafe),
                  if (item.item.hasSources)
                    _FlagBadge(label: l10n.editorialDashboardFlagSources),
                  if (item.item.localizationReady)
                    _FlagBadge(
                      label: l10n.editorialDashboardFlagLocalizationReady,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...item.item.metrics.map(
                    (metric) => _MetricBadge(
                      label: _metricLabel(l10n, metric.type),
                      value: metric.value,
                    ),
                  ),
                ],
              ),
              if (item.quality.issues.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.editorialDashboardIssueListTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.quality.issues
                      .map(
                        (issue) =>
                            _FlagBadge(label: _issueLabel(l10n, issue.code)),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 8),
                ...item.quality.penaltyReasons
                    .take(3)
                    .map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(reason),
                      ),
                    ),
              ],
              if (item.quality.positiveReasons.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.editorialDashboardPositiveSignalsTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                ...item.quality.positiveReasons
                    .take(2)
                    .map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(reason),
                      ),
                    ),
              ],
              if (item.hasNote) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.editorialDashboardNoteLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(item.note!),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_editableContentTypeForItem(item.item.id)
                      case final contentType?)
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed(
                        'editorialContentBrowser',
                        pathParameters: {
                          'contentType': editorialContentTypeRouteSegment(
                            contentType,
                          ),
                        },
                      ),
                      icon: const Icon(Icons.edit_note_rounded),
                      label: Text(l10n.editorialDashboardOpenEditorAction),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => onSaveNote(context, item),
                    icon: const Icon(Icons.sticky_note_2_outlined),
                    label: Text(
                      item.hasNote
                          ? l10n.editorialDashboardEditNoteAction
                          : l10n.editorialDashboardAddNoteAction,
                    ),
                  ),
                  _ReadinessMenuButton(
                    currentReadiness: item.readiness,
                    onSelected: (readiness) =>
                        onSetReadiness(item.item.id, readiness),
                  ),
                  if (item.item.routeName != null)
                    OutlinedButton.icon(
                      onPressed: () => context.pushNamed(
                        item.item.routeName!,
                        pathParameters: item.item.pathParameters,
                        queryParameters: item.item.queryParameters,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: Text(l10n.editorialDashboardOpenRouteAction),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadinessMenuButton extends StatelessWidget {
  const _ReadinessMenuButton({
    required this.currentReadiness,
    required this.onSelected,
  });

  final EditorialReadinessState currentReadiness;
  final ValueChanged<EditorialReadinessState> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<EditorialReadinessState>(
      tooltip: l10n.editorialDashboardSetReadinessAction,
      onSelected: onSelected,
      itemBuilder: (context) {
        return EditorialReadinessState.values
            .map(
              (readiness) => PopupMenuItem<EditorialReadinessState>(
                value: readiness,
                child: Text(_readinessLabel(l10n, readiness)),
              ),
            )
            .toList(growable: false);
      },
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.verified_outlined),
        label: Text(
          '${l10n.editorialDashboardSetReadinessAction}: '
          '${_readinessLabel(l10n, currentReadiness)}',
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text('$label: $value'),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(label),
    );
  }
}

String _domainLabel(AppLocalizations l10n, EditorialDashboardDomain domain) {
  return switch (domain) {
    EditorialDashboardDomain.quran => l10n.editorialDashboardDomainQuran,
    EditorialDashboardDomain.hadith => l10n.editorialDashboardDomainHadith,
    EditorialDashboardDomain.stories => l10n.editorialDashboardDomainStories,
    EditorialDashboardDomain.duasDhikr =>
      l10n.editorialDashboardDomainDuasDhikr,
    EditorialDashboardDomain.learningPaths =>
      l10n.editorialDashboardDomainLearningPaths,
    EditorialDashboardDomain.kidsContent =>
      l10n.editorialDashboardDomainKidsContent,
    EditorialDashboardDomain.actionsDrops =>
      l10n.editorialDashboardDomainActionsDrops,
    EditorialDashboardDomain.recommendations =>
      l10n.editorialDashboardDomainRecommendations,
    EditorialDashboardDomain.localization =>
      l10n.editorialDashboardDomainLocalization,
  };
}

String _typeLabel(AppLocalizations l10n, EditorialDashboardItemType type) {
  return switch (type) {
    EditorialDashboardItemType.system => l10n.editorialDashboardTypeSystem,
    EditorialDashboardItemType.coverage => l10n.editorialDashboardTypeCoverage,
    EditorialDashboardItemType.pack => l10n.editorialDashboardTypePack,
    EditorialDashboardItemType.collection =>
      l10n.editorialDashboardTypeCollection,
    EditorialDashboardItemType.contentSet =>
      l10n.editorialDashboardTypeContentSet,
    EditorialDashboardItemType.journeySet =>
      l10n.editorialDashboardTypeJourneySet,
    EditorialDashboardItemType.pathSet => l10n.editorialDashboardTypePathSet,
    EditorialDashboardItemType.actionSet =>
      l10n.editorialDashboardTypeActionSet,
    EditorialDashboardItemType.engine => l10n.editorialDashboardTypeEngine,
    EditorialDashboardItemType.localeSet =>
      l10n.editorialDashboardTypeLocaleSet,
  };
}

String _statusLabel(
  AppLocalizations l10n,
  EditorialDashboardItemStatus status,
) {
  return switch (status) {
    EditorialDashboardItemStatus.draft => l10n.editorialDashboardStatusDraft,
    EditorialDashboardItemStatus.partial =>
      l10n.editorialDashboardStatusPartial,
    EditorialDashboardItemStatus.reviewed =>
      l10n.editorialDashboardStatusReviewed,
    EditorialDashboardItemStatus.verified =>
      l10n.editorialDashboardStatusVerified,
    EditorialDashboardItemStatus.info => l10n.editorialDashboardStatusInfo,
  };
}

String _metricLabel(AppLocalizations l10n, EditorialDashboardMetricType type) {
  return switch (type) {
    EditorialDashboardMetricType.entries =>
      l10n.editorialDashboardMetricEntries,
    EditorialDashboardMetricType.total => l10n.editorialDashboardMetricTotal,
    EditorialDashboardMetricType.covered =>
      l10n.editorialDashboardMetricCovered,
    EditorialDashboardMetricType.missing =>
      l10n.editorialDashboardMetricMissing,
    EditorialDashboardMetricType.reviewed =>
      l10n.editorialDashboardMetricReviewed,
    EditorialDashboardMetricType.verified =>
      l10n.editorialDashboardMetricVerified,
    EditorialDashboardMetricType.kidsReady =>
      l10n.editorialDashboardMetricKidsReady,
    EditorialDashboardMetricType.localized =>
      l10n.editorialDashboardMetricLocalized,
    EditorialDashboardMetricType.routes => l10n.editorialDashboardMetricRoutes,
    EditorialDashboardMetricType.completed =>
      l10n.editorialDashboardMetricCompleted,
    EditorialDashboardMetricType.sessions =>
      l10n.editorialDashboardMetricSessions,
    EditorialDashboardMetricType.deep => l10n.editorialDashboardMetricDeep,
  };
}

String _priorityLabel(AppLocalizations l10n, EditorialPriorityLevel priority) {
  return switch (priority) {
    EditorialPriorityLevel.critical => l10n.editorialDashboardPriorityCritical,
    EditorialPriorityLevel.high => l10n.editorialDashboardPriorityHigh,
    EditorialPriorityLevel.medium => l10n.editorialDashboardPriorityMedium,
    EditorialPriorityLevel.low => l10n.editorialDashboardPriorityLow,
  };
}

String _readinessLabel(
  AppLocalizations l10n,
  EditorialReadinessState readiness,
) {
  return switch (readiness) {
    EditorialReadinessState.notStarted =>
      l10n.editorialDashboardReadinessNotStarted,
    EditorialReadinessState.draft => l10n.editorialDashboardReadinessDraft,
    EditorialReadinessState.reviewed =>
      l10n.editorialDashboardReadinessReviewed,
    EditorialReadinessState.verified =>
      l10n.editorialDashboardReadinessVerified,
    EditorialReadinessState.launchReady =>
      l10n.editorialDashboardReadinessLaunchReady,
    EditorialReadinessState.needsRevision =>
      l10n.editorialDashboardReadinessNeedsRevision,
  };
}

String _issueLabel(AppLocalizations l10n, EditorialIssueCode issue) {
  return switch (issue) {
    EditorialIssueCode.missingContent =>
      l10n.editorialDashboardIssueMissingContent,
    EditorialIssueCode.missingKids => l10n.editorialDashboardIssueMissingKids,
    EditorialIssueCode.missingSourceRef =>
      l10n.editorialDashboardIssueMissingSourceRef,
    EditorialIssueCode.missingLocalization =>
      l10n.editorialDashboardIssueMissingLocalization,
    EditorialIssueCode.needsReview => l10n.editorialDashboardIssueNeedsReview,
    EditorialIssueCode.draftOnly => l10n.editorialDashboardIssueDraftOnly,
    EditorialIssueCode.incompleteRouteMetadata =>
      l10n.editorialDashboardIssueIncompleteRoute,
    EditorialIssueCode.weakPackCoverage =>
      l10n.editorialDashboardIssueWeakPackCoverage,
    EditorialIssueCode.missingActionMapping =>
      l10n.editorialDashboardIssueMissingActionMapping,
    EditorialIssueCode.missingRecommendationTags =>
      l10n.editorialDashboardIssueMissingRecommendationTags,
    EditorialIssueCode.lowCoverage => l10n.editorialDashboardIssueLowCoverage,
    EditorialIssueCode.staleContent => l10n.editorialDashboardIssueStaleContent,
    EditorialIssueCode.infoOnly => l10n.editorialDashboardIssueInfoOnly,
  };
}

String _scoreBandLabel(AppLocalizations l10n, EditorialScoreBand band) {
  return switch (band) {
    EditorialScoreBand.excellent => l10n.editorialDashboardScoreBandExcellent,
    EditorialScoreBand.healthy => l10n.editorialDashboardScoreBandHealthy,
    EditorialScoreBand.weak => l10n.editorialDashboardScoreBandWeak,
  };
}

String _queueLabel(AppLocalizations l10n, EditorialTriageCategory category) {
  return switch (category) {
    EditorialTriageCategory.criticalIssues =>
      l10n.editorialDashboardQueueCriticalIssues,
    EditorialTriageCategory.needsReview =>
      l10n.editorialDashboardQueueNeedsReview,
    EditorialTriageCategory.kidsSafetyGaps =>
      l10n.editorialDashboardQueueKidsSafetyGaps,
    EditorialTriageCategory.missingLocalization =>
      l10n.editorialDashboardQueueMissingLocalization,
    EditorialTriageCategory.missingSourceMetadata =>
      l10n.editorialDashboardQueueMissingSources,
    EditorialTriageCategory.incompleteContentPacks =>
      l10n.editorialDashboardQueueIncompletePacks,
    EditorialTriageCategory.lowQuality =>
      l10n.editorialDashboardQueueLowQuality,
    EditorialTriageCategory.readyForVerification =>
      l10n.editorialDashboardQueueReadyForVerification,
    EditorialTriageCategory.recentlyUpdated =>
      l10n.editorialDashboardQueueRecentlyUpdated,
    EditorialTriageCategory.staleContent =>
      l10n.editorialDashboardQueueStaleContent,
  };
}

String _itemTitle(AppLocalizations l10n, EditorialDashboardItem item) {
  return switch (item.id) {
    'quran_ayah_explanations' =>
      l10n.editorialDashboardItemQuranAyahExplanations,
    'quran_explanation_rollout_packs' =>
      l10n.editorialDashboardItemQuranExplanationPacks,
    'quran_surah_summaries' => l10n.editorialDashboardItemQuranSurahSummaries,
    'quran_explanation_surah_coverage' =>
      l10n.editorialDashboardItemQuranSurahCoverage,
    'hadith_themes' => l10n.editorialDashboardItemHadithThemes,
    'hadith_collections' => l10n.editorialDashboardItemHadithCollections,
    'hadith_entries' => l10n.editorialDashboardItemHadithEntries,
    'story_prophets_library' => l10n.editorialDashboardItemProphetsLibrary,
    'story_bedtime_library' => l10n.editorialDashboardItemBedtimeStories,
    'story_kids_library' => l10n.editorialDashboardItemKidsStories,
    'story_kids_seerah_journey' => l10n.editorialDashboardItemKidsSeerahJourney,
    'dua_kids_categories' => l10n.editorialDashboardItemKidsDuaCategories,
    'dua_kids_lessons' => l10n.editorialDashboardItemKidsDuaLessons,
    'dua_kids_stories' => l10n.editorialDashboardItemKidsDuaStories,
    'dhikr_tracking_system' => l10n.editorialDashboardItemDhikrTracking,
    'guided_learning_paths' => l10n.editorialDashboardItemGuidedPaths,
    'learning_journeys' => l10n.editorialDashboardItemLearningJourneys,
    'learning_journey_resume_state' =>
      l10n.editorialDashboardItemLearningJourneyState,
    'kids_quran_layer' => l10n.editorialDashboardItemKidsQuranLayer,
    'kids_dua_system' => l10n.editorialDashboardItemKidsDuaSystem,
    'kids_story_system' => l10n.editorialDashboardItemKidsStorySystem,
    'kids_seerah_system' => l10n.editorialDashboardItemKidsSeerahSystem,
    'quran_ayah_actions' => l10n.editorialDashboardItemQuranAyahActions,
    'ocean_drop_mappings' => l10n.editorialDashboardItemOceanDrops,
    'quran_personalization_engine' =>
      l10n.editorialDashboardItemPersonalizationEngine,
    'spiritual_moments_engine' =>
      l10n.editorialDashboardItemSpiritualMomentsEngine,
    'daily_companion_surfaces' =>
      l10n.editorialDashboardItemDailyCompanionSurfaces,
    'app_supported_locales' => l10n.editorialDashboardItemSupportedLocales,
    'dashboard_runtime_localization' =>
      l10n.editorialDashboardItemRuntimeLocalization,
    _ => item.id,
  };
}

String _packLabel(String packId) {
  return packId
      .split('_')
      .where((segment) => segment.isNotEmpty)
      .map(
        (segment) =>
            '${segment[0].toUpperCase()}${segment.substring(1).toLowerCase()}',
      )
      .join(' ');
}

EditorialContentType? _editableContentTypeForItem(String itemId) {
  return switch (itemId) {
    'quran_ayah_explanations' => EditorialContentType.quranExplanation,
    'hadith_entries' => EditorialContentType.hadithEntry,
    'story_prophets_library' => EditorialContentType.bedtimeStory,
    'story_bedtime_library' => EditorialContentType.bedtimeStory,
    'story_kids_library' => EditorialContentType.bedtimeStory,
    'dua_kids_lessons' => EditorialContentType.kidsDuaLesson,
    _ => null,
  };
}
