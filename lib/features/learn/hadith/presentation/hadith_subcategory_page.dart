import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_expandable_section.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_reader_continuity.dart';
import 'widgets/hadith_browse_helpers.dart';

class HadithCollectionPage extends ConsumerStatefulWidget {
  const HadithCollectionPage({super.key, required this.collectionId});

  final String collectionId;

  @override
  ConsumerState<HadithCollectionPage> createState() =>
      _HadithCollectionPageState();
}

@Deprecated('Use HadithCollectionPage instead.')
class HadithSubcategoryPage extends HadithCollectionPage {
  const HadithSubcategoryPage({super.key, required String subcategoryId})
    : super(collectionId: subcategoryId);
}

class _HadithCollectionPageState extends ConsumerState<HadithCollectionPage> {
  HadithBrowseFilterState _filterState = const HadithBrowseFilterState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final collection = ref.watch(
      hadithCollectionBrowseSummaryByIdProvider(widget.collectionId),
    );
    if (collection == null) {
      return AppPageScaffold(
        headerIcon: Icons.collections_bookmark_rounded,
        title: l10n.hadithCollectionPageTitle,
        subtitle: l10n.hadithCollectionNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithCollectionNotFoundBody))],
      );
    }

    final entries = ref.watch(
      hadithEntriesForCollectionProvider(collection.id),
    );
    final quranAnchors = entries
        .expand((entry) => entry.quranConnections)
        .take(4)
        .toList(growable: false);
    final sourceOptions = hadithBrowseSourceOptions(entries);
    final gradeOptions = hadithBrowseGradeOptions(entries);
    final subcategoryOptions = collection.subcategories
        .map(
          (item) =>
              HadithBrowseSubcategoryOption(id: item.id, title: item.title),
        )
        .toList(growable: false);
    final visibleEntries = applyHadithBrowseFilters(
      entries: entries,
      state: _filterState,
    );
    final quickStartEntries =
        shouldShowHadithBrowseQuickStart(
          visibleEntries: visibleEntries,
          state: _filterState,
        )
        ? visibleEntries.take(4).toList(growable: false)
        : const <HadithEntry>[];
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.collection,
      laneId: collection.id,
      laneTitle: collection.title,
      orderedLessonIds: visibleEntries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithCollectionDetail',
      returnPathParameters: {'collectionId': collection.id},
    );

    return AppPageScaffold(
      headerIcon: Icons.collections_bookmark_rounded,
      title: collection.title,
      subtitle: collection.subtitle,
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
                  child: PremiumCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.title),
                      subtitle: Text(
                        l10n.hadithCollectionEntrySubtitle(
                          entry.source,
                          entry.grading,
                        ),
                      ),
                      onTap: () => pushHadithLessonDetail(
                        context,
                        lessonId: entry.id,
                        laneContext: laneContext,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
      children: [
        PremiumCard(child: Text(collection.description)),
        if (quranAnchors.isNotEmpty)
          LearningExpandableSection(
            title: l10n.hadithSectionRelatedVerses,
            child: LearningReferences(
              items: quranAnchors
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
        if (collection.subcategories.isNotEmpty)
          LearningSection(
            title: l10n.hadithCollectionSubcategoriesTitle,
            child: Column(
              children: collection.subcategories
                  .map(
                    (subcategory) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(subcategory.title),
                          subtitle: Text(
                            l10n.hadithCollectionSubcategoryCount(
                              subcategory.entryCount,
                            ),
                          ),
                        ),
                      ),
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
            sourceOptions: sourceOptions,
            gradeOptions: gradeOptions,
            subcategoryOptions: subcategoryOptions,
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
