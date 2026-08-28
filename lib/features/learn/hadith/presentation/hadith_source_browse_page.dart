import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/expandable_tile.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/hadith_reader_share_service.dart';
import '../application/hadith_foundation_repository.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_source_browse_models.dart';
import 'hadith_reader_continuity.dart';
import 'hadith_reader_metadata.dart';

class HadithSourceBrowsePage extends ConsumerWidget {
  const HadithSourceBrowsePage({super.key, this.sourceId, this.chapterId});

  final String? sourceId;
  final String? chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sourceId == null || sourceId!.isEmpty) {
      return const _HadithSourceCollectionListPage();
    }
    if (chapterId == null || chapterId!.isEmpty) {
      return _HadithSourceCollectionDetailPage(sourceId: sourceId!);
    }
    return _HadithSourceChapterDetailPage(
      sourceId: sourceId!,
      chapterId: chapterId!,
    );
  }
}

class _HadithSourceCollectionListPage extends ConsumerWidget {
  const _HadithSourceCollectionListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final collections = ref.watch(hadithSourceBrowseCollectionsProvider);

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: l10n.hadithSourceBrowseTitle,
      subtitle: l10n.hadithSourceBrowseSubtitle,
      children: [
        if (collections.isEmpty)
          PremiumCard(child: Text(l10n.hadithSourceBrowseNoSources))
        else
          ...collections.map(
            (collection) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CompactListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: collection.title,
                subtitle: collection.hasChapters
                    ? l10n.hadithSourceBrowseCollectionSummary(
                        collection.entryCount,
                        collection.chapterCount,
                      )
                    : l10n.hadithSourceBrowseCollectionCountOnly(
                        collection.entryCount,
                      ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed(
                  'hadithSourceDetail',
                  pathParameters: {'sourceId': collection.id},
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HadithSourceCollectionDetailPage extends ConsumerWidget {
  const _HadithSourceCollectionDetailPage({required this.sourceId});

  final String sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final collection = ref.watch(
      hadithSourceBrowseCollectionByIdProvider(sourceId),
    );
    if (collection == null) {
      return AppPageScaffold(
        headerIcon: Icons.library_books_rounded,
        title: l10n.hadithSourceBrowseTitle,
        subtitle: l10n.hadithSourceBrowseNotFoundSubtitle,
        children: [
          PremiumCard(child: Text(l10n.hadithSourceBrowseNotFoundBody)),
        ],
      );
    }

    final chapters = ref.watch(hadithSourceBrowseChaptersProvider(sourceId));
    final entries = ref.watch(
      hadithEntriesForSourceCollectionProvider(sourceId),
    );
    final laneContext = chapters.isEmpty
        ? HadithReaderLaneContext(
            kind: HadithReaderLaneKind.sourceCollection,
            laneId: collection.id,
            laneTitle: collection.title,
            orderedLessonIds: entries
                .map((entry) => entry.id)
                .toList(growable: false),
            returnRouteName: 'hadithSourceDetail',
            returnPathParameters: {'sourceId': sourceId},
          )
        : null;

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: collection.title,
      subtitle: chapters.isEmpty
          ? l10n.hadithSourceBrowseCollectionCountOnly(collection.entryCount)
          : l10n.hadithSourceBrowseCollectionSummary(
              collection.entryCount,
              collection.chapterCount,
            ),
      bodySlivers: chapters.isEmpty
          ? [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverList.separated(
                  itemCount: entries.length,
                  itemBuilder: (context, index) => _HadithBrowseEntryTile(
                    entry: entries[index],
                    laneContext: laneContext,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
            ]
          : null,
      children: [
        if (chapters.isNotEmpty) ...[
          Text(
            l10n.hadithSourceBrowseChaptersTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...chapters.map(
            (chapter) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CompactListTile(
                title: chapterPrimaryLabel(chapter, l10n),
                subtitle: l10n.hadithSourceBrowseChapterSummary(
                  chapterSecondaryLabel(chapter, l10n),
                  chapter.entryCount,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed(
                  'hadithSourceChapterDetail',
                  pathParameters: {
                    'sourceId': sourceId,
                    'chapterId': chapter.id,
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          chapters.isEmpty
              ? l10n.hadithSourceBrowseEntriesTitle
              : l10n.hadithSourceBrowseEntryPreviewTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (chapters.isNotEmpty)
          ...entries
              .take(8)
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HadithBrowseEntryTile(
                    entry: entry,
                    laneContext: laneContext,
                  ),
                ),
              ),
      ],
    );
  }
}

class _HadithSourceChapterDetailPage extends ConsumerWidget {
  const _HadithSourceChapterDetailPage({
    required this.sourceId,
    required this.chapterId,
  });

  final String sourceId;
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final collection = ref.watch(
      hadithSourceBrowseCollectionByIdProvider(sourceId),
    );
    final chapter = ref.watch(
      hadithSourceBrowseChapterByIdProvider((
        sourceId: sourceId,
        chapterId: chapterId,
      )),
    );
    if (collection == null || chapter == null) {
      return AppPageScaffold(
        headerIcon: Icons.library_books_rounded,
        title: l10n.hadithSourceBrowseTitle,
        subtitle: l10n.hadithSourceBrowseNotFoundSubtitle,
        children: [
          PremiumCard(child: Text(l10n.hadithSourceBrowseNotFoundBody)),
        ],
      );
    }

    final entries = ref.watch(
      hadithEntriesForSourceChapterProvider((
        sourceId: sourceId,
        chapterId: chapterId,
      )),
    );
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.sourceChapter,
      laneId: '$sourceId:$chapterId',
      laneTitle: chapterPrimaryLabel(chapter, l10n),
      orderedLessonIds: entries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithSourceChapterDetail',
      returnPathParameters: {'sourceId': sourceId, 'chapterId': chapterId},
    );

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: chapterPrimaryLabel(chapter, l10n),
      subtitle: l10n.hadithSourceBrowseChapterPageSubtitle(
        collection.title,
        chapterSecondaryLabel(chapter, l10n),
        entries.length,
      ),
      bodySlivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList.separated(
            itemCount: entries.length,
            itemBuilder: (context, index) => _HadithBrowseEntryTile(
              entry: entries[index],
              laneContext: laneContext,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ],
      children: const [],
    );
  }
}

class _HadithBrowseEntryTile extends StatelessWidget {
  const _HadithBrowseEntryTile({required this.entry, this.laneContext});

  final HadithEntry entry;
  final HadithReaderLaneContext? laneContext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final narrator = entry.narrator?.trim();
    return ExpandableTile(
      title: Text(entry.title),
      subtitle: Text(
        l10n.hadithSourceBrowseEntrySubtitle(
          entry.displaySourceReference ?? entry.displaySourceCollectionTitle,
          entry.standardizedGrade.displayLabel,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (narrator != null && narrator.isNotEmpty) ...[
            Text(
              narrator,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            entry.displayEnglishText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _shareCompactHadith(context, entry),
                tooltip: l10n.hadithActionShare,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.share_outlined, size: 20),
              ),
              IconButton(
                onPressed: () => pushHadithLessonDetail(
                  context,
                  lessonId: entry.id,
                  laneContext: laneContext,
                ),
                tooltip: entry.title,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String chapterLabel(HadithSourceBrowseChapter chapter, AppLocalizations l10n) {
  switch (chapter.kind) {
    case HadithSourceBrowseChapterKind.general:
      return l10n.hadithSourceBrowseGeneralChapter;
    case HadithSourceBrowseChapterKind.uncategorized:
      return l10n.hadithSourceBrowseUncategorized;
    case HadithSourceBrowseChapterKind.canonical:
      if (chapter.number != null) {
        return l10n.hadithSourceBrowseChapterNumber(chapter.number!);
      }
      return chapter.title;
  }
}

String chapterPrimaryLabel(
  HadithSourceBrowseChapter chapter,
  AppLocalizations l10n,
) {
  if (chapter.kind == HadithSourceBrowseChapterKind.canonical &&
      chapter.number == null) {
    return chapter.title;
  }
  return chapterLabel(chapter, l10n);
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

String chapterSecondaryLabel(
  HadithSourceBrowseChapter chapter,
  AppLocalizations l10n,
) {
  if (chapter.kind != HadithSourceBrowseChapterKind.canonical) {
    return chapterLabel(chapter, l10n);
  }
  if (chapter.number != null && chapter.title.trim().isNotEmpty) {
    return chapter.title;
  }
  return chapterLabel(chapter, l10n);
}
