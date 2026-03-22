import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/bedtime_active_learner_service.dart';
import '../application/bedtime_story_learning_loop_service.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_player_controller.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_learning_models.dart';
import '../domain/bedtime_story_models.dart';
import '../../seerah/application/seerah_journey_repository.dart';
import 'bedtime_story_cover_card.dart';
import 'bedtime_story_mini_player.dart';

class BedtimeStoriesPage extends ConsumerWidget {
  const BedtimeStoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final featured = ref.watch(featuredBedtimeStoryProvider);
    final tonight = ref.watch(tonightBedtimeStoryProvider);
    final continueStory = ref.watch(continueBedtimeStoryProvider);
    final stories = ref.watch(bedtimeStoriesProvider);
    final progress = ref.watch(bedtimeStoryProgressProvider);
    final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
    final currentQueueStory = ref.watch(bedtimeStoryCurrentQueueStoryProvider);
    final continueLearning = ref.watch(
      bedtimeStoryContinueLearningSuggestionProvider,
    );
    final tonightLearning = ref.watch(
      bedtimeStoryTonightLearningSuggestionProvider,
    );
    final activeLearner = ref.watch(bedtimeActiveLearnerProvider);
    final seerahJourney = ref.watch(featuredKidsSeerahJourneyProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.nightlight_round,
      title: l10n.bedtimeStoriesTitle,
      subtitle: l10n.bedtimeStoriesSubtitle,
      headerActions: [
        FilledButton.tonalIcon(
          onPressed: () => context.pushNamed('kidsStoryLibrary'),
          icon: const Icon(Icons.library_books_rounded),
          label: Text(l10n.kidsStoryLibraryAction),
        ),
        FilledButton.tonalIcon(
          onPressed: () => context.pushNamed('kidsBedtimeStoriesFamilyMode'),
          icon: const Icon(Icons.switch_account_rounded),
          label: Text(l10n.bedtimeFamilyModeHeaderAction),
        ),
        FilledButton.tonalIcon(
          onPressed: () => context.pushNamed('kidsBedtimeStoriesParentDashboard'),
          icon: const Icon(Icons.family_restroom_rounded),
          label: Text(l10n.bedtimeParentEntryAction),
        ),
      ],
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        _HeroCard(
          title: l10n.bedtimeStoriesHeroTitle,
          subtitle: l10n.bedtimeStoriesHeroSubtitle,
          countLabel: l10n.bedtimeStoriesCountLabel(stories.length),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Row(
            children: [
              const Icon(Icons.stars_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.progressionPageTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.progressionPageSubtitle),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('kidsLearnerProgression'),
                child: Text(l10n.progressionPageOpenAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Row(
            children: [
              const Icon(Icons.library_books_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.kidsStoryLibraryTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.kidsStoryLibrarySubtitle),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('kidsStoryLibrary'),
                child: Text(l10n.kidsStoryLibraryAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Row(
            children: [
              const Icon(Icons.bedtime_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bedtimeCompanionEntryTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.bedtimeCompanionEntrySubtitle),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('kidsBedtimeCompanion'),
                child: Text(l10n.bedtimeCompanionEntryAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (seerahJourney != null) ...[
          PremiumCard(
            surfaceVariant: AppSurfaceVariant.panel,
            child: Row(
              children: [
                const Icon(Icons.route_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.kidsSeerahJourneysTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.kidsSeerahJourneysSubtitle),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => context.pushNamed('kidsSeerahJourneys'),
                  child: Text(l10n.kidsSeerahOpenJourneyAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.island,
          child: Row(
            children: [
              const Icon(Icons.switch_account_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bedtimeFamilyModeEntryTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.bedtimeFamilyModeEntrySubtitle(
                        activeLearner.effectiveDisplayName,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => context.pushNamed('kidsBedtimeStoriesFamilyMode'),
                child: Text(l10n.bedtimeFamilyModeHeaderAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (currentQueueStory != null) ...[
          PremiumCard(
            surfaceVariant: AppSurfaceVariant.island,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeStoriesTonightQueueTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  queueState.storyIds.length > 1
                      ? l10n.bedtimeStoriesTonightQueueSubtitle(
                          currentQueueStory.shortTitle,
                          queueState.storyIds.length,
                        )
                      : l10n.bedtimeStoriesContinueAction,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (tonight != null) ...[
          _FeatureCard(
            title: l10n.bedtimeStoriesTonightTitle,
            subtitle: tonight.lesson,
            story: tonight,
            actionLabel: l10n.bedtimeStoriesTonightAction,
            onPressed: () async {
              await ref
                  .read(bedtimeStoryQueueControllerProvider.notifier)
                  .startTonightStory();
              if (context.mounted) {
                context.pushNamed(
                  'kidsBedtimeStoryDetail',
                  pathParameters: {'storyId': tonight.id},
                );
              }
            },
          ),
          const SizedBox(height: 12),
        ],
        if (continueLearning != null) ...[
          _LearningLoopCard(
            title: l10n.bedtimeStoryContinueLearningTitle,
            suggestion: continueLearning,
          ),
          const SizedBox(height: 12),
        ],
        if (tonightLearning != null &&
            continueLearning?.activityId != tonightLearning.activityId) ...[
          _LearningLoopCard(
            title: l10n.bedtimeStoryTonightQuestionTitle,
            suggestion: tonightLearning,
          ),
          const SizedBox(height: 12),
        ],
        if (continueStory != null) ...[
          _FeatureCard(
            title: l10n.bedtimeStoriesContinueTitle,
            subtitle: continueStory.lesson,
            story: continueStory,
            actionLabel: l10n.bedtimeStoriesContinueAction,
            progress: progress.storyProgressById[continueStory.id],
            onPressed: () async {
              await ref
                  .read(bedtimeStoryQueueControllerProvider.notifier)
                  .playStoryWithBestQueue(continueStory);
              if (context.mounted) {
                context.pushNamed(
                  'kidsBedtimeStoryDetail',
                  pathParameters: {'storyId': continueStory.id},
                );
              }
            },
          ),
          const SizedBox(height: 12),
        ],
        if (featured != null) ...[
          _FeatureCard(
            title: l10n.bedtimeStoriesFeaturedTitle,
            subtitle: featured.lesson,
            story: featured,
            actionLabel: l10n.bedtimeStoriesOpenAction,
            onPressed: () async {
              await ref
                  .read(bedtimeStoryQueueControllerProvider.notifier)
                  .playStoryWithBestQueue(featured);
              if (context.mounted) {
                context.pushNamed(
                  'kidsBedtimeStoryDetail',
                  pathParameters: {'storyId': featured.id},
                );
              }
            },
          ),
          const SizedBox(height: 18),
        ],
        Text(
          l10n.bedtimeStoriesAllStoriesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(l10n.bedtimeStoriesAllStoriesSubtitle),
        const SizedBox(height: 10),
        ...stories.map(
          (story) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _StoryListCard(
              story: story,
              progress: progress.storyProgressById[story.id],
            ),
          ),
        ),
      ],
    );
  }
}

class _LearningLoopCard extends StatelessWidget {
  const _LearningLoopCard({required this.title, required this.suggestion});

  final String title;
  final BedtimeStoryLearningSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isQuiz = suggestion.mode == BedtimeStoryLearningMode.quiz;
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(suggestion.title),
          const SizedBox(height: 4),
          Text(suggestion.subtitle),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.pushNamed(
              isQuiz ? 'kidsBedtimeStoryQuiz' : 'kidsBedtimeStoryMemory',
              pathParameters: {'storyId': suggestion.storyId},
            ),
            icon: Icon(isQuiz ? Icons.quiz_rounded : Icons.style_rounded),
            label: Text(
              isQuiz
                  ? l10n.bedtimeStoryQuizStartAction
                  : l10n.bedtimeStoryMemoryStartAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.countLabel,
  });

  final String title;
  final String subtitle;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.island,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6EA),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE7D7BE)),
            ),
            child: Text(countLabel),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.story,
    required this.actionLabel,
    this.progress,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final BedtimeStorySeed story;
  final String actionLabel;
  final BedtimeStoryProgress? progress;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer(
      builder: (context, ref, _) {
        final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
        return PremiumCard(
          surfaceVariant: AppSurfaceVariant.island,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (mediaAsync.hasValue)
                BedtimeStoryCoverCard(
                  story: story,
                  media: mediaAsync.requireValue,
                  height: 160,
                ),
              const SizedBox(height: 10),
              Text(
                story.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(
                    label: l10n.bedtimeStoriesDurationMinutesLabel(
                      (story.estimatedDurationSeconds / 60).ceil(),
                    ),
                  ),
                  _MetaChip(label: _ageGroupLabel(l10n, story.ageGroup)),
                  if (story.isMultipart)
                    _MetaChip(
                      label: l10n.bedtimeStoriesPartLabel(
                        story.partNumber,
                        story.totalParts,
                      ),
                    ),
                  _MetaChip(
                    label: mediaAsync.valueOrNull?.audio.isAvailable == true
                        ? l10n.bedtimeStoriesAudioReadyBadge
                        : l10n.bedtimeStoriesReadAlongBadge,
                  ),
                  if (progress != null)
                    _MetaChip(
                      label: _completionLabel(l10n, progress!.completionState),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onPressed == null
                    ? () => context.pushNamed(
                        'kidsBedtimeStoryDetail',
                        pathParameters: {'storyId': story.id},
                      )
                    : () async => onPressed!(),
                child: Text(actionLabel),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StoryListCard extends StatelessWidget {
  const _StoryListCard({required this.story, this.progress});

  final BedtimeStorySeed story;
  final BedtimeStoryProgress? progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer(
      builder: (context, ref, _) {
        final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
        final coverPath = mediaAsync.valueOrNull?.cover.resolvedAssetPath;

        return Semantics(
          button: true,
          label: story.title,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(
              'kidsBedtimeStoryDetail',
              pathParameters: {'storyId': story.id},
            ),
            child: PremiumCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFFFF8EF),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: coverPath != null
                        ? Image.asset(
                            coverPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.auto_stories_rounded, size: 28);
                            },
                          )
                        : const Icon(Icons.auto_stories_rounded, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              story.shortTitle,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            if (story.isMultipart)
                              _MetaChip(
                                label: l10n.bedtimeStoriesPartLabel(
                                  story.partNumber,
                                  story.totalParts,
                                ),
                              ),
                            _MetaChip(
                              label: mediaAsync.valueOrNull?.audio.isAvailable == true
                                  ? l10n.bedtimeStoriesAudioReadyBadge
                                  : l10n.bedtimeStoriesReadAlongBadge,
                            ),
                            if (progress != null &&
                                progress!.completionState !=
                                    BedtimeStoryCompletionState.notStarted)
                              _MetaChip(
                                label: _completionLabel(
                                  l10n,
                                  progress!.completionState,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.lesson,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.bedtimeStoriesDurationMinutesLabel(
                            (story.estimatedDurationSeconds / 60).ceil(),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

String _ageGroupLabel(AppLocalizations l10n, BedtimeStoryAgeGroup ageGroup) {
  switch (ageGroup) {
    case BedtimeStoryAgeGroup.kidsEarly:
      return l10n.bedtimeStoriesAgeGroupKidsEarly;
    case BedtimeStoryAgeGroup.kids:
      return l10n.bedtimeStoriesAgeGroupKids;
    case BedtimeStoryAgeGroup.kidsPlus:
      return l10n.bedtimeStoriesAgeGroupKidsPlus;
  }
}

String _completionLabel(
  AppLocalizations l10n,
  BedtimeStoryCompletionState completionState,
) {
  switch (completionState) {
    case BedtimeStoryCompletionState.notStarted:
      return l10n.bedtimeStoriesStatusNotStarted;
    case BedtimeStoryCompletionState.inProgress:
      return l10n.bedtimeStoriesStatusInProgress;
    case BedtimeStoryCompletionState.completed:
      return l10n.bedtimeStoriesStatusCompleted;
  }
}
