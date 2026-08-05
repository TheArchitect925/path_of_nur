import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../bedtime_stories/application/bedtime_story_audio_service.dart';
import '../../bedtime_stories/application/bedtime_story_player_controller.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../../bedtime_stories/presentation/bedtime_story_mini_player.dart';
import '../application/bedtime_recommendation_service.dart';
import '../application/bedtime_routine_repository.dart';
import '../application/bedtime_session_service.dart';
import '../data/bedtime_routine_seed.dart';
import '../domain/bedtime_routine_models.dart';
import 'bedtime_routine_step_card.dart';

class BedtimeCompanionPage extends ConsumerWidget {
  const BedtimeCompanionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final learner = ref.watch(bedtimeActiveLearnerProvider);
    final plan = ref.watch(bedtimeRoutinePlanProvider);
    final state = ref.watch(bedtimeCompanionSessionProvider);
    final session = state.activeSession;
    final recommendation = ref.watch(bedtimeCompanionRecommendationProvider);
    final primaryDua = ref.watch(bedtimePrimaryDuaProvider);
    final secondaryDuas = ref.watch(bedtimeSecondaryDuasProvider);
    final story = session?.suggestedStoryId == null
        ? ref.watch(tonightBedtimeStoryProvider)
        : ref.watch(bedtimeStoryByIdProvider(session!.suggestedStoryId!));

    return LearnHubPageScaffold(
      headerIcon: Icons.bedtime_rounded,
      title: l10n.bedtimeCompanionTitle,
      subtitle: l10n.bedtimeCompanionSubtitle,
      floatingBottom: const BedtimeStoryMiniPlayer(),
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bedtimeCompanionHeroTitle(learner.effectiveDisplayName),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.bedtimeCompanionHeroSubtitle),
              const SizedBox(height: 12),
              if (recommendation != null)
                _Tag(label: _recommendationTitle(l10n, recommendation)),
              const SizedBox(height: 12),
              Text(
                l10n.bedtimeCompanionRoutineProgress(
                  _completedCount(plan, session),
                  plan.steps.length,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.bedtimeCompanionRoutineTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        ...plan.steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildStepCard(
              context: context,
              ref: ref,
              step: step,
              progress:
                  session?.stepProgressById[step.stepId] ??
                  const BedtimeRoutineStepProgress(),
              primaryDua: primaryDua,
              storyId: story?.id,
            ),
          ),
        ),
        if (primaryDua != null) ...[
          const SizedBox(height: 8),
          _SectionHeader(
            title: l10n.bedtimeCompanionTonightDuaTitle,
            subtitle: l10n.bedtimeCompanionTonightDuaSubtitle,
          ),
          const SizedBox(height: 10),
          _DuaCard(
            dua: primaryDua,
            secondaryDuas: secondaryDuas,
            onComplete: () {
              ref
                  .read(bedtimeCompanionSessionProvider.notifier)
                  .completeStep(
                    _stepId(plan, BedtimeRoutineStepType.bedtimeDua),
                  );
            },
          ),
        ],
        if (story != null) ...[
          const SizedBox(height: 18),
          _SectionHeader(
            title: l10n.bedtimeCompanionTonightStoryTitle,
            subtitle: l10n.bedtimeCompanionTonightStorySubtitle,
          ),
          const SizedBox(height: 10),
          _StoryCard(storyId: story.id),
        ],
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.bedtimeCompanionReflectionTitle,
          subtitle: l10n.bedtimeCompanionReflectionSubtitle,
        ),
        const SizedBox(height: 10),
        _ReflectionCard(
          session: session,
          onSelect: (choiceId) {
            ref
                .read(bedtimeCompanionSessionProvider.notifier)
                .completeStep(
                  _stepId(plan, BedtimeRoutineStepType.gratitudeReflection),
                  selectedChoiceId: choiceId,
                );
          },
        ),
        const SizedBox(height: 18),
        _SleepReadyCard(
          isCompleted: session?.isCompleted ?? false,
          onReady: () {
            final controller = ref.read(
              bedtimeCompanionSessionProvider.notifier,
            );
            controller.completeStep(
              _stepId(plan, BedtimeRoutineStepType.getReadyForBed),
            );
            controller.completeStep(
              _stepId(plan, BedtimeRoutineStepType.sleepReadyFinish),
            );
          },
        ),
      ],
    );
  }

  BedtimeRoutineStepCard _buildStepCard({
    required BuildContext context,
    required WidgetRef ref,
    required BedtimeRoutineStep step,
    required BedtimeRoutineStepProgress progress,
    required SuggestedBedtimeDua? primaryDua,
    required String? storyId,
  }) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(bedtimeCompanionSessionProvider.notifier);
    final title = _stepTitle(l10n, step.titleKey);
    final subtitle = _stepSubtitle(l10n, step.shortDescriptionKey);
    return BedtimeRoutineStepCard(
      title: title,
      subtitle: subtitle,
      progress: progress,
      icon: _iconFor(step.stepType),
      actionLabel: _actionLabel(l10n, step.stepType),
      onTap: () async {
        switch (step.stepType) {
          case BedtimeRoutineStepType.getReadyForBed:
            controller.completeStep(step.stepId);
            return;
          case BedtimeRoutineStepType.bedtimeDua:
            controller.startStep(step.stepId);
            return;
          case BedtimeRoutineStepType.storyTime:
            if (storyId == null) {
              return;
            }
            final story = ref.read(bedtimeStoryByIdProvider(storyId));
            if (story == null) {
              return;
            }
            controller.startStep(step.stepId);
            await ref
                .read(bedtimeStoryQueueControllerProvider.notifier)
                .playStoryWithBestQueue(story);
            if (context.mounted) {
              context.pushNamed(
                'kidsBedtimeStoryDetail',
                pathParameters: {'storyId': story.id},
              );
            }
            return;
          case BedtimeRoutineStepType.gratitudeReflection:
            controller.startStep(step.stepId);
            return;
          case BedtimeRoutineStepType.sleepReadyFinish:
            controller.completeStep(step.stepId);
            return;
          case BedtimeRoutineStepType.readAlong:
          case BedtimeRoutineStepType.dhikrLight:
            controller.completeStep(step.stepId);
            return;
        }
      },
    );
  }

  int _completedCount(BedtimeRoutinePlan plan, BedtimeRoutineSession? session) {
    if (session == null) {
      return 0;
    }
    return plan.steps.where((step) {
      final progress = session.stepProgressById[step.stepId];
      return progress?.state == BedtimeRoutineCompletionState.completed ||
          progress?.state == BedtimeRoutineCompletionState.skipped;
    }).length;
  }

  String _recommendationTitle(
    AppLocalizations l10n,
    BedtimeCompanionRecommendation recommendation,
  ) {
    switch (recommendation.type) {
      case BedtimeRecommendationType.resumeStory:
        return l10n.bedtimeCompanionRecommendationResumeTitle;
      case BedtimeRecommendationType.bedtimeDua:
        return l10n.bedtimeCompanionRecommendationDuaTitle;
      case BedtimeRecommendationType.featuredStory:
        return l10n.bedtimeCompanionRecommendationStoryTitle;
      case BedtimeRecommendationType.quietReflection:
        return l10n.bedtimeCompanionRecommendationReflectionTitle;
    }
  }
}

class _StoryCard extends ConsumerWidget {
  const _StoryCard({required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryByIdProvider(storyId));
    if (story == null) {
      return const SizedBox.shrink();
    }
    final availability = ref.watch(
      bedtimeStoryAudioAvailabilityProvider(story),
    );
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.shortTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(story.lesson),
          const SizedBox(height: 10),
          availability.when(
            data: (hasAudio) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await ref
                        .read(bedtimeStoryQueueControllerProvider.notifier)
                        .playStoryWithBestQueue(story);
                    if (context.mounted) {
                      context.pushNamed(
                        'kidsBedtimeStoryDetail',
                        pathParameters: {'storyId': story.id},
                      );
                    }
                  },
                  icon: Icon(
                    hasAudio
                        ? Icons.play_circle_fill_rounded
                        : Icons.menu_book_rounded,
                  ),
                  label: Text(
                    hasAudio
                        ? l10n.bedtimeCompanionPlayStoryAction
                        : l10n.bedtimeCompanionReadStoryAction,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => context.pushNamed(
                    'kidsBedtimeStoryDetail',
                    pathParameters: {'storyId': story.id},
                  ),
                  child: Text(l10n.bedtimeCompanionStoryDetailsAction),
                ),
              ],
            ),
            loading: () => Text(l10n.bedtimeStoriesMediaLoadingLabel),
            error: (error, stackTrace) =>
                Text(l10n.bedtimeStoriesAudioUnavailableSubtitle),
          ),
        ],
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  const _DuaCard({
    required this.dua,
    required this.secondaryDuas,
    required this.onComplete,
  });

  final SuggestedBedtimeDua dua;
  final List<SuggestedBedtimeDua> secondaryDuas;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dua.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            dua.arabicText,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(dua.transliteration),
          const SizedBox(height: 8),
          Text(dua.translation),
          const SizedBox(height: 8),
          Text(
            '${l10n.bedtimeCompanionSourceLabel}: ${dua.sourceReference}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7B6A57)),
          ),
          if (secondaryDuas.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.bedtimeCompanionExtraDhikrTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: secondaryDuas
                  .map((item) => _Tag(label: item.title))
                  .toList(growable: false),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onComplete,
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: Text(l10n.bedtimeCompanionDuaDoneAction),
          ),
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({required this.session, required this.onSelect});

  final BedtimeRoutineSession? session;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = session?.reflectionChoiceId;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bedtimeCompanionReflectionPrompt,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kBedtimeRoutineReflectionChoiceIds
                .map(
                  (choiceId) => ChoiceChip(
                    label: Text(_reflectionLabel(l10n, choiceId)),
                    selected: selected == choiceId,
                    onSelected: (_) => onSelect(choiceId),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _SleepReadyCard extends StatelessWidget {
  const _SleepReadyCard({required this.isCompleted, required this.onReady});

  final bool isCompleted;
  final VoidCallback onReady;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCompleted
                ? l10n.bedtimeCompanionSleepReadyDoneTitle
                : l10n.bedtimeCompanionSleepReadyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            isCompleted
                ? l10n.bedtimeCompanionSleepReadyDoneSubtitle
                : l10n.bedtimeCompanionSleepReadySubtitle,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onReady,
            child: Text(
              isCompleted
                  ? l10n.bedtimeCompanionGoodNightAction
                  : l10n.bedtimeCompanionReadyForSleepAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5D7C2)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

String _stepId(BedtimeRoutinePlan plan, BedtimeRoutineStepType type) {
  return plan.steps.firstWhere((step) => step.stepType == type).stepId;
}

String _stepTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'bedtimeRoutineStepGetReadyTitle':
      return l10n.bedtimeRoutineStepGetReadyTitle;
    case 'bedtimeRoutineStepDuaTitle':
      return l10n.bedtimeRoutineStepDuaTitle;
    case 'bedtimeRoutineStepStoryTitle':
      return l10n.bedtimeRoutineStepStoryTitle;
    case 'bedtimeRoutineStepReflectionTitle':
      return l10n.bedtimeRoutineStepReflectionTitle;
    case 'bedtimeRoutineStepSleepReadyTitle':
      return l10n.bedtimeRoutineStepSleepReadyTitle;
    default:
      return key;
  }
}

String _stepSubtitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'bedtimeRoutineStepGetReadySubtitle':
      return l10n.bedtimeRoutineStepGetReadySubtitle;
    case 'bedtimeRoutineStepDuaSubtitle':
      return l10n.bedtimeRoutineStepDuaSubtitle;
    case 'bedtimeRoutineStepStorySubtitle':
      return l10n.bedtimeRoutineStepStorySubtitle;
    case 'bedtimeRoutineStepReflectionSubtitle':
      return l10n.bedtimeRoutineStepReflectionSubtitle;
    case 'bedtimeRoutineStepSleepReadySubtitle':
      return l10n.bedtimeRoutineStepSleepReadySubtitle;
    default:
      return key;
  }
}

String _reflectionLabel(AppLocalizations l10n, String choiceId) {
  switch (choiceId) {
    case 'gratitude_family':
      return l10n.bedtimeCompanionReflectionChoiceFamily;
    case 'gratitude_story_lesson':
      return l10n.bedtimeCompanionReflectionChoiceLesson;
    case 'gratitude_rest':
      return l10n.bedtimeCompanionReflectionChoiceRest;
    default:
      return choiceId;
  }
}

String _actionLabel(AppLocalizations l10n, BedtimeRoutineStepType type) {
  switch (type) {
    case BedtimeRoutineStepType.getReadyForBed:
      return l10n.bedtimeCompanionMarkReadyAction;
    case BedtimeRoutineStepType.bedtimeDua:
      return l10n.bedtimeCompanionOpenDuaAction;
    case BedtimeRoutineStepType.storyTime:
      return l10n.bedtimeCompanionOpenStoryAction;
    case BedtimeRoutineStepType.gratitudeReflection:
      return l10n.bedtimeCompanionOpenReflectionAction;
    case BedtimeRoutineStepType.sleepReadyFinish:
      return l10n.bedtimeCompanionReadyForSleepAction;
    case BedtimeRoutineStepType.readAlong:
      return l10n.bedtimeStoriesReadTonightAction;
    case BedtimeRoutineStepType.dhikrLight:
      return l10n.bedtimeCompanionOpenDuaAction;
  }
}

IconData _iconFor(BedtimeRoutineStepType type) {
  switch (type) {
    case BedtimeRoutineStepType.getReadyForBed:
      return Icons.bed_rounded;
    case BedtimeRoutineStepType.bedtimeDua:
      return Icons.menu_book_rounded;
    case BedtimeRoutineStepType.storyTime:
      return Icons.auto_stories_rounded;
    case BedtimeRoutineStepType.gratitudeReflection:
      return Icons.favorite_outline_rounded;
    case BedtimeRoutineStepType.sleepReadyFinish:
      return Icons.nightlight_round;
    case BedtimeRoutineStepType.readAlong:
      return Icons.chrome_reader_mode_rounded;
    case BedtimeRoutineStepType.dhikrLight:
      return Icons.brightness_3_rounded;
  }
}
