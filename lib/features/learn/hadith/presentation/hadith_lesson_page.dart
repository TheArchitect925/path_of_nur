import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../shared/presentation/learning_header.dart';
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

class HadithLessonPage extends ConsumerWidget {
  const HadithLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(hadithEntryByIdProvider(lessonId));
    if (entry == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: 'Hadith',
        subtitle: 'Content not found',
        children: const [
          PremiumCard(child: Text('The requested hadith could not be found.')),
        ],
      );
    }

    final theme = ref.watch(hadithThemeByIdProvider(entry.themeId));
    final savedNotifier = ref.read(hadithSavedIdsProvider.notifier);
    final isSaved = ref.watch(hadithSavedIdsProvider).contains(entry.id);
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

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: entry.title,
      subtitle: theme?.title ?? 'Hadith',
      children: [
        LearningHeader(
          title: entry.title,
          summary: entry.excerpt,
          chips: [
            entry.displaySourceCollection,
            if (entry.displaySourceReference != null)
              entry.displaySourceReference!,
            entry.grading,
            if (entry.narrator != null) entry.narrator!,
            if (theme != null) theme.title,
          ],
          trailing: IconButton(
            tooltip: isSaved ? 'Remove from saved' : 'Save hadith',
            onPressed: () => savedNotifier.toggle(entry.id),
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LearningSection(
          title: 'Hadith Text',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entry.arabicText != null) ...[
                Text(entry.arabicText!, textDirection: TextDirection.rtl),
                const SizedBox(height: 10),
              ] else ...[
                Text(
                  'Arabic matn will be added in a future content pass.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
              ],
              Text(entry.displayEnglishText),
            ],
          ),
        ),
        LearningSection(title: 'Meaning', body: entry.meaning),
        LearningSection(
          title: 'Qur’an Connection',
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
          title: 'Lessons',
          child: LearningLessons(
            items: entry.lessons
                .map((item) => LearningLessonItem(title: item))
                .toList(growable: false),
          ),
        ),
        LearningSection(
          title: 'Reflection',
          child: LearningReflection(prompts: entry.reflectionPrompts),
        ),
        LearningSection(
          title: 'Practice Action',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.practiceAction),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('journalCreate'),
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Add to Reflection Journal'),
              ),
              const SizedBox(height: 8),
              if (isCompletedInPaths)
                FilledButton.tonalIcon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Lesson Completed'),
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
                        ? 'Lesson completed • +$xp XP'
                        : 'Lesson already completed';
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
                  label: const Text('Mark Lesson Complete'),
                ),
            ],
          ),
        ),
        if (relatedEntries.isNotEmpty)
          LearningSection(
            title: 'Related Hadith',
            child: LearningRelatedContent(
              title: 'Related Hadith',
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
