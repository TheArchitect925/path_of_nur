import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../content_linking/application/editorial_relation_providers.dart';
import '../../../content_linking/application/contextual_linking_providers.dart';
import '../../../content_linking/domain/editorial_relation_models.dart';
import '../../../content_linking/presentation/editorial_relation_section.dart';
import '../../../content_linking/presentation/contextual_related_content_section.dart';
import '../../shared/presentation/learning_lessons.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_reflection.dart';
import '../../shared/presentation/learning_related_content.dart';
import '../../shared/presentation/learning_section.dart';
import '../../quran/application/quran_reference_graph_provider.dart';
import '../../quran/presentation/widgets/quran_reference_viewer.dart';
import '../application/hadith_foundation_repository.dart';
import '../application/hadith_learning_paths_service.dart';
import '../application/hadith_path_quiz_service.dart';
import '../application/hadith_reader_share_service.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_reader_metadata.dart';
import 'widgets/hadith_content_block.dart';

class HadithLessonPage extends ConsumerWidget {
  const HadithLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(hadithEntryByIdProvider(lessonId));
    if (entry == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: l10n.hadithPageTitle,
        subtitle: l10n.hadithLessonNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithLessonNotFoundBody))],
      );
    }

    final theme = ref.watch(hadithThemeByIdProvider(entry.themeId));
    final pathsProgress = ref.watch(hadithLearningPathsProgressProvider);
    final isCompletedInPaths = pathsProgress.completedLessonIds.contains(
      entry.id,
    );
    final relatedEntries = entry.relatedHadithIds
        .map((id) => ref.watch(hadithEntryByIdProvider(id)))
        .whereType<HadithEntry>()
        .toList(growable: false);
    final savedIds = ref.watch(hadithSavedIdsProvider);
    final isSaved = savedIds.contains(entry.id);
    final quranReferenceIds = ref.watch(
      quranReferenceIdsForHadithProvider(entry.id),
    );
    final editorialRelationsAsync = ref.watch(
      editorialResolvedLinksForNodeProvider(
        EditorialRelationContentRef.hadith(entry.id),
      ),
    );
    final contextualRelatedAsync = ref.watch(
      contextualLinksForHadithEntryProvider(entry.id),
    );
    final editorialQuranReferenceIds = editorialRelationsAsync.maybeWhen(
      data: (items) => items
          .where((item) => item.domain == EditorialRelationDomain.quran)
          .map((item) => item.referenceId)
          .whereType<String>()
          .toList(growable: false),
      orElse: () => const <String>[],
    );
    final relatedQuranReferenceIds = <String>{
      ...quranReferenceIds,
      ...editorialQuranReferenceIds,
    }.toList(growable: false);
    final editorialRelatedLinks = editorialRelationsAsync.maybeWhen(
      data: (items) => items
          .where((item) => item.domain != EditorialRelationDomain.quran)
          .toList(growable: false),
      orElse: () => const <EditorialResolvedRelationLink>[],
    );
    final editorialRelatedDuas = editorialRelatedLinks
        .where((item) => item.domain == EditorialRelationDomain.dua)
        .toList(growable: false);
    final editorialRelatedHadith = editorialRelatedLinks
        .where((item) => item.domain == EditorialRelationDomain.hadith)
        .toList(growable: false);
    final editorialRelatedLearn = editorialRelatedLinks
        .where(
          (item) =>
              item.domain == EditorialRelationDomain.learnContent ||
              item.domain == EditorialRelationDomain.worldCreation,
        )
        .toList(growable: false);
    final contextualRelatedLinks =
        contextualRelatedAsync.valueOrNull ?? const [];
    final hasMeaning = entry.meaning.trim().isNotEmpty;
    final hasLessons = entry.lessons.any((item) => item.trim().isNotEmpty);
    final hasReflectionPrompts = entry.reflectionPrompts.any(
      (item) => item.trim().isNotEmpty,
    );
    final hasPracticeAction = entry.practiceAction.trim().isNotEmpty;

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: entry.title,
      subtitle: theme?.title ?? l10n.hadithPageTitle,
      headerActions: [
        IconButton(
          tooltip: isSaved
              ? l10n.hadithActionRemoveSaved
              : l10n.hadithActionSave,
          onPressed: () =>
              _toggleHadithSaved(context, ref, entry, isSaved: isSaved),
          icon: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          ),
        ),
      ],
      children: [
        LearningSection(
          title: l10n.hadithSectionText,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HadithContentBlock(entry: entry),
              const SizedBox(height: 12),
              _HadithReaderActionRow(entry: entry, isSaved: isSaved),
            ],
          ),
        ),
        if (hasMeaning)
          LearningSection(
            title: l10n.hadithSectionMeaning,
            body: entry.meaning,
          ),
        if (hasLessons)
          LearningSection(
            title: l10n.hadithSectionLessons,
            child: LearningLessons(
              items: entry.lessons
                  .where((item) => item.trim().isNotEmpty)
                  .map((item) => LearningLessonItem(title: item))
                  .toList(growable: false),
            ),
          ),
        if (hasReflectionPrompts)
          LearningSection(
            title: l10n.hadithSectionReflection,
            child: LearningReflection(
              prompts: entry.reflectionPrompts
                  .where((item) => item.trim().isNotEmpty)
                  .toList(growable: false),
            ),
          ),
        LearningSection(
          title: l10n.hadithSectionQuranConnection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LearningReferences(
                items: entry.quranConnections
                    .map(
                      (connection) => LearningReferenceItem(
                        sourceTitle: connection.surahName,
                        sourceNumber: connection.surahNumber,
                        rangeOrSection: connection.verseRange,
                        label: connection.label,
                      ),
                    )
                    .toList(growable: false),
              ),
              if (relatedQuranReferenceIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: relatedQuranReferenceIds
                      .map(
                        (id) => QuranReferenceChip(
                          referenceId: id,
                          leading: const Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 8),
              ...entry.quranConnections.map((connection) {
                final range = _verseRangeFromConnection(connection);
                if (range == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: QuranReferenceBlock(
                    surahNumber: connection.surahNumber,
                    surahName: connection.surahName,
                    ayahStart: range.start,
                    ayahEnd: range.end,
                    dense: true,
                  ),
                );
              }),
              if (editorialQuranReferenceIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                EditorialRelationSection(
                  links: editorialRelationsAsync.maybeWhen(
                    data: (items) => items
                        .where(
                          (item) => item.domain == EditorialRelationDomain.quran,
                        )
                        .toList(growable: false),
                    orElse: () => const <EditorialResolvedRelationLink>[],
                  ),
                  maxItems: 3,
                  compact: true,
                ),
              ],
            ],
          ),
        ),
        if (hasPracticeAction || isCompletedInPaths)
          LearningSection(
            title: l10n.hadithSectionPracticeAction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasPracticeAction) ...[
                  Text(entry.practiceAction),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('journalCreate'),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Text(l10n.hadithActionAddToReflectionJournal),
                  ),
                  const SizedBox(height: 8),
                ],
                if (isCompletedInPaths)
                  FilledButton.tonalIcon(
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_rounded),
                    label: Text(l10n.hadithActionLessonCompleted),
                  )
                else
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final awarded = await completeHadithPathLesson(
                        ref,
                        entry.id,
                      );
                      if (!context.mounted) return;
                      final message = awarded
                          ? l10n.hadithLessonCompletedQuiet
                          : l10n.hadithLessonAlreadyCompleted;
                      if (awarded) {
                        ref
                            .read(hadithQuizReviewControllerProvider.notifier)
                            .registerLessonCompletion(entry.id);
                      }
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    },
                    icon: const Icon(Icons.task_alt_rounded),
                    label: Text(l10n.hadithActionMarkLessonComplete),
                  ),
              ],
            ),
          ),
        if (editorialRelatedDuas.isNotEmpty)
          LearningSection(
            title: l10n.hadithSectionRelatedDuas,
            child: EditorialRelationSection(
              links: editorialRelatedDuas,
              maxItems: 3,
            ),
          ),
        if (relatedEntries.isNotEmpty || editorialRelatedHadith.isNotEmpty)
          LearningSection(
            title: l10n.hadithSectionRelatedTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (relatedEntries.isNotEmpty)
                  LearningRelatedContent(
                    items: relatedEntries
                        .map(
                          (related) => LearningRelatedLink(
                            label: related.title,
                            onTap: () => context.pushNamed(
                              'hadithLessonDetail',
                              pathParameters: {'lessonId': related.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                if (relatedEntries.isNotEmpty &&
                    editorialRelatedHadith.isNotEmpty)
                  const SizedBox(height: 12),
                if (editorialRelatedHadith.isNotEmpty)
                  EditorialRelationSection(
                    links: editorialRelatedHadith,
                    maxItems: 3,
                  ),
              ],
            ),
          ),
        if (editorialRelatedLearn.isNotEmpty ||
            contextualRelatedLinks.isNotEmpty)
          LearningSection(
            title: l10n.contextualLinksRelatedTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (editorialRelatedLearn.isNotEmpty)
                  EditorialRelationSection(
                    links: editorialRelatedLearn,
                    maxItems: 3,
                  ),
                if (editorialRelatedLearn.isNotEmpty &&
                    contextualRelatedLinks.isNotEmpty)
                  const SizedBox(height: 12),
                if (contextualRelatedLinks.isNotEmpty)
                  ContextualRelatedContentSection(
                    items: contextualRelatedLinks,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HadithReaderActionRow extends ConsumerWidget {
  const _HadithReaderActionRow({required this.entry, required this.isSaved});

  final HadithEntry entry;
  final bool isSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.tonalIcon(
            onPressed: () =>
                _toggleHadithSaved(context, ref, entry, isSaved: isSaved),
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
            ),
            label: Text(
              isSaved ? l10n.hadithActionSaved : l10n.hadithActionSave,
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () => _copyHadithToClipboard(context, entry),
            icon: const Icon(Icons.copy_all_rounded),
            label: Text(l10n.hadithActionCopy),
          ),
          FilledButton.tonalIcon(
            onPressed: () => _shareHadith(context, entry),
            icon: const Icon(Icons.share_outlined),
            label: Text(l10n.hadithActionShare),
          ),
        ],
      ),
    );
  }
}

Future<void> _toggleHadithSaved(
  BuildContext context,
  WidgetRef ref,
  HadithEntry entry, {
  required bool isSaved,
}) async {
  await ref.read(hadithSavedIdsProvider.notifier).toggle(entry.id);
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  if (Scaffold.maybeOf(context) != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? l10n.hadithRemovedFromSaved : l10n.hadithAddedToSaved,
        ),
      ),
    );
  }
}

Future<void> _copyHadithToClipboard(
  BuildContext context,
  HadithEntry entry,
) async {
  final l10n = AppLocalizations.of(context);
  final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
  final text = HadithReaderShareService.buildShareText(
    entry: entry,
    sourceLabel: l10n.hadithSourceLabel,
    referenceLabel: l10n.hadithReferenceLabel,
    formattedReference: formattedReference,
    gradeLabel: l10n.hadithGradeShortLabel,
    narratorLabel: l10n.hadithNarratorLabel,
    translationLabel: l10n.hadithTranslationLabel,
  );
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  if (Scaffold.maybeOf(context) != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.hadithCopiedToClipboard)));
  }
}

Future<void> _shareHadith(BuildContext context, HadithEntry entry) {
  final l10n = AppLocalizations.of(context);
  final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
  final text = HadithReaderShareService.buildShareText(
    entry: entry,
    sourceLabel: l10n.hadithSourceLabel,
    referenceLabel: l10n.hadithReferenceLabel,
    formattedReference: formattedReference,
    gradeLabel: l10n.hadithGradeShortLabel,
    narratorLabel: l10n.hadithNarratorLabel,
    translationLabel: l10n.hadithTranslationLabel,
  );
  return HadithReaderShareService.shareText(text);
}

({int start, int end})? _verseRangeFromConnection(QuranConnection connection) {
  final raw = connection.verseRange.trim();
  if (raw.isEmpty) return null;
  final cleaned = raw.replaceAll('–', '-').replaceAll(' ', '');
  if (cleaned.contains('-')) {
    final parts = cleaned.split('-');
    if (parts.length != 2) return null;
    final start = int.tryParse(parts[0]);
    final end = int.tryParse(parts[1]);
    if (start == null || end == null) return null;
    return (start: start, end: end);
  }
  final single = int.tryParse(cleaned);
  if (single == null) return null;
  return (start: single, end: single);
}
