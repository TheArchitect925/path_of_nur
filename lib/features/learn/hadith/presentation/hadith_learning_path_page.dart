import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_learning_paths_service.dart';
import '../application/hadith_path_quiz_service.dart';
import '../domain/hadith_foundation_models.dart';
import '../domain/hadith_learning_path.dart';
import 'hadith_reader_continuity.dart';

class HadithLearningPathPage extends ConsumerWidget {
  const HadithLearningPathPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final path = ref.watch(hadithLearningPathByIdProvider(pathId));
    if (path == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.hadithPathPageTitle,
        subtitle: l10n.hadithPathNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithPathNotFoundBody))],
      );
    }

    final entries = ref.watch(hadithLearningPathEntriesProvider(path.id));
    final summary = ref.watch(hadithLearningPathProgressProvider(path.id));
    final progressState = ref.watch(hadithLearningPathsProgressProvider);
    final milestones = ref.watch(hadithPathMilestonesProvider(path.id));

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: path.title,
      subtitle: path.subtitle ?? l10n.hadithPathDefaultSubtitle,
      children: [
        LearningSection(
          title: l10n.hadithPathProgressTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hadithPathProgressSummary(
                  summary?.completedLessons ?? 0,
                  summary?.totalLessons ?? entries.length,
                ),
              ),
              const SizedBox(height: 8),
              ProgressBar(value: summary?.ratio ?? 0, height: 8),
            ],
          ),
        ),
        if (milestones.isNotEmpty)
          LearningSection(
            title: l10n.hadithPathMilestonesTitle,
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
                      decoration:
                          AppSurfaceTheme.resolve(
                                context,
                                variant: AppSurfaceVariant.pill,
                                tintColor: AppColors.accentGold,
                              )
                              .decoration(radius: 999, includeShadow: false)
                              .copyWith(
                                color: item.unlocked
                                    ? AppColors.surface.withValues(alpha: 0.32)
                                    : AppColors.surface.withValues(alpha: 0.18),
                                gradient: null,
                                border: Border.all(
                                  color: item.unlocked
                                      ? AppColors.accentGoldSoft.withValues(
                                          alpha: 0.5,
                                        )
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
          title: path.chapters.isEmpty
              ? l10n.hadithPathLessonsTitle
              : l10n.hadithPathChaptersTitle,
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
    final l10n = AppLocalizations.of(context);
    final entryById = {for (final entry in entries) entry.id: entry};
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.path,
      laneId: path.id,
      laneTitle: path.title,
      orderedLessonIds: entries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithPathDetail',
      returnPathParameters: {'pathId': path.id},
    );
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
                      l10n.hadithPathLessonCount(
                        completedInChapter,
                        chapter.lessonIds.length,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ProgressBar(
                      value: chapter.lessonIds.isEmpty
                          ? 0
                          : completedInChapter / chapter.lessonIds.length,
                      height: 6,
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
                          laneContext: laneContext,
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
                              label: Text(l10n.hadithActionUnlockQuiz),
                            );
                          }

                          final scoreText = status.lastScore == null
                              ? ''
                              : l10n.hadithPathLastScore(
                                  status.lastScore!,
                                  status.quiz!.questions.length,
                                );

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
                                  ? '${l10n.hadithActionRetakeChapterQuiz}$scoreText'
                                  : l10n.hadithActionStartChapterQuiz,
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
    final laneContext = HadithReaderLaneContext(
      kind: HadithReaderLaneKind.path,
      laneId: path.id,
      laneTitle: path.title,
      orderedLessonIds: entries
          .map((entry) => entry.id)
          .toList(growable: false),
      returnRouteName: 'hadithPathDetail',
      returnPathParameters: {'pathId': path.id},
    );
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
                laneContext: laneContext,
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
    required HadithReaderLaneContext laneContext,
  }) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(entry.title),
        subtitle: Text(
          '${entry.displaySourceCollection} • ${entry.grading}\n'
          '${l10n.hadithPathQuranConnections(entry.quranConnections.length)}'
          '${nextTeaser == null ? '' : '\n${l10n.hadithPathNextLesson(nextTeaser)}'}',
        ),
        trailing: completed || !unlocked
            ? Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.lock_outline_rounded,
                color: completed
                    ? AppColors.onSurface
                    : AppColors.onSurfaceSubtle,
              )
            : null,
        onTap: unlocked
            ? () => pushHadithLessonDetail(
                context,
                lessonId: entry.id,
                laneContext: laneContext,
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
