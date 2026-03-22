import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../journey/xp/presentation/widgets/journey_xp_progress_card.dart';
import '../../kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/learner_progression_service.dart';
import '../domain/learner_progression_models.dart';

class LearnerProgressionPage extends ConsumerWidget {
  const LearnerProgressionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeLearner = ref.watch(bedtimeActiveLearnerProvider);
    final learners = ref.watch(bedtimeAvailableLearnersProvider);
    final summary = ref.watch(
      learnerProgressionSummaryProvider(activeLearner.learnerId),
    );
    final controller = ref.read(
      learnerProgressionControllerProvider(activeLearner.learnerId).notifier,
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.stars_rounded,
      title: l10n.progressionPageTitle,
      subtitle: l10n.progressionPageSubtitle,
      children: [
        if (learners.where((item) => !item.isArchived).length > 1) ...[
          _SectionCard(
            title: l10n.progressionPageLearnerSectionTitle,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: learners
                  .where((item) => !item.isArchived)
                  .map(
                    (learner) => ChoiceChip(
                      label: Text(learner.effectiveDisplayName),
                      selected: learner.learnerId == activeLearner.learnerId,
                      onSelected: (_) => ref
                          .read(bedtimeFamilyModeProvider.notifier)
                          .selectLearner(learner),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _SectionCard(
          title: l10n.progressionPageHeroTitle(
            activeLearner.effectiveDisplayName,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.progressionPageHeroSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              _InlineXpCard(summary: summary),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.progressionPageOverviewTitle,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatCard(
                label: l10n.progressionOverviewStoriesLabel,
                value: '${summary.metrics.storyCompletions}',
              ),
              _StatCard(
                label: l10n.progressionOverviewQuizzesLabel,
                value: '${summary.metrics.quizCompletions}',
              ),
              _StatCard(
                label: l10n.progressionOverviewDuasLabel,
                value: '${summary.metrics.duaLessonCompletions}',
              ),
              _StatCard(
                label: l10n.progressionOverviewRoutinesLabel,
                value: '${summary.metrics.bedtimeRoutineCompletions}',
              ),
              _StatCard(
                label: l10n.progressionOverviewDropsLabel,
                value: '${summary.metrics.totalDrops}',
              ),
              _StatCard(
                label: l10n.progressionOverviewBadgesLabel,
                value: '${summary.unlockedBadges.length}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.progressionPageGardenTitle,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_florist_rounded),
            title: Text(l10n.progressionPageGardenCardTitle),
            subtitle: Text(l10n.progressionPageGardenCardSubtitle),
            trailing: FilledButton.tonal(
              onPressed: () => context.pushNamed('gardenPage'),
              child: Text(l10n.progressionPageGardenAction),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.progressionPageMilestonesTitle,
          child: summary.unlockedMilestones.isEmpty
              ? Text(l10n.progressionPageMilestonesEmpty)
              : Column(
                  children: summary.unlockedMilestones
                      .map(
                        (milestone) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.flag_rounded),
                          title: Text(_localizedMilestoneTitle(l10n, milestone)),
                          subtitle: Text(
                            _localizedMilestoneDescription(l10n, milestone),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.progressionPageBadgesTitle,
          child: summary.unlockedBadges.isEmpty
              ? Text(l10n.progressionPageBadgesEmpty)
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: summary.unlockedBadges
                      .map(
                        (badge) => Container(
                          width: 180,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5D5C1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(controller.iconForName(badge.definition.iconName)),
                              const SizedBox(height: 8),
                              Text(
                                _localizedBadgeTitle(l10n, badge),
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _localizedBadgeDescription(l10n, badge),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
      ],
    );
  }

  String _localizedBadgeTitle(
    AppLocalizations l10n,
    LearnerProgressionBadgeUnlock badge,
  ) {
    return switch (badge.definition.badgeId) {
      'badge_first_story' => l10n.progressionBadgeFirstStoryTitle,
      'badge_first_quiz' => l10n.progressionBadgeFirstQuizTitle,
      'badge_first_memory' => l10n.progressionBadgeFirstMemoryTitle,
      'badge_first_dua' => l10n.progressionBadgeFirstDuaTitle,
      'badge_first_seerah_stage' => l10n.progressionBadgeFirstSeerahStageTitle,
      'badge_first_bedtime_routine' => l10n.progressionBadgeFirstRoutineTitle,
      'badge_bedtime_streak_7' => l10n.progressionBadgeBedtimeWeekTitle,
      'badge_stories_10' => l10n.progressionBadgeStoriesTenTitle,
      'badge_journey_complete' => l10n.progressionBadgeJourneyCompleteTitle,
      _ => badge.definition.badgeId,
    };
  }

  String _localizedBadgeDescription(
    AppLocalizations l10n,
    LearnerProgressionBadgeUnlock badge,
  ) {
    return switch (badge.definition.badgeId) {
      'badge_first_story' => l10n.progressionBadgeFirstStoryDescription,
      'badge_first_quiz' => l10n.progressionBadgeFirstQuizDescription,
      'badge_first_memory' => l10n.progressionBadgeFirstMemoryDescription,
      'badge_first_dua' => l10n.progressionBadgeFirstDuaDescription,
      'badge_first_seerah_stage' =>
        l10n.progressionBadgeFirstSeerahStageDescription,
      'badge_first_bedtime_routine' =>
        l10n.progressionBadgeFirstRoutineDescription,
      'badge_bedtime_streak_7' => l10n.progressionBadgeBedtimeWeekDescription,
      'badge_stories_10' => l10n.progressionBadgeStoriesTenDescription,
      'badge_journey_complete' =>
        l10n.progressionBadgeJourneyCompleteDescription,
      _ => badge.definition.badgeId,
    };
  }

  String _localizedMilestoneTitle(
    AppLocalizations l10n,
    LearnerProgressionMilestoneUnlock milestone,
  ) {
    return switch (milestone.definition.milestoneId) {
      'milestone_stories_10' => l10n.progressionMilestoneStoriesTenTitle,
      'milestone_stories_50' => l10n.progressionMilestoneStoriesFiftyTitle,
      'milestone_quizzes_10' => l10n.progressionMilestoneQuizzesTenTitle,
      'milestone_duas_10' => l10n.progressionMilestoneDuasTenTitle,
      'milestone_seerah_stage_1' => l10n.progressionMilestoneSeerahStageTitle,
      'milestone_seerah_journey_1' =>
        l10n.progressionMilestoneSeerahJourneyTitle,
      'milestone_bedtime_routine_7' =>
        l10n.progressionMilestoneBedtimeWeekTitle,
      'milestone_learning_streak_30' =>
        l10n.progressionMilestoneLearningMonthTitle,
      _ => milestone.definition.milestoneId,
    };
  }

  String _localizedMilestoneDescription(
    AppLocalizations l10n,
    LearnerProgressionMilestoneUnlock milestone,
  ) {
    return switch (milestone.definition.milestoneId) {
      'milestone_stories_10' => l10n.progressionMilestoneStoriesTenDescription,
      'milestone_stories_50' =>
        l10n.progressionMilestoneStoriesFiftyDescription,
      'milestone_quizzes_10' => l10n.progressionMilestoneQuizzesTenDescription,
      'milestone_duas_10' => l10n.progressionMilestoneDuasTenDescription,
      'milestone_seerah_stage_1' =>
        l10n.progressionMilestoneSeerahStageDescription,
      'milestone_seerah_journey_1' =>
        l10n.progressionMilestoneSeerahJourneyDescription,
      'milestone_bedtime_routine_7' =>
        l10n.progressionMilestoneBedtimeWeekDescription,
      'milestone_learning_streak_30' =>
        l10n.progressionMilestoneLearningMonthDescription,
      _ => milestone.definition.milestoneId,
    };
  }
}

class _InlineXpCard extends StatelessWidget {
  const _InlineXpCard({required this.summary});

  final LearnerProgressionSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levelTitle = localizedXpLevelTitle(
      l10n,
      summary.xpSummary.currentLevel,
      summary.xpSummary.currentLevelTitle,
    );
    final nextTitle = summary.xpSummary.nextLevel == null
        ? l10n.xpCardMaxLevel
        : localizedXpLevelTitle(
            l10n,
            summary.xpSummary.nextLevel!,
            summary.xpSummary.nextLevelTitle ?? '',
          );
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressionPageLevelValue(
              '${summary.xpSummary.currentLevel}',
              levelTitle,
            ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(l10n.progressionPageXpValue('${summary.xpSummary.totalXp}')),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.xpSummary.progressPercent,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.xpSummary.isMaxLevel
                ? l10n.progressionPageMaxLevel
                : l10n.progressionPageNextLevelValue(nextTitle),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: PremiumCard(
        surfaceVariant: AppSurfaceVariant.card,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
