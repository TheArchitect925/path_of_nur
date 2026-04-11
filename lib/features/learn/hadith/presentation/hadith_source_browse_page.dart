import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/hadith_foundation_repository.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_source_browse_models.dart';

class HadithSourceBrowsePage extends ConsumerWidget {
  const HadithSourceBrowsePage({
    super.key,
    this.sourceId,
    this.chapterId,
  });

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
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(collection.title),
                  subtitle: Text(
                    collection.hasChapters
                        ? l10n.hadithSourceBrowseCollectionSummary(
                            collection.entryCount,
                            collection.chapterCount,
                          )
                        : l10n.hadithSourceBrowseCollectionCountOnly(
                            collection.entryCount,
                          ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed(
                    'hadithSourceDetail',
                    pathParameters: {'sourceId': collection.id},
                  ),
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
    final collection = ref.watch(hadithSourceBrowseCollectionByIdProvider(sourceId));
    if (collection == null) {
      return AppPageScaffold(
        headerIcon: Icons.library_books_rounded,
        title: l10n.hadithSourceBrowseTitle,
        subtitle: l10n.hadithSourceBrowseNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithSourceBrowseNotFoundBody))],
      );
    }

    final chapters = ref.watch(hadithSourceBrowseChaptersProvider(sourceId));
    final entries = ref.watch(hadithEntriesForSourceCollectionProvider(sourceId));

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: collection.title,
      subtitle: chapters.isEmpty
          ? l10n.hadithSourceBrowseCollectionCountOnly(collection.entryCount)
          : l10n.hadithSourceBrowseCollectionSummary(
              collection.entryCount,
              collection.chapterCount,
            ),
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
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(chapterPrimaryLabel(chapter, l10n)),
                  subtitle: Text(
                    l10n.hadithSourceBrowseChapterSummary(
                      chapterSecondaryLabel(chapter, l10n),
                      chapter.entryCount,
                    ),
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
        ...entries
            .take(chapters.isEmpty ? entries.length : 8)
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _HadithBrowseEntryTile(entry: entry),
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
    final collection = ref.watch(hadithSourceBrowseCollectionByIdProvider(sourceId));
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
        children: [PremiumCard(child: Text(l10n.hadithSourceBrowseNotFoundBody))],
      );
    }

    final entries = ref.watch(
      hadithEntriesForSourceChapterProvider((
        sourceId: sourceId,
        chapterId: chapterId,
      )),
    );

    return AppPageScaffold(
      headerIcon: Icons.library_books_rounded,
      title: chapterPrimaryLabel(chapter, l10n),
      subtitle: l10n.hadithSourceBrowseChapterPageSubtitle(
        collection.title,
        chapterSecondaryLabel(chapter, l10n),
        entries.length,
      ),
      children: [
        ...entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _HadithBrowseEntryTile(entry: entry),
          ),
        ),
      ],
    );
  }
}

class _HadithBrowseEntryTile extends StatelessWidget {
  const _HadithBrowseEntryTile({required this.entry});

  final HadithEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(entry.title),
        subtitle: Text(
          l10n.hadithSourceBrowseEntrySubtitle(
            entry.displaySourceReference ?? entry.displaySourceCollectionTitle,
            entry.standardizedGrade.displayLabel,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.pushNamed(
          'hadithLessonDetail',
          pathParameters: {'lessonId': entry.id},
        ),
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
