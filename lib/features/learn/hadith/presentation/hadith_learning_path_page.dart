import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_header.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_learning_paths_service.dart';
import '../application/hadith_path_quiz_service.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_learning_path.dart';

class HadithLearningPathPage extends ConsumerWidget {
  const HadithLearningPathPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(hadithLearningPathByIdProvider(pathId));
    if (path == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: 'Hadith Paths',
        subtitle: 'Path not found',
        children: const [
          PremiumCard(
            child: Text('The requested learning path was not found.'),
          ),
        ],
      );
    }

    final entries = ref.watch(hadithLearningPathEntriesProvider(path.id));
    final summary = ref.watch(hadithLearningPathProgressProvider(path.id));
    final progressState = ref.watch(hadithLearningPathsProgressProvider);
    final milestones = ref.watch(hadithPathMilestonesProvider(path.id));

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: path.title,
      subtitle: path.subtitle ?? 'Hadith Learning Path',
      children: [
        LearningHeader(
          title: path.title,
          summary: [
            if (path.subtitle != null && path.subtitle!.trim().isNotEmpty)
              path.subtitle!.trim(),
            path.description,
          ].join('\n\n'),
          chips: [
            '${entries.length} lessons',
            '${summary?.completedLessons ?? 0} completed',
          ],
        ),
        const SizedBox(height: 10),
        LearningSection(
          title: 'Progress',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${summary?.completedLessons ?? 0} / ${summary?.totalLessons ?? entries.length} completed',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: summary?.ratio ?? 0,
                  backgroundColor: AppColors.surface.withValues(alpha: 0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (milestones.isNotEmpty)
          LearningSection(
            title: 'Milestones',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: milestones
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: item.unlocked
                            ? AppColors.surface.withValues(alpha: 0.32)
                            : AppColors.surface.withValues(alpha: 0.18),
                        border: Border.all(
                          color: item.unlocked
                              ? AppColors.accentGoldSoft.withValues(alpha: 0.5)
                              : AppColors.accentGoldSoft.withValues(
                                  alpha: 0.24,
                                ),
                        ),
                      ),
                      child: Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: item.unlocked
                              ? AppColors.onSurface
                              : AppColors.onSurfaceSubtle,
                          fontWeight: item.unlocked
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        LearningSection(
          title: path.chapters.isEmpty ? 'Lessons' : 'Chapters',
          child: path.chapters.isEmpty
              ? _lessonList(
                  context: context,
                  path: path,
                  entries: entries,
                  progressState: progressState,
                )
              : _chapterList(
                  ref: ref,
                  context: context,
                  path: path,
                  entries: entries,
                  summary: summary,
                  progressState: progressState,
                ),
        ),
      ],
    );
  }

  Widget _chapterList({
    required WidgetRef ref,
    required BuildContext context,
    required HadithLearningPath path,
    required List<HadithEntry> entries,
    required HadithLearningPathProgressSummary? summary,
    required HadithLearningPathsProgressState progressState,
  }) {
    final entryById = {for (final entry in entries) entry.id: entry};
    return Column(
      children: path.chapters
          .map((chapter) {
            final chapterEntries = chapter.lessonIds
                .map((id) => entryById[id])
                .whereType<HadithEntry>()
                .toList(growable: false);
            final completedInChapter = chapter.lessonIds
                .where(progressState.completedLessonIds.contains)
                .length;
            final chapterDone =
                summary?.completedChapterIds.contains(chapter.id) ?? false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chapter.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Icon(
                          chapterDone
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: chapterDone
                              ? AppColors.onSurface
                              : AppColors.onSurfaceSubtle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(chapter.intro),
                    const SizedBox(height: 8),
                    Text(
                      '$completedInChapter / ${chapter.lessonIds.length} lessons',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: chapter.lessonIds.isEmpty
                            ? 0
                            : (completedInChapter / chapter.lessonIds.length)
                                  .clamp(0.0, 1.0),
                        backgroundColor: AppColors.surface.withValues(
                          alpha: 0.4,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.onSurface.withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...chapterEntries.asMap().entries.map((pair) {
                      final index = pair.key;
                      final entry = pair.value;
                      final globalIndex = path.lessonIds.indexOf(entry.id);
                      final unlocked = isPathLessonUnlocked(
                        path,
                        progressState.completedLessonIds,
                        entry.id,
                      );
                      final completed = progressState.completedLessonIds
                          .contains(entry.id);
                      final nextTeaser = _nextLessonTeaser(
                        path,
                        entries,
                        globalIndex,
                      );
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == chapterEntries.length - 1 ? 0 : 8,
                        ),
                        child: _lessonTile(
                          context: context,
                          entry: entry,
                          completed: completed,
                          unlocked: unlocked,
                          nextTeaser: nextTeaser,
                        ),
                      );
                    }),
                    if (chapter.hasReviewShell) ...[
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) {
                          final status = ref.watch(
                            hadithChapterQuizStatusProvider((
                              pathId: path.id,
                              chapterId: chapter.id,
                            )),
                          );
                          if (status.quiz == null) {
                            return const SizedBox.shrink();
                          }

                          if (!status.unlocked) {
                            return OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.lock_outline_rounded),
                              label: const Text(
                                'Complete all chapter lessons to unlock quiz',
                              ),
                            );
                          }

                          final scoreText = status.lastScore == null
                              ? ''
                              : ' • Last score: ${status.lastScore}/${status.quiz!.questions.length}';

                          return FilledButton.tonalIcon(
                            onPressed: () => context.pushNamed(
                              'hadithChapterQuiz',
                              pathParameters: {
                                'pathId': path.id,
                                'chapterId': chapter.id,
                              },
                            ),
                            icon: Icon(
                              status.completed
                                  ? Icons.replay_rounded
                                  : Icons.quiz_rounded,
                            ),
                            label: Text(
                              status.completed
                                  ? 'Retake Chapter Quiz$scoreText'
                                  : 'Start Chapter Quiz',
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _lessonList({
    required BuildContext context,
    required HadithLearningPath path,
    required List<HadithEntry> entries,
    required HadithLearningPathsProgressState progressState,
  }) {
    return Column(
      children: entries
          .asMap()
          .entries
          .map((pair) {
            final index = pair.key;
            final entry = pair.value;
            final completed = progressState.completedLessonIds.contains(
              entry.id,
            );
            final unlocked = isPathLessonUnlocked(
              path,
              progressState.completedLessonIds,
              entry.id,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _lessonTile(
                context: context,
                entry: entry,
                completed: completed,
                unlocked: unlocked,
                nextTeaser: _nextLessonTeaser(path, entries, index),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _lessonTile({
    required BuildContext context,
    required HadithEntry entry,
    required bool completed,
    required bool unlocked,
    required String? nextTeaser,
  }) {
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(entry.title),
        subtitle: Text(
          '${entry.displaySourceCollection} • ${entry.grading}\n'
          'Qur’an connections: ${entry.quranConnections.length}'
          '${nextTeaser == null ? '' : '\nNext: $nextTeaser'}',
        ),
        trailing: Icon(
          completed
              ? Icons.check_circle_rounded
              : (unlocked
                    ? Icons.chevron_right_rounded
                    : Icons.lock_outline_rounded),
          color: completed ? AppColors.onSurface : AppColors.onSurfaceSubtle,
        ),
        onTap: unlocked
            ? () => context.pushNamed(
                'hadithLessonDetail',
                pathParameters: {'lessonId': entry.id},
              )
            : null,
      ),
    );
  }

  String? _nextLessonTeaser(
    HadithLearningPath path,
    List<HadithEntry> entries,
    int currentIndex,
  ) {
    if (currentIndex < 0 || currentIndex >= path.lessonIds.length - 1) {
      return null;
    }
    final nextId = path.lessonIds[currentIndex + 1];
    final nextEntry = entries.where((entry) => entry.id == nextId).firstOrNull;
    return nextEntry?.title;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
