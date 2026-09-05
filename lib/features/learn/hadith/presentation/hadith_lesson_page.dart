import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/app_transient_feedback.dart';
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
import '../application/hadith_narrator_repository.dart';
import '../application/hadith_path_quiz_service.dart';
import '../application/hadith_reading_status_service.dart';
import '../application/hadith_reader_settings_service.dart';
import '../application/hadith_reader_share_service.dart';
import '../domain/hadith_foundation_models.dart';
import 'hadith_reader_continuity.dart';
import 'hadith_reader_metadata.dart';
import 'widgets/hadith_content_block.dart';

class HadithLessonPage extends ConsumerStatefulWidget {
  const HadithLessonPage({super.key, required this.lessonId, this.laneContext});

  final String lessonId;
  final HadithReaderLaneContext? laneContext;

  @override
  ConsumerState<HadithLessonPage> createState() => _HadithLessonPageState();
}

class _HadithLessonPageState extends ConsumerState<HadithLessonPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (!mounted) return;
      ref
          .read(hadithReadingStatusProvider.notifier)
          .markOpened(widget.lessonId);
    });
  }

  @override
  void didUpdateWidget(covariant HadithLessonPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      Future<void>.microtask(() {
        if (!mounted) return;
        ref
            .read(hadithReadingStatusProvider.notifier)
            .markOpened(widget.lessonId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(hadithEntryByIdProvider(widget.lessonId));
    if (entry == null) {
      return AppPageScaffold(
        title: l10n.hadithPageTitle,
        children: [PremiumCard(child: Text(l10n.hadithLessonNotFoundBody))],
      );
    }

    final pathsProgress = ref.watch(hadithLearningPathsProgressProvider);
    final readingStatus = ref.watch(hadithReadingStatusProvider);
    final readerSettings = ref.watch(hadithReaderSettingsProvider);
    final isCompletedInPaths = pathsProgress.completedLessonIds.contains(
      entry.id,
    );
    final isCompletedForBrowse = readingStatus.isCompleted(entry.id);
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
    final continuity = _HadithReaderContinuityState.resolve(
      lessonId: entry.id,
      laneContext: widget.laneContext,
    );
    final sourceId = entry.primarySourceCollectionId;
    final sourceChapterId = entry.normalizedSourceChapterId;
    final narratorId = resolveHadithNarratorId(entry.narrator);
    final sourceChapterEntries = sourceId == null || sourceChapterId == null
        ? null
        : ref.watch(
            hadithEntriesForSourceChapterProvider((
              sourceId: sourceId,
              chapterId: sourceChapterId,
            )),
          );
    final chapterPositionText = sourceChapterEntries == null
        ? null
        : formatHadithChapterPositionForDisplay(
            l10n,
            current:
                sourceChapterEntries.indexWhere((item) => item.id == entry.id) +
                1,
            total: sourceChapterEntries.length,
          );

    return AppPageScaffold(
      title: entry.title,
      headerActions: [
        IconButton(
          tooltip: l10n.hadithReaderDisplaySettingsAction,
          onPressed: () => _showReaderSettingsSheet(context),
          icon: const Icon(Icons.tune_rounded),
        ),
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
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HadithReaderTaxonomyChips(entry: entry),
              if (entry.hasCanonicalCategoryMetadata ||
                  entry.hasCanonicalSubcategoryMetadata)
                const SizedBox(height: 12),
              HadithContentBlock(
                entry: entry,
                wrapInCard: false,
                showArabic: readerSettings.showArabic,
                showTransliteration: readerSettings.showTransliteration,
                showTranslation: readerSettings.showTranslation,
                onTapSource: sourceId == null
                    ? null
                    : () => context.pushNamed(
                        'hadithSourceDetail',
                        pathParameters: {'sourceId': sourceId},
                      ),
                onTapChapter: sourceId == null || sourceChapterId == null
                    ? null
                    : () => context.pushNamed(
                        'hadithSourceChapterDetail',
                        pathParameters: {
                          'sourceId': sourceId,
                          'chapterId': sourceChapterId,
                        },
                      ),
                onTapGrade: () => _showGradeInfoSheet(context, entry),
                onTapNarrator: narratorId == null
                    ? null
                    : () => context.pushNamed(
                        'hadithNarratorDetail',
                        pathParameters: {'narratorId': narratorId},
                      ),
                onTapProvenance: () => _showProvenanceInfoSheet(context, entry),
                chapterSupportingText: chapterPositionText,
              ),
              const SizedBox(height: 12),
              _HadithReaderActionRow(
                entry: entry,
                isSaved: isSaved,
                isCompletedForBrowse: isCompletedForBrowse,
              ),
              if (continuity != null) ...[
                const SizedBox(height: 12),
                _HadithReaderContinuityCard(
                  continuity: continuity,
                  onReturnToLane: () =>
                      _returnToLane(context, continuity.laneContext),
                  onOpenPrevious: continuity.previousLessonId == null
                      ? null
                      : () => replaceHadithLessonDetail(
                          context,
                          lessonId: continuity.previousLessonId!,
                          laneContext: continuity.laneContext,
                        ),
                  onOpenNext: continuity.nextLessonId == null
                      ? null
                      : () => replaceHadithLessonDetail(
                          context,
                          lessonId: continuity.nextLessonId!,
                          laneContext: continuity.laneContext,
                        ),
                ),
              ],
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
                          (item) =>
                              item.domain == EditorialRelationDomain.quran,
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
                      AppTransientFeedback.showSuccess(context, message);
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

  void _showReaderSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, child) {
            final l10n = AppLocalizations.of(context);
            final settings = ref.watch(hadithReaderSettingsProvider);
            final settingsNotifier = ref.read(
              hadithReaderSettingsProvider.notifier,
            );
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hadithReaderDisplaySettingsTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.hadithReaderDisplaySettingsSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: settings.showArabic,
                      title: Text(l10n.quranShowArabic),
                      onChanged: settingsNotifier.setShowArabic,
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: settings.showTransliteration,
                      title: Text(l10n.quranShowTransliteration),
                      onChanged: settingsNotifier.setShowTransliteration,
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: settings.showTranslation,
                      title: Text(l10n.quranShowTranslation),
                      onChanged: settingsNotifier.setShowTranslation,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGradeInfoSheet(BuildContext context, HadithEntry entry) {
    final l10n = AppLocalizations.of(context);
    final currentGrade = entry.standardizedGrade;
    final items = <_HadithGradeInfoItem>[
      _HadithGradeInfoItem(
        label: 'Muttafaqun Alayh',
        description: l10n.hadithGradeInfoMuttafaqunAlayh,
        isCurrent: currentGrade.category == HadithGradeCategory.muttafaqunAlayh,
      ),
      _HadithGradeInfoItem(
        label: 'Sahih',
        description: l10n.hadithGradeInfoSahih,
        isCurrent: currentGrade.category == HadithGradeCategory.sahih,
      ),
      _HadithGradeInfoItem(
        label: 'Hasan Sahih',
        description: l10n.hadithGradeInfoHasanSahih,
        isCurrent: currentGrade.category == HadithGradeCategory.hasanSahih,
      ),
      _HadithGradeInfoItem(
        label: 'Hasan',
        description: l10n.hadithGradeInfoHasan,
        isCurrent: currentGrade.category == HadithGradeCategory.hasan,
      ),
      _HadithGradeInfoItem(
        label: 'Weak',
        description: l10n.hadithGradeInfoWeak,
        isCurrent: currentGrade.category == HadithGradeCategory.weak,
      ),
      _HadithGradeInfoItem(
        label: 'Balagh',
        description: l10n.hadithGradeInfoBalagh,
        isCurrent: currentGrade.category == HadithGradeCategory.balagh,
      ),
      _HadithGradeInfoItem(
        label: currentGrade.displayLabel.isEmpty
            ? l10n.hadithGradeInfoOtherTitle
            : currentGrade.displayLabel,
        description: l10n.hadithGradeInfoOther,
        isCurrent:
            currentGrade.category == HadithGradeCategory.other ||
            currentGrade.category == HadithGradeCategory.unknown,
      ),
    ];

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hadithGradeInfoTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.hadithGradeInfoSubtitle(currentGrade.displayLabel),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.hadithGradeInfoDisclaimer,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: item.isCurrent
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.10)
                              : Colors.white.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: item.isCurrent
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0x14000000),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                if (item.isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      l10n.hadithGradeInfoCurrentBadge,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProvenanceInfoSheet(BuildContext context, HadithEntry entry) {
    final l10n = AppLocalizations.of(context);
    final formattedChapter = formatHadithSourceChapterForDisplay(l10n, entry);
    final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
    final provenance = formatHadithSourceProvenanceForDisplay(l10n, entry);
    final importSource = formatHadithImportSourceForDisplay(l10n, entry);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hadithProvenanceInfoTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.hadithProvenanceInfoBody,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _HadithInfoLine(
                  label: l10n.hadithSourceLabel,
                  value: entry.displaySourceCollectionTitle,
                ),
                if (formattedChapter.isNotEmpty)
                  _HadithInfoLine(
                    label: l10n.hadithSourceChapterLabel,
                    value: formattedChapter,
                  ),
                if (formattedReference.isNotEmpty)
                  _HadithInfoLine(
                    label: l10n.hadithReferenceLabel,
                    value: formattedReference,
                  ),
                if (entry.standardizedGrade.displayLabel.trim().isNotEmpty)
                  _HadithInfoLine(
                    label: l10n.hadithGradeShortLabel,
                    value: entry.standardizedGrade.displayLabel.trim(),
                  ),
                const SizedBox(height: 8),
                Text(
                  l10n.hadithProvenanceInfoStatusTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(provenance, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(
                  l10n.hadithProvenanceInfoPipelineBody,
                  style: theme.textTheme.bodySmall,
                ),
                if (importSource != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    importSource,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HadithGradeInfoItem {
  const _HadithGradeInfoItem({
    required this.label,
    required this.description,
    required this.isCurrent,
  });

  final String label;
  final String description;
  final bool isCurrent;
}

class _HadithInfoLine extends StatelessWidget {
  const _HadithInfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HadithReaderTaxonomyChips extends StatelessWidget {
  const _HadithReaderTaxonomyChips({required this.entry});

  final HadithEntry entry;

  @override
  Widget build(BuildContext context) {
    final categoryTitle = entry.displayCategoryTitle;
    final subcategoryTitle = entry.displaySubcategoryTitle;
    final subcategoryId = entry.normalizedSubcategoryId;

    if (categoryTitle == null && subcategoryTitle == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (categoryTitle != null)
          Chip(
            avatar: const Icon(Icons.category_rounded, size: 18),
            label: Text(categoryTitle),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (subcategoryTitle != null)
          ActionChip(
            avatar: const Icon(Icons.sell_rounded, size: 18),
            label: Text(subcategoryTitle),
            onPressed: subcategoryId == null
                ? null
                : () => context.pushNamed(
                    'hadithSubcategoryDetail',
                    pathParameters: {'subcategoryId': subcategoryId},
                  ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }
}

class _HadithReaderContinuityState {
  const _HadithReaderContinuityState({
    required this.laneContext,
    required this.currentIndex,
    required this.previousLessonId,
    required this.nextLessonId,
  });

  final HadithReaderLaneContext laneContext;
  final int currentIndex;
  final String? previousLessonId;
  final String? nextLessonId;

  int get totalCount => laneContext.orderedLessonIds.length;
  bool get showsPosition => currentIndex >= 0 && totalCount > 0;

  static _HadithReaderContinuityState? resolve({
    required String lessonId,
    required HadithReaderLaneContext? laneContext,
  }) {
    if (laneContext == null) return null;
    final currentIndex = laneContext.indexOfLesson(lessonId);
    final previousLessonId = laneContext.previousLessonId(lessonId);
    final nextLessonId = laneContext.nextLessonId(lessonId);
    final hasBackAction = laneContext.returnRouteName.trim().isNotEmpty;
    if (!hasBackAction &&
        previousLessonId == null &&
        nextLessonId == null &&
        currentIndex < 0) {
      return null;
    }
    return _HadithReaderContinuityState(
      laneContext: laneContext,
      currentIndex: currentIndex,
      previousLessonId: previousLessonId,
      nextLessonId: nextLessonId,
    );
  }
}

class _HadithReaderContinuityCard extends StatelessWidget {
  const _HadithReaderContinuityCard({
    required this.continuity,
    required this.onReturnToLane,
    required this.onOpenPrevious,
    required this.onOpenNext,
  });

  final _HadithReaderContinuityState continuity;
  final VoidCallback onReturnToLane;
  final VoidCallback? onOpenPrevious;
  final VoidCallback? onOpenNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final laneContext = continuity.laneContext;
    final backLabel =
        laneContext.backLabelOverride ??
        l10n.hadithReaderBackToLane(laneContext.laneTitle);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hadithReaderContinueTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            laneContext.laneTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (continuity.showsPosition) ...[
            const SizedBox(height: 4),
            Text(
              l10n.hadithReaderPosition(
                continuity.currentIndex + 1,
                continuity.totalCount,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onReturnToLane,
                icon: const Icon(Icons.reply_rounded),
                label: Text(backLabel),
              ),
              if (laneContext.supportsSequence)
                FilledButton.tonalIcon(
                  onPressed: onOpenPrevious,
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: Text(l10n.hadithReaderPrevious),
                ),
              if (laneContext.supportsSequence)
                FilledButton.tonalIcon(
                  onPressed: onOpenNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: Text(l10n.hadithReaderNext),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HadithReaderActionRow extends ConsumerWidget {
  const _HadithReaderActionRow({
    required this.entry,
    required this.isSaved,
    required this.isCompletedForBrowse,
  });

  final HadithEntry entry;
  final bool isSaved;
  final bool isCompletedForBrowse;

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
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_rounded,
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
            icon: const Icon(Icons.share_rounded),
            label: Text(l10n.hadithActionShare),
          ),
          FilledButton.tonalIcon(
            onPressed: () => _toggleHadithCompleted(
              context,
              ref,
              entry,
              isCompleted: isCompletedForBrowse,
            ),
            icon: Icon(
              isCompletedForBrowse
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
            ),
            label: Text(
              isCompletedForBrowse
                  ? l10n.hadithActionCompletedForBrowse
                  : l10n.hadithActionMarkCompleteForBrowse,
            ),
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
  AppTransientFeedback.showSuccess(
    context,
    isSaved ? l10n.hadithRemovedFromSaved : l10n.hadithAddedToSaved,
  );
}

Future<void> _toggleHadithCompleted(
  BuildContext context,
  WidgetRef ref,
  HadithEntry entry, {
  required bool isCompleted,
}) async {
  ref.read(hadithReadingStatusProvider.notifier).toggleCompleted(entry.id);
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  AppTransientFeedback.showSuccess(
    context,
    isCompleted ? l10n.hadithMarkedIncomplete : l10n.hadithMarkedComplete,
  );
}

Future<void> _copyHadithToClipboard(
  BuildContext context,
  HadithEntry entry,
) async {
  final l10n = AppLocalizations.of(context);
  final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
  final text = HadithReaderShareService.buildReaderShareText(
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
  AppTransientFeedback.showSuccess(context, l10n.hadithCopiedToClipboard);
}

Future<void> _shareHadith(BuildContext context, HadithEntry entry) {
  final l10n = AppLocalizations.of(context);
  final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
  final text = HadithReaderShareService.buildReaderShareText(
    entry: entry,
    sourceLabel: l10n.hadithSourceLabel,
    referenceLabel: l10n.hadithReferenceLabel,
    formattedReference: formattedReference,
    gradeLabel: l10n.hadithGradeShortLabel,
    narratorLabel: l10n.hadithNarratorLabel,
    translationLabel: l10n.hadithTranslationLabel,
  );
  return HadithReaderShareService.shareText(context, text);
}

void _returnToLane(BuildContext context, HadithReaderLaneContext laneContext) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).maybePop();
    return;
  }

  context.goNamed(
    laneContext.returnRouteName,
    pathParameters: laneContext.returnPathParameters,
    queryParameters: laneContext.returnQueryParameters,
  );
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
