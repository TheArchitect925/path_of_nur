import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/hadith_foundation_models.dart';

enum HadithBrowseSortOption { recommended, title, source, grade }

enum HadithBrowseProgressFilter { all, notReviewed, reviewing, complete }

class HadithBrowseCollectionOption {
  const HadithBrowseCollectionOption({required this.id, required this.title});

  final String id;
  final String title;
}

class HadithBrowseSubcategoryOption {
  const HadithBrowseSubcategoryOption({required this.id, required this.title});

  final String id;
  final String title;
}

class HadithBrowseFilterState {
  const HadithBrowseFilterState({
    this.sort = HadithBrowseSortOption.recommended,
    this.sourceTitle,
    this.collectionId,
    this.gradeLabel,
    this.subcategoryId,
    this.progressFilter = HadithBrowseProgressFilter.all,
  });

  final HadithBrowseSortOption sort;
  final String? sourceTitle;
  final String? collectionId;
  final String? gradeLabel;
  final String? subcategoryId;
  final HadithBrowseProgressFilter progressFilter;

  bool get hasActiveNarrowing =>
      sourceTitle != null ||
      collectionId != null ||
      gradeLabel != null ||
      subcategoryId != null ||
      progressFilter != HadithBrowseProgressFilter.all;

  HadithBrowseFilterState copyWith({
    HadithBrowseSortOption? sort,
    String? sourceTitle,
    bool clearSourceTitle = false,
    String? collectionId,
    bool clearCollectionId = false,
    String? gradeLabel,
    bool clearGradeLabel = false,
    String? subcategoryId,
    bool clearSubcategoryId = false,
    HadithBrowseProgressFilter? progressFilter,
  }) {
    return HadithBrowseFilterState(
      sort: sort ?? this.sort,
      sourceTitle: clearSourceTitle ? null : (sourceTitle ?? this.sourceTitle),
      collectionId: clearCollectionId
          ? null
          : (collectionId ?? this.collectionId),
      gradeLabel: clearGradeLabel ? null : (gradeLabel ?? this.gradeLabel),
      subcategoryId: clearSubcategoryId
          ? null
          : (subcategoryId ?? this.subcategoryId),
      progressFilter: progressFilter ?? this.progressFilter,
    );
  }
}

List<String> hadithBrowseSourceOptions(List<HadithEntry> entries) {
  final values =
      entries
          .map((entry) => entry.displaySourceCollectionTitle.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort();
  return values;
}

List<String> hadithBrowseGradeOptions(List<HadithEntry> entries) {
  final values =
      entries
          .map((entry) => entry.standardizedGrade.displayLabel.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort((a, b) {
          final compare = _gradePriority(a).compareTo(_gradePriority(b));
          if (compare != 0) return compare;
          return a.compareTo(b);
        });
  return values;
}

List<HadithBrowseCollectionOption> hadithBrowseCollectionOptions(
  List<HadithCollection> collections,
) {
  return collections
      .map(
        (collection) => HadithBrowseCollectionOption(
          id: collection.id,
          title: collection.title,
        ),
      )
      .toList(growable: false)
    ..sort((a, b) => a.title.compareTo(b.title));
}

List<HadithBrowseSubcategoryOption> hadithBrowseSubcategoryOptions(
  List<HadithEntry> entries,
) {
  final titlesById = <String, String>{};
  for (final entry in entries) {
    final id = entry.normalizedSubcategoryId;
    final title = entry.displaySubcategoryTitle;
    if (id == null || title == null || title.trim().isEmpty) continue;
    titlesById[id] = title;
  }

  return titlesById.entries
      .map(
        (entry) =>
            HadithBrowseSubcategoryOption(id: entry.key, title: entry.value),
      )
      .toList(growable: false)
    ..sort((a, b) => a.title.compareTo(b.title));
}

List<HadithEntry> applyHadithBrowseFilters({
  required List<HadithEntry> entries,
  required HadithBrowseFilterState state,
  Set<String> openedLessonIds = const <String>{},
  Set<String> completedLessonIds = const <String>{},
}) {
  final filtered = entries
      .where((entry) {
        if (state.sourceTitle != null &&
            entry.displaySourceCollectionTitle != state.sourceTitle) {
          return false;
        }
        if (state.collectionId != null &&
            !entry.collectionIds.contains(state.collectionId)) {
          return false;
        }
        if (state.gradeLabel != null &&
            entry.standardizedGrade.displayLabel != state.gradeLabel) {
          return false;
        }
        if (state.subcategoryId != null &&
            entry.normalizedSubcategoryId != state.subcategoryId) {
          return false;
        }
        switch (state.progressFilter) {
          case HadithBrowseProgressFilter.all:
            break;
          case HadithBrowseProgressFilter.notReviewed:
            if (openedLessonIds.contains(entry.id)) return false;
          case HadithBrowseProgressFilter.reviewing:
            if (!openedLessonIds.contains(entry.id) ||
                completedLessonIds.contains(entry.id)) {
              return false;
            }
          case HadithBrowseProgressFilter.complete:
            if (!completedLessonIds.contains(entry.id)) return false;
        }
        return true;
      })
      .toList(growable: false);

  final sorted = [...filtered];
  switch (state.sort) {
    case HadithBrowseSortOption.recommended:
      return sorted;
    case HadithBrowseSortOption.title:
      sorted.sort((a, b) => a.title.compareTo(b.title));
    case HadithBrowseSortOption.source:
      sorted.sort((a, b) {
        final sourceCompare = a.displaySourceCollectionTitle.compareTo(
          b.displaySourceCollectionTitle,
        );
        if (sourceCompare != 0) return sourceCompare;
        final referenceCompare = (a.displaySourceReference ?? '').compareTo(
          b.displaySourceReference ?? '',
        );
        if (referenceCompare != 0) return referenceCompare;
        return a.title.compareTo(b.title);
      });
    case HadithBrowseSortOption.grade:
      sorted.sort((a, b) {
        final gradeCompare = a.standardizedGrade.category.index.compareTo(
          b.standardizedGrade.category.index,
        );
        if (gradeCompare != 0) return gradeCompare;
        return a.title.compareTo(b.title);
      });
  }
  return sorted;
}

bool shouldShowHadithBrowseQuickStart({
  required List<HadithEntry> visibleEntries,
  required HadithBrowseFilterState state,
}) {
  return !state.hasActiveNarrowing && visibleEntries.length > 12;
}

class HadithBrowseControlsCard extends StatelessWidget {
  const HadithBrowseControlsCard({
    super.key,
    required this.state,
    required this.onResetAll,
    required this.onSortChanged,
    required this.onSourceChanged,
    this.onCollectionChanged,
    required this.onGradeChanged,
    required this.onSubcategoryChanged,
    this.onProgressFilterChanged,
    required this.sourceOptions,
    this.collectionOptions = const <HadithBrowseCollectionOption>[],
    required this.gradeOptions,
    required this.subcategoryOptions,
    this.showProgressFilter = false,
  });

  final HadithBrowseFilterState state;
  final VoidCallback onResetAll;
  final ValueChanged<HadithBrowseSortOption> onSortChanged;
  final ValueChanged<String?> onSourceChanged;
  final ValueChanged<String?>? onCollectionChanged;
  final ValueChanged<String?> onGradeChanged;
  final ValueChanged<String?> onSubcategoryChanged;
  final ValueChanged<HadithBrowseProgressFilter>? onProgressFilterChanged;
  final List<String> sourceOptions;
  final List<HadithBrowseCollectionOption> collectionOptions;
  final List<String> gradeOptions;
  final List<HadithBrowseSubcategoryOption> subcategoryOptions;
  final bool showProgressFilter;

  @override
  Widget build(BuildContext context) {
    return _HadithBrowseControlsSurface(
      state: state,
      onResetAll: onResetAll,
      onSortChanged: onSortChanged,
      onSourceChanged: onSourceChanged,
      onCollectionChanged: onCollectionChanged,
      onGradeChanged: onGradeChanged,
      onSubcategoryChanged: onSubcategoryChanged,
      onProgressFilterChanged: onProgressFilterChanged,
      sourceOptions: sourceOptions,
      collectionOptions: collectionOptions,
      gradeOptions: gradeOptions,
      subcategoryOptions: subcategoryOptions,
      showProgressFilter: showProgressFilter,
    );
  }
}

enum _HadithBrowseControlPanel {
  sort,
  progress,
  source,
  collection,
  grade,
  subcategory,
}

class _HadithBrowseControlsSurface extends StatefulWidget {
  const _HadithBrowseControlsSurface({
    required this.state,
    required this.onResetAll,
    required this.onSortChanged,
    required this.onSourceChanged,
    required this.onCollectionChanged,
    required this.onGradeChanged,
    required this.onSubcategoryChanged,
    required this.onProgressFilterChanged,
    required this.sourceOptions,
    required this.collectionOptions,
    required this.gradeOptions,
    required this.subcategoryOptions,
    required this.showProgressFilter,
  });

  final HadithBrowseFilterState state;
  final VoidCallback onResetAll;
  final ValueChanged<HadithBrowseSortOption> onSortChanged;
  final ValueChanged<String?> onSourceChanged;
  final ValueChanged<String?>? onCollectionChanged;
  final ValueChanged<String?> onGradeChanged;
  final ValueChanged<String?> onSubcategoryChanged;
  final ValueChanged<HadithBrowseProgressFilter>? onProgressFilterChanged;
  final List<String> sourceOptions;
  final List<HadithBrowseCollectionOption> collectionOptions;
  final List<String> gradeOptions;
  final List<HadithBrowseSubcategoryOption> subcategoryOptions;
  final bool showProgressFilter;

  @override
  State<_HadithBrowseControlsSurface> createState() =>
      _HadithBrowseControlsSurfaceState();
}

class _HadithBrowseControlsSurfaceState
    extends State<_HadithBrowseControlsSurface> {
  _HadithBrowseControlPanel _expandedPanel = _HadithBrowseControlPanel.sort;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeSummaryItems = _activeSummaryItems(l10n);
    final panels = <_HadithBrowseControlPanel>[
      _HadithBrowseControlPanel.sort,
      if (widget.showProgressFilter && widget.onProgressFilterChanged != null)
        _HadithBrowseControlPanel.progress,
      if (widget.sourceOptions.length > 1) _HadithBrowseControlPanel.source,
      if (widget.collectionOptions.length > 1 &&
          widget.onCollectionChanged != null)
        _HadithBrowseControlPanel.collection,
      if (widget.gradeOptions.length > 1) _HadithBrowseControlPanel.grade,
      if (widget.subcategoryOptions.length > 1)
        _HadithBrowseControlPanel.subcategory,
    ];
    final activePanel = panels.contains(_expandedPanel)
        ? _expandedPanel
        : panels.first;
    if (activePanel != _expandedPanel) {
      _expandedPanel = activePanel;
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedPillControl<_HadithBrowseControlPanel>(
            items: panels,
            selectedItem: activePanel,
            labelBuilder: (panel) => _panelLabel(context, panel),
            onChanged: (panel) {
              setState(() {
                _expandedPanel = panel;
              });
            },
          ),
          if (activeSummaryItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.hadithBrowseActiveFiltersTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onResetAll,
                  child: Text(l10n.hadithBrowseResetAll),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeSummaryItems
                  .map((item) => Chip(label: Text(item)))
                  .toList(growable: false),
            ),
            const SizedBox(height: 18),
          ] else ...[
            const SizedBox(height: 18),
          ],
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: KeyedSubtree(
              key: ValueKey(activePanel),
              child: _buildExpandedPanel(context, activePanel, l10n),
            ),
          ),
        ],
      ),
    );
  }

  String _panelLabel(BuildContext context, _HadithBrowseControlPanel panel) {
    final l10n = AppLocalizations.of(context);
    return switch (panel) {
      _HadithBrowseControlPanel.sort => l10n.hadithBrowseSortLabel,
      _HadithBrowseControlPanel.progress => l10n.hadithBrowseProgressLabel,
      _HadithBrowseControlPanel.source => l10n.hadithSearchFilterSource,
      _HadithBrowseControlPanel.collection => l10n.hadithBrowseCollectionLabel,
      _HadithBrowseControlPanel.grade => l10n.hadithSearchFilterGrade,
      _HadithBrowseControlPanel.subcategory =>
        l10n.hadithSearchFilterSubcategory,
    };
  }

  List<String> _activeSummaryItems(AppLocalizations l10n) {
    final items = <String>[];

    if (widget.state.sort != HadithBrowseSortOption.recommended) {
      items.add(
        '${l10n.hadithBrowseSortLabel}: ${widget.state.sort.label(l10n)}',
      );
    }
    if (widget.state.progressFilter != HadithBrowseProgressFilter.all) {
      items.add(
        '${l10n.hadithBrowseProgressLabel}: ${widget.state.progressFilter.label(l10n)}',
      );
    }
    if (widget.state.sourceTitle != null) {
      items.add(
        '${l10n.hadithSearchFilterSource}: ${widget.state.sourceTitle!}',
      );
    }
    final collectionTitle = _selectedCollectionTitle();
    if (collectionTitle != null) {
      items.add('${l10n.hadithBrowseCollectionLabel}: $collectionTitle');
    }
    if (widget.state.gradeLabel != null) {
      items.add('${l10n.hadithSearchFilterGrade}: ${widget.state.gradeLabel!}');
    }
    final subcategoryTitle = _selectedSubcategoryTitle();
    if (subcategoryTitle != null) {
      items.add('${l10n.hadithSearchFilterSubcategory}: $subcategoryTitle');
    }

    return items;
  }

  String _panelSummary(BuildContext context, _HadithBrowseControlPanel panel) {
    final l10n = AppLocalizations.of(context);
    return switch (panel) {
      _HadithBrowseControlPanel.sort =>
        '${l10n.hadithBrowseSortLabel}: ${widget.state.sort.label(l10n)}',
      _HadithBrowseControlPanel.progress =>
        '${l10n.hadithBrowseProgressLabel}: ${widget.state.progressFilter.label(l10n)}',
      _HadithBrowseControlPanel.source =>
        '${l10n.hadithSearchFilterSource}: ${widget.state.sourceTitle ?? l10n.hadithBrowseAllSources}',
      _HadithBrowseControlPanel.collection =>
        '${l10n.hadithBrowseCollectionLabel}: ${_selectedCollectionTitle() ?? l10n.hadithBrowseAllCollections}',
      _HadithBrowseControlPanel.grade =>
        '${l10n.hadithSearchFilterGrade}: ${widget.state.gradeLabel ?? l10n.hadithBrowseAllGrades}',
      _HadithBrowseControlPanel.subcategory =>
        '${l10n.hadithSearchFilterSubcategory}: ${_selectedSubcategoryTitle() ?? l10n.hadithBrowseAllSubcategories}',
    };
  }

  String? _selectedCollectionTitle() {
    for (final item in widget.collectionOptions) {
      if (item.id == widget.state.collectionId) return item.title;
    }
    return null;
  }

  String? _selectedSubcategoryTitle() {
    for (final item in widget.subcategoryOptions) {
      if (item.id == widget.state.subcategoryId) return item.title;
    }
    return null;
  }

  Widget _buildExpandedPanel(
    BuildContext context,
    _HadithBrowseControlPanel panel,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _panelSummary(context, panel),
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        switch (panel) {
          _HadithBrowseControlPanel.sort => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HadithBrowseSortOption.values
                .map(
                  (item) => ChoiceChip(
                    selected: widget.state.sort == item,
                    label: Text(item.label(l10n)),
                    onSelected: (_) => widget.onSortChanged(item),
                  ),
                )
                .toList(growable: false),
          ),
          _HadithBrowseControlPanel.progress => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HadithBrowseProgressFilter.values
                .map(
                  (item) => ChoiceChip(
                    selected: widget.state.progressFilter == item,
                    label: Text(item.label(l10n)),
                    onSelected: (_) =>
                        widget.onProgressFilterChanged?.call(item),
                  ),
                )
                .toList(growable: false),
          ),
          _HadithBrowseControlPanel.source => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: widget.state.sourceTitle == null,
                label: Text(l10n.hadithBrowseAllSources),
                onSelected: (_) => widget.onSourceChanged(null),
              ),
              ...widget.sourceOptions.map(
                (item) => ChoiceChip(
                  selected: widget.state.sourceTitle == item,
                  label: Text(item),
                  onSelected: (_) => widget.onSourceChanged(item),
                ),
              ),
            ],
          ),
          _HadithBrowseControlPanel.collection => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: widget.state.collectionId == null,
                label: Text(l10n.hadithBrowseAllCollections),
                onSelected: (_) => widget.onCollectionChanged?.call(null),
              ),
              ...widget.collectionOptions.map(
                (item) => ChoiceChip(
                  selected: widget.state.collectionId == item.id,
                  label: Text(item.title),
                  onSelected: (_) => widget.onCollectionChanged?.call(item.id),
                ),
              ),
            ],
          ),
          _HadithBrowseControlPanel.grade => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: widget.state.gradeLabel == null,
                label: Text(l10n.hadithBrowseAllGrades),
                onSelected: (_) => widget.onGradeChanged(null),
              ),
              ...widget.gradeOptions.map(
                (item) => ChoiceChip(
                  selected: widget.state.gradeLabel == item,
                  label: Text(item),
                  onSelected: (_) => widget.onGradeChanged(item),
                ),
              ),
            ],
          ),
          _HadithBrowseControlPanel.subcategory => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: widget.state.subcategoryId == null,
                label: Text(l10n.hadithBrowseAllSubcategories),
                onSelected: (_) => widget.onSubcategoryChanged(null),
              ),
              ...widget.subcategoryOptions.map(
                (item) => ChoiceChip(
                  selected: widget.state.subcategoryId == item.id,
                  label: Text(item.title),
                  onSelected: (_) => widget.onSubcategoryChanged(item.id),
                ),
              ),
            ],
          ),
        },
      ],
    );
  }
}

class HadithBrowseQuickPickTile extends StatelessWidget {
  const HadithBrowseQuickPickTile({super.key, required this.entry, this.onTap});

  final HadithEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subtitleParts = <String>[
      entry.displaySourceCollectionTitle,
      if ((entry.displaySourceReference ?? '').trim().isNotEmpty)
        entry.displaySourceReference!,
      if (entry.standardizedGrade.displayLabel.trim().isNotEmpty)
        entry.standardizedGrade.displayLabel,
    ];

    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(entry.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subtitleParts.join(' • ')),
            const SizedBox(height: 4),
            Text(
              l10n.hadithPathQuranConnections(entry.quranConnections.length),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap:
            onTap ??
            () => context.pushNamed(
              'hadithLessonDetail',
              pathParameters: {'lessonId': entry.id},
            ),
      ),
    );
  }
}

String hadithCardPreviewText(HadithEntry entry) {
  final translation = entry.translation.trim();
  if (translation.isNotEmpty) return translation;

  final excerpt = entry.excerpt.trim();
  if (excerpt.isNotEmpty) return excerpt;

  final arabic = (entry.arabicMatn ?? '').trim();
  if (arabic.isNotEmpty) return arabic;

  return entry.title;
}

extension on HadithBrowseSortOption {
  String label(AppLocalizations l10n) {
    switch (this) {
      case HadithBrowseSortOption.recommended:
        return l10n.hadithBrowseSortRecommended;
      case HadithBrowseSortOption.title:
        return l10n.hadithBrowseSortTitle;
      case HadithBrowseSortOption.source:
        return l10n.hadithBrowseSortSource;
      case HadithBrowseSortOption.grade:
        return l10n.hadithBrowseSortGrade;
    }
  }
}

extension HadithBrowseProgressFilterX on HadithBrowseProgressFilter {
  String label(AppLocalizations l10n) {
    switch (this) {
      case HadithBrowseProgressFilter.all:
        return l10n.hadithBrowseProgressAll;
      case HadithBrowseProgressFilter.notReviewed:
        return l10n.hadithBrowseProgressNotReviewed;
      case HadithBrowseProgressFilter.reviewing:
        return l10n.hadithBrowseProgressReviewing;
      case HadithBrowseProgressFilter.complete:
        return l10n.hadithBrowseProgressComplete;
    }
  }
}

int _gradePriority(String label) {
  final normalized = label.toLowerCase();
  if (normalized.contains('muttafaqun')) return 0;
  if (normalized.contains('sahih')) return 1;
  if (normalized.contains('hasan')) return 2;
  if (normalized.contains('balagh')) return 3;
  if (normalized.contains('weak') || normalized.contains("da'if")) return 4;
  return 5;
}
