import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../content_linking/application/contextual_linking_providers.dart';
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
import '../../../journey/application/journey_progression_provider.dart';
import '../domain/hadith_foundation_models.dart';
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
    final quranReferenceIds = ref.watch(
      quranReferenceIdsForHadithProvider(entry.id),
    );
    final contextualRelatedAsync = ref.watch(
      contextualLinksForHadithEntryProvider(entry.id),
    );

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: entry.title,
      subtitle: theme?.title ?? l10n.hadithPageTitle,
      children: [
        LearningSection(
          title: l10n.hadithSectionText,
          child: HadithContentBlock(entry: entry),
        ),
        LearningSection(title: l10n.hadithSectionMeaning, body: entry.meaning),
        LearningSection(
          title: l10n.hadithSectionLessons,
          child: LearningLessons(
            items: entry.lessons
                .map((item) => LearningLessonItem(title: item))
                .toList(growable: false),
          ),
        ),
        LearningSection(
          title: l10n.hadithSectionReflection,
          child: LearningReflection(prompts: entry.reflectionPrompts),
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
              if (quranReferenceIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: quranReferenceIds
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
            ],
          ),
        ),
        LearningSection(
          title: l10n.hadithSectionPracticeAction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.practiceAction),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('journalCreate'),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l10n.hadithActionAddToReflectionJournal),
              ),
              const SizedBox(height: 8),
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
                    final xp = JourneyXpRules.xpPerReflectionEntry;
                    final message = awarded
                        ? l10n.hadithLessonCompletedXp(xp)
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
        if (relatedEntries.isNotEmpty)
          LearningSection(
            title: l10n.hadithSectionRelatedTitle,
            child: LearningRelatedContent(
              title: l10n.hadithSectionRelatedTitle,
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
          ),
        if (contextualRelatedAsync case AsyncData(:final value)
            when value.isNotEmpty)
          LearningSection(
            title: l10n.contextualLinksRelatedTitle,
            child: ContextualRelatedContentSection(items: value),
          ),
      ],
    );
  }
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
