import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';
import '../application/hadith_reading_status_service.dart';
import '../application/hadith_reader_share_service.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_reader_metadata.dart';
import 'hadith_reader_continuity.dart';
import 'widgets/hadith_browse_helpers.dart';

class HadithBrowsePage extends ConsumerStatefulWidget {
  const HadithBrowsePage({super.key});

  @override
  ConsumerState<HadithBrowsePage> createState() => _HadithBrowsePageState();
}

class _HadithBrowsePageState extends ConsumerState<HadithBrowsePage> {
  HadithBrowseFilterState _filterState = const HadithBrowseFilterState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(hadithEntriesProvider);
    final collections = ref.watch(hadithCollectionsProvider);
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final savedNotifier = ref.read(hadithSavedIdsProvider.notifier);
    final readingStatus = ref.watch(hadithReadingStatusProvider);
    final readingStatusNotifier = ref.read(
      hadithReadingStatusProvider.notifier,
    );

    final sourceOptions = hadithBrowseSourceOptions(entries);
    final collectionOptions = hadithBrowseCollectionOptions(collections);
    final gradeOptions = hadithBrowseGradeOptions(entries);
    final subcategoryOptions = hadithBrowseSubcategoryOptions(entries);
    final visibleEntries = applyHadithBrowseFilters(
      entries: entries,
      state: _filterState,
      openedLessonIds: readingStatus.openedLessonIds,
      completedLessonIds: readingStatus.completedLessonIds,
    );
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.browse,
      laneId: 'browse',
      laneTitle: l10n.hadithBrowsePageTitle,
      orderedLessonIds: visibleEntries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithBrowse',
    );
    final collectionTitlesById = {
      for (final collection in collections) collection.id: collection.title,
    };
    final activeChips = _buildActiveChips(
      l10n,
      _filterState,
      sourceOptions: sourceOptions,
      collectionOptions: collectionOptions,
      gradeOptions: gradeOptions,
      subcategoryOptions: subcategoryOptions,
    );
    final sourceCount = sourceOptions.length;
    final subcategoryCount = subcategoryOptions.length;

    return AppPageScaffold(
      headerIcon: Icons.tune_rounded,
      title: l10n.hadithBrowsePageTitle,
      subtitle: l10n.hadithBrowsePageSubtitle,
      bodySlivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.hadithBrowseMatchingEntriesTitle(visibleEntries.length),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        if (visibleEntries.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverToBoxAdapter(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hadithBrowseNoMatchesTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.hadithBrowseNoMatchesSubtitle),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList.builder(
              itemCount: visibleEntries.length,
              itemBuilder: (context, index) {
                final entry = visibleEntries[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == visibleEntries.length - 1 ? 0 : 10,
                  ),
                  child: _HadithBrowseResultCard(
                    entry: entry,
                    collectionTitlesById: collectionTitlesById,
                    isSaved: savedIds.contains(entry.id),
                    isCompleted: readingStatus.isCompleted(entry.id),
                    isReviewing: readingStatus.isReviewing(entry.id),
                    onToggleSaved: () => savedNotifier.toggle(entry.id),
                    onToggleCompleted: () =>
                        readingStatusNotifier.toggleCompleted(entry.id),
                    onShare: () => _shareCompactHadith(context, entry),
                    onOpen: () => pushHadithLessonDetail(
                      context,
                      lessonId: entry.id,
                      laneContext: laneContext,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithBrowseIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.hadithBrowseIntroBody),
              const SizedBox(height: 10),
              Text(
                l10n.hadithBrowseSummary(
                  entries.length,
                  sourceCount,
                  collectionOptions.length,
                  subcategoryCount,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('hadithSearch'),
                    icon: const Icon(Icons.search_rounded),
                    label: Text(l10n.hadithSearchOpenAction),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('hadithSourceBrowse'),
                    icon: const Icon(Icons.library_books_rounded),
                    label: Text(l10n.hadithActionBrowseSources),
                  ),
                ],
              ),
              if (activeChips.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.hadithBrowseActiveFiltersTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: activeChips),
              ],
            ],
          ),
        ),
        LearningSection(
          title: l10n.hadithBrowseControlsTitle,
          child: HadithBrowseControlsCard(
            state: _filterState,
            onResetAll: () =>
                setState(() => _filterState = const HadithBrowseFilterState()),
            onSortChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(sort: value),
            ),
            onSourceChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(
                sourceTitle: value,
                clearSourceTitle: value == null,
              ),
            ),
            onCollectionChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(
                collectionId: value,
                clearCollectionId: value == null,
              ),
            ),
            onGradeChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(
                gradeLabel: value,
                clearGradeLabel: value == null,
              ),
            ),
            onSubcategoryChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(
                subcategoryId: value,
                clearSubcategoryId: value == null,
              ),
            ),
            onProgressFilterChanged: (value) => setState(
              () => _filterState = _filterState.copyWith(progressFilter: value),
            ),
            sourceOptions: sourceOptions,
            collectionOptions: collectionOptions,
            gradeOptions: gradeOptions,
            subcategoryOptions: subcategoryOptions,
            showProgressFilter: true,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActiveChips(
    AppLocalizations l10n,
    HadithBrowseFilterState state, {
    required List<String> sourceOptions,
    required List<HadithBrowseCollectionOption> collectionOptions,
    required List<String> gradeOptions,
    required List<HadithBrowseSubcategoryOption> subcategoryOptions,
  }) {
    final chips = <Widget>[];

    if (state.sourceTitle != null &&
        sourceOptions.contains(state.sourceTitle)) {
      chips.add(
        InputChip(
          label: Text(state.sourceTitle!),
          onDeleted: () => setState(
            () => _filterState = _filterState.copyWith(clearSourceTitle: true),
          ),
        ),
      );
    }

    final collection = collectionOptions
        .where((item) => item.id == state.collectionId)
        .firstOrNull;
    if (collection != null) {
      chips.add(
        InputChip(
          label: Text(collection.title),
          onDeleted: () => setState(
            () => _filterState = _filterState.copyWith(clearCollectionId: true),
          ),
        ),
      );
    }

    if (state.gradeLabel != null && gradeOptions.contains(state.gradeLabel)) {
      chips.add(
        InputChip(
          label: Text(state.gradeLabel!),
          onDeleted: () => setState(
            () => _filterState = _filterState.copyWith(clearGradeLabel: true),
          ),
        ),
      );
    }

    final subcategory = subcategoryOptions
        .where((item) => item.id == state.subcategoryId)
        .firstOrNull;
    if (subcategory != null) {
      chips.add(
        InputChip(
          label: Text(subcategory.title),
          onDeleted: () => setState(
            () =>
                _filterState = _filterState.copyWith(clearSubcategoryId: true),
          ),
        ),
      );
    }

    if (state.progressFilter != HadithBrowseProgressFilter.all) {
      chips.add(
        InputChip(
          label: Text(state.progressFilter.label(l10n)),
          onDeleted: () => setState(
            () => _filterState = _filterState.copyWith(
              progressFilter: HadithBrowseProgressFilter.all,
            ),
          ),
        ),
      );
    }

    return chips;
  }
}

class _HadithBrowseResultCard extends StatelessWidget {
  const _HadithBrowseResultCard({
    required this.entry,
    required this.collectionTitlesById,
    required this.isSaved,
    required this.isCompleted,
    required this.isReviewing,
    required this.onToggleSaved,
    required this.onToggleCompleted,
    required this.onShare,
    required this.onOpen,
  });

  final HadithEntry entry;
  final Map<String, String> collectionTitlesById;
  final bool isSaved;
  final bool isCompleted;
  final bool isReviewing;
  final VoidCallback onToggleSaved;
  final VoidCallback onToggleCompleted;
  final VoidCallback onShare;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onOpen,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleCompleted,
                  tooltip: isCompleted
                      ? l10n.hadithActionMarkIncomplete
                      : l10n.hadithActionMarkCompleteForBrowse,
                  icon: Icon(
                    isCompleted
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: isCompleted
                        ? context.palette.success
                        : context.palette.onSurfaceSubtle,
                  ),
                ),
                IconButton(
                  onPressed: onShare,
                  tooltip: l10n.hadithActionShare,
                  icon: const Icon(Icons.share_outlined),
                ),
                IconButton(
                  onPressed: onToggleSaved,
                  tooltip: isSaved
                      ? l10n.accessibilityRemoveFromSaved
                      : l10n.accessibilitySaveHadith,
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved
                        ? context.palette.onSurface
                        : context.palette.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
            Text(hadithCardPreviewText(entry)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _badge(context, entry.displaySourceCollection),
                if ((entry.displaySourceReference ?? '').trim().isNotEmpty)
                  _badge(context, entry.displaySourceReference!),
                if (entry.collectionIds.isNotEmpty)
                  ...entry.collectionIds
                      .take(1)
                      .map((id) => _badge(context, _collectionTitleFor(id))),
                _badge(context, entry.grading),
                if (entry.quranConnections.isNotEmpty)
                  _badge(
                    context,
                    l10n.hadithPathQuranConnections(
                      entry.quranConnections.length,
                    ),
                  ),
                if (isReviewing && !isCompleted)
                  _badge(context, l10n.hadithBrowseProgressReviewing),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _collectionTitleFor(String id) {
    return collectionTitlesById[id] ?? id.replaceAll('_', ' ');
  }

  Widget _badge(BuildContext context, String text) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: context.palette.accent,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: style
          .decoration(radius: 999, includeShadow: false)
          .copyWith(
            border: Border.all(
              color: context.palette.accentSoft.withValues(alpha: 0.30),
            ),
          ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
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

Future<void> _shareCompactHadith(BuildContext context, HadithEntry entry) {
  final l10n = AppLocalizations.of(context);
  final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
  final text = HadithReaderShareService.buildCompactShareText(
    entry: entry,
    formattedReference: formattedReference,
  );
  return HadithReaderShareService.shareText(context, text);
}
