import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_expandable_section.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';
import '../application/hadith_reading_status_service.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_reader_continuity.dart';
import 'widgets/hadith_browse_helpers.dart';

class HadithThemePage extends ConsumerStatefulWidget {
  const HadithThemePage({super.key, required this.themeId});

  final String themeId;

  @override
  ConsumerState<HadithThemePage> createState() => _HadithThemePageState();
}

class _HadithThemePageState extends ConsumerState<HadithThemePage> {
  HadithBrowseFilterState _filterState = const HadithBrowseFilterState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = ref.watch(hadithThemeByIdProvider(widget.themeId));
    if (theme == null) {
      return AppPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: l10n.hadithPageTitle,
        subtitle: l10n.hadithThemeNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithThemeNotFoundBody))],
      );
    }

    final entries = ref.watch(hadithEntriesForThemeProvider(theme.id));
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final savedNotifier = ref.read(hadithSavedIdsProvider.notifier);
    final readingStatus = ref.watch(hadithReadingStatusProvider);
    final readingStatusNotifier = ref.read(
      hadithReadingStatusProvider.notifier,
    );
    final sourceOptions = hadithBrowseSourceOptions(entries);
    final gradeOptions = hadithBrowseGradeOptions(entries);
    final subcategoryOptions = hadithBrowseSubcategoryOptions(entries);
    final visibleEntries = applyHadithBrowseFilters(
      entries: entries,
      state: _filterState,
      openedLessonIds: readingStatus.openedLessonIds,
      completedLessonIds: readingStatus.completedLessonIds,
    );
    final quickStartEntries =
        shouldShowHadithBrowseQuickStart(
          visibleEntries: visibleEntries,
          state: _filterState,
        )
        ? visibleEntries.take(4).toList(growable: false)
        : const <HadithEntry>[];
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.theme,
      laneId: theme.id,
      laneTitle: theme.title,
      orderedLessonIds: visibleEntries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithThemeDetail',
      returnPathParameters: {'themeId': theme.id},
    );

    return AppPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: theme.title,
      subtitle: theme.subtitle,
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
                  child: _HadithPreviewCard(
                    entryId: entry.id,
                    title: entry.title,
                    previewText: hadithCardPreviewText(entry),
                    sourceCollection: entry.displaySourceCollection,
                    sourceReference: entry.displaySourceReference,
                    grading: entry.grading,
                    quranConnectionCount: entry.quranConnections.length,
                    tags: entry.tags,
                    isSaved: savedIds.contains(entry.id),
                    isCompleted: readingStatus.isCompleted(entry.id),
                    isReviewing: readingStatus.isReviewing(entry.id),
                    onToggleSaved: () => savedNotifier.toggle(entry.id),
                    onToggleCompleted: () =>
                        readingStatusNotifier.toggleCompleted(entry.id),
                    laneContext: laneContext,
                  ),
                );
              },
            ),
          ),
      ],
      children: [
        PremiumCard(child: Text(theme.description)),
        LearningExpandableSection(
          title: l10n.hadithSectionRelatedQuranAnchors,
          child: LearningReferences(
            items: theme.quranAnchors
                .map(
                  (anchor) => LearningReferenceItem(
                    sourceTitle: anchor.surahName,
                    sourceNumber: anchor.surahNumber,
                    rangeOrSection: anchor.verseRange,
                    label: anchor.label,
                  ),
                )
                .toList(growable: false),
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
            gradeOptions: gradeOptions,
            subcategoryOptions: subcategoryOptions,
            showProgressFilter: true,
          ),
        ),
        if (quickStartEntries.isNotEmpty)
          LearningSection(
            title: l10n.hadithBrowseQuickStartTitle,
            child: Column(
              children: quickStartEntries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HadithBrowseQuickPickTile(
                        entry: entry,
                        onTap: () => pushHadithLessonDetail(
                          context,
                          lessonId: entry.id,
                          laneContext: laneContext,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
      ],
    );
  }
}

class _HadithPreviewCard extends StatelessWidget {
  const _HadithPreviewCard({
    required this.entryId,
    required this.title,
    required this.previewText,
    required this.sourceCollection,
    required this.sourceReference,
    required this.grading,
    required this.quranConnectionCount,
    required this.tags,
    required this.isSaved,
    required this.isCompleted,
    required this.isReviewing,
    required this.onToggleSaved,
    required this.onToggleCompleted,
    required this.laneContext,
  });

  final String entryId;
  final String title;
  final String previewText;
  final String sourceCollection;
  final String? sourceReference;
  final String grading;
  final int quranConnectionCount;
  final List<String> tags;
  final bool isSaved;
  final bool isCompleted;
  final bool isReviewing;
  final VoidCallback onToggleSaved;
  final VoidCallback onToggleCompleted;
  final HadithReaderLaneContext laneContext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => pushHadithLessonDetail(
        context,
        lessonId: entryId,
        laneContext: laneContext,
      ),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
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
            Text(
              previewText,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _badge(context, sourceCollection),
                if (sourceReference != null) _badge(context, sourceReference!),
                _badge(context, grading),
                if (quranConnectionCount > 0)
                  _badge(
                    context,
                    l10n.hadithPathQuranConnections(quranConnectionCount),
                  ),
                if (isReviewing && !isCompleted)
                  _badge(context, l10n.hadithBrowseProgressReviewing),
                ...tags.take(3).map((tag) => _badge(context, tag)),
              ],
            ),
          ],
        ),
      ),
    );
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
