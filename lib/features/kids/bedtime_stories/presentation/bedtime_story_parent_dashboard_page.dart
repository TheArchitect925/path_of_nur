import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../journey/xp/presentation/widgets/journey_xp_progress_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/bedtime_active_learner_service.dart';
import '../application/bedtime_story_parent_dashboard_service.dart';
import '../domain/bedtime_story_learning_models.dart';
import '../domain/bedtime_story_parent_dashboard_models.dart';

class BedtimeStoryParentDashboardPage extends ConsumerWidget {
  const BedtimeStoryParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(bedtimeStoryParentDashboardProvider);
    final activeLearner = ref.watch(bedtimeActiveLearnerProvider);
    final learners = ref.watch(bedtimeAvailableLearnersProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.bedtimeParentDashboardTitle,
      subtitle: l10n.bedtimeParentDashboardSubtitle,
      children: [
        if (learners.where((item) => !item.isArchived).length > 1) ...[
          _SectionCard(
            title: l10n.bedtimeFamilyModeSwitchTitle,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: learners
                  .where((item) => !item.isArchived)
                  .map(
                    (learner) => InkWell(
                      onTap: () => ref
                          .read(bedtimeFamilyModeProvider.notifier)
                          .selectLearner(learner),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: _bedtimeNoorPillDecoration(
                          context,
                          tintColor:
                              learner.learnerId == activeLearner.learnerId
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.14)
                              : null,
                        ),
                        child: Text(learner.effectiveDisplayName),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _HeroCard(
          learnerName: summary.overview.learnerDisplayName,
          streak: summary.habitSummary.currentStreak,
          level: summary.overview.currentLevel,
          levelTitle: summary.overview.currentLevelTitle,
          l10n: l10n,
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.bedtimeParentContinueLearningSectionTitle,
          child: summary.continueLearning == null
              ? Text(l10n.bedtimeParentContinueLearningEmpty)
              : _ContinueLearningCard(item: summary.continueLearning!),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.bedtimeParentOverviewSectionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _StatCard(
              label: l10n.bedtimeParentOverallStoriesLabel,
              value: '${summary.overview.totalKidsStoriesCompleted}',
            ),
            _StatCard(
              label: l10n.bedtimeParentOverallSeerahLabel,
              value: '${summary.overview.totalSeerahStagesCompleted}',
            ),
            _StatCard(
              label: l10n.bedtimeParentOverallDuasLabel,
              value: '${summary.overview.totalDuasLearned}',
            ),
            _StatCard(
              label: l10n.bedtimeParentOverallArabicLabel,
              value: '${summary.overview.totalArabicLettersCompleted}',
            ),
            _StatCard(
              label: l10n.bedtimeParentCurrentStreakLabel,
              value: '${summary.habitSummary.currentStreak}',
            ),
            _StatCard(
              label: l10n.bedtimeParentOverallXpLabel,
              value: '${summary.overview.totalXpEarnedAcrossKidsLearning}',
            ),
            _StatCard(
              label: l10n.bedtimeParentOverallDropsLabel,
              value:
                  '${summary.overview.totalOceanDropsEarnedAcrossKidsLearning}',
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionCard(
          title: l10n.bedtimeParentLearningAreasSectionTitle,
          child: summary.learningAreas.isEmpty
              ? Text(l10n.bedtimeParentLearningAreasEmpty)
              : Column(
                  children: summary.learningAreas
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LearningAreaCard(item: item),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 18),
        _SectionCard(
          title: l10n.progressionPageTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InlineLevelSummary(
                level: summary.overview.currentLevel,
                levelTitle: summary.overview.currentLevelTitle,
                progress: summary.overview.xpProgressPercent,
                xpRemaining: summary.overview.xpRemainingToNextLevel,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('kidsLearnerProgression'),
                icon: const Icon(Icons.stars_rounded),
                label: Text(l10n.progressionPageOpenAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.bedtimeParentLearningRecentActivitySectionTitle,
          child: summary.learningRecentActivity.isEmpty
              ? Text(l10n.bedtimeParentLearningRecentActivityEmpty)
              : Column(
                  children: summary.learningRecentActivity
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _KidsRecentActivityRow(item: item),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.bedtimeParentHabitSectionTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(
                    label: l10n.bedtimeParentHabitCurrentStreak(
                      summary.habitSummary.currentStreak,
                    ),
                  ),
                  _Badge(
                    label: l10n.bedtimeParentHabitLongestStreak(
                      summary.habitSummary.longestStreak,
                    ),
                  ),
                  _Badge(
                    label: l10n.bedtimeParentHabitWeekDays(
                      summary.habitSummary.activeDaysThisWeek,
                    ),
                  ),
                  _Badge(
                    label: l10n.bedtimeParentHabitMonthDays(
                      summary.habitSummary.activeDaysThisMonth,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                summary.habitSummary.currentStreak > 0
                    ? l10n.bedtimeParentHabitEncouragingCopy
                    : l10n.bedtimeParentHabitGentleRestartCopy,
              ),
              if (summary.habitSummary.lastActiveDateIso != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.bedtimeParentLastSessionLabel(
                    _formatDate(
                      context,
                      summary.habitSummary.lastActiveDateIso!,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (summary.prophetProgress.isNotEmpty) ...[
          _SectionCard(
            title: l10n.bedtimeParentProphetProgressSectionTitle,
            child: Column(
              children: summary.prophetProgress
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ProphetProgressRow(item: item),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _SectionCard(
          title: l10n.bedtimeParentLessonsLearnedSectionTitle,
          child: summary.overview.lessonsLearned.isEmpty
              ? Text(l10n.bedtimeParentLessonsEmpty)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: summary.overview.lessonsLearned
                      .map((lesson) => _Badge(label: lesson))
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.bedtimeParentBedtimeActivitySectionTitle,
          child: summary.recentActivity.isEmpty
              ? Text(l10n.bedtimeParentRecentActivityEmpty)
              : Column(
                  children: summary.recentActivity
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RecentActivityRow(item: item),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.bedtimeParentRecommendationsSectionTitle,
          child: Column(
            children: summary.recommendations
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _RecommendationRow(item: item),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      return iso;
    }
    return MaterialLocalizations.of(context).formatCompactDate(parsed);
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.learnerName,
    required this.streak,
    required this.level,
    required this.levelTitle,
    required this.l10n,
  });

  final String? learnerName;
  final int streak;
  final int level;
  final String levelTitle;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: l10n.bedtimeParentWelcomeTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            learnerName == null || learnerName!.isEmpty
                ? l10n.bedtimeParentWelcomeSubtitle
                : l10n.bedtimeParentWelcomeSubtitleWithName(learnerName!),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          _Badge(
            label: streak > 0
                ? l10n.bedtimeParentStreakBadge(streak)
                : l10n.bedtimeParentReadyTonightBadge,
          ),
          const SizedBox(height: 8),
          _Badge(
            label: l10n.progressionPageLevelValue(
              '$level',
              localizedXpLevelTitle(l10n, level, levelTitle),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineLevelSummary extends StatelessWidget {
  const _InlineLevelSummary({
    required this.level,
    required this.levelTitle,
    required this.progress,
    required this.xpRemaining,
  });

  final int level;
  final String levelTitle;
  final double progress;
  final int xpRemaining;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressionPageLevelValue(
            '$level',
            localizedXpLevelTitle(l10n, level, levelTitle),
          ),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: progress, minHeight: 8),
        ),
        const SizedBox(height: 8),
        Text(l10n.progressionParentRemainingValue('$xpRemaining')),
      ],
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
      width: 156,
      child: PremiumCard(
        surfaceVariant: AppSurfaceVariant.card,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: _bedtimeNoorPillDecoration(context),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.item});

  final KidsParentContinueLearningItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.card,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: _bedtimeNoorPanelDecoration(context, radius: 14),
            alignment: Alignment.center,
            child: Icon(_iconFor(item.type), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: () => context.pushNamed(
              item.routeName,
              pathParameters: item.pathParameters,
              queryParameters: item.queryParameters,
            ),
            child: Text(_actionLabel(l10n, item.type)),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(KidsParentContinueType type) {
    switch (type) {
      case KidsParentContinueType.story:
        return Icons.menu_book_rounded;
      case KidsParentContinueType.seerah:
        return Icons.timeline_rounded;
      case KidsParentContinueType.dua:
        return Icons.auto_awesome_rounded;
      case KidsParentContinueType.arabic:
        return Icons.edit_rounded;
    }
  }

  String _actionLabel(AppLocalizations l10n, KidsParentContinueType type) {
    switch (type) {
      case KidsParentContinueType.story:
        return l10n.bedtimeParentContinueStoryAction;
      case KidsParentContinueType.seerah:
        return l10n.bedtimeParentContinueSeerahAction;
      case KidsParentContinueType.dua:
        return l10n.bedtimeParentContinueDuaAction;
      case KidsParentContinueType.arabic:
        return l10n.bedtimeParentContinueArabicAction;
    }
  }
}

class _LearningAreaCard extends StatelessWidget {
  const _LearningAreaCard({required this.item});

  final KidsParentLearningAreaSummary item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.card,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: _bedtimeNoorPanelDecoration(context, radius: 14),
            alignment: Alignment.center,
            child: Icon(_iconFor(item.type), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleFor(l10n, item.type),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(_progressFor(l10n, item)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(label: _secondaryFor(l10n, item)),
                    if (item.lastActiveDateIso != null)
                      _Badge(
                        label: l10n.bedtimeParentAreaLastActive(
                          MaterialLocalizations.of(context).formatCompactDate(
                            DateTime.tryParse(item.lastActiveDateIso!) ??
                                DateTime.now(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(KidsParentLearningAreaType type) {
    switch (type) {
      case KidsParentLearningAreaType.stories:
        return Icons.menu_book_rounded;
      case KidsParentLearningAreaType.seerah:
        return Icons.timeline_rounded;
      case KidsParentLearningAreaType.duas:
        return Icons.wb_twilight_rounded;
      case KidsParentLearningAreaType.arabic:
        return Icons.spellcheck_rounded;
    }
  }

  String _titleFor(AppLocalizations l10n, KidsParentLearningAreaType type) {
    switch (type) {
      case KidsParentLearningAreaType.stories:
        return l10n.bedtimeParentLearningAreaStoriesTitle;
      case KidsParentLearningAreaType.seerah:
        return l10n.bedtimeParentLearningAreaSeerahTitle;
      case KidsParentLearningAreaType.duas:
        return l10n.bedtimeParentLearningAreaDuasTitle;
      case KidsParentLearningAreaType.arabic:
        return l10n.bedtimeParentLearningAreaArabicTitle;
    }
  }

  String _progressFor(
    AppLocalizations l10n,
    KidsParentLearningAreaSummary item,
  ) {
    switch (item.type) {
      case KidsParentLearningAreaType.stories:
        return l10n.bedtimeParentLearningAreaStoriesProgress(
          item.completedCount,
          item.totalCount,
        );
      case KidsParentLearningAreaType.seerah:
        return l10n.bedtimeParentLearningAreaSeerahProgress(
          item.completedCount,
          item.totalCount,
        );
      case KidsParentLearningAreaType.duas:
        return l10n.bedtimeParentLearningAreaDuasProgress(
          item.completedCount,
          item.totalCount,
        );
      case KidsParentLearningAreaType.arabic:
        return l10n.bedtimeParentLearningAreaArabicProgress(
          item.completedCount,
          item.totalCount,
        );
    }
  }

  String _secondaryFor(
    AppLocalizations l10n,
    KidsParentLearningAreaSummary item,
  ) {
    switch (item.type) {
      case KidsParentLearningAreaType.stories:
        return l10n.bedtimeParentLearningAreaStoriesSecondary(
          item.secondaryCount,
        );
      case KidsParentLearningAreaType.seerah:
        return l10n.bedtimeParentLearningAreaSeerahSecondary(
          item.secondaryCount,
        );
      case KidsParentLearningAreaType.duas:
        return l10n.bedtimeParentLearningAreaDuasSecondary(item.secondaryCount);
      case KidsParentLearningAreaType.arabic:
        return l10n.bedtimeParentLearningAreaArabicSecondary(
          item.secondaryCount,
        );
    }
  }
}

class _ProphetProgressRow extends StatelessWidget {
  const _ProphetProgressRow({required this.item});

  final BedtimeParentProphetProgress item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _Badge(
                label: item.completed
                    ? l10n.bedtimeParentProphetCompletedLabel
                    : item.started
                    ? l10n.bedtimeParentProphetStartedLabel
                    : l10n.bedtimeParentProphetNotStartedLabel,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.mainLesson, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(
                label: l10n.bedtimeParentProphetStoryPartsLabel(
                  item.storyPartsCompleted,
                  item.totalStoryParts,
                ),
              ),
              _Badge(
                label: item.quizCompleted
                    ? l10n.bedtimeParentQuizDoneLabel
                    : l10n.bedtimeParentQuizPendingLabel,
              ),
              _Badge(
                label: item.memoryCompleted
                    ? l10n.bedtimeParentMemoryDoneLabel
                    : l10n.bedtimeParentMemoryPendingLabel,
              ),
            ],
          ),
          if (item.continueStoryId != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () => context.pushNamed(
                  'kidsBedtimeStoryDetail',
                  pathParameters: {'storyId': item.continueStoryId!},
                ),
                child: Text(l10n.bedtimeParentContinueAction),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({required this.item});

  final BedtimeParentRecentActivityItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: _bedtimeNoorPanelDecoration(context, radius: 12),
          alignment: Alignment.center,
          child: Icon(_iconFor(item.type), size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(_labelFor(context, l10n, item)),
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconFor(BedtimeParentActivityType type) {
    switch (type) {
      case BedtimeParentActivityType.storyStarted:
        return Icons.menu_book_rounded;
      case BedtimeParentActivityType.storyListened:
        return Icons.headphones_rounded;
      case BedtimeParentActivityType.storyCompleted:
        return Icons.check_circle_rounded;
      case BedtimeParentActivityType.quizCompleted:
        return Icons.quiz_rounded;
      case BedtimeParentActivityType.memoryCompleted:
        return Icons.style_rounded;
    }
  }

  String _labelFor(
    BuildContext context,
    AppLocalizations l10n,
    BedtimeParentRecentActivityItem item,
  ) {
    final date = MaterialLocalizations.of(context).formatCompactDate(
      DateTime.tryParse(item.occurredAtIso) ?? DateTime.now(),
    );
    switch (item.type) {
      case BedtimeParentActivityType.storyStarted:
        return l10n.bedtimeParentActivityStarted(date);
      case BedtimeParentActivityType.storyListened:
        return l10n.bedtimeParentActivityListened(date);
      case BedtimeParentActivityType.storyCompleted:
        return l10n.bedtimeParentActivityCompleted(date);
      case BedtimeParentActivityType.quizCompleted:
        return l10n.bedtimeParentActivityQuizCompleted(date);
      case BedtimeParentActivityType.memoryCompleted:
        return l10n.bedtimeParentActivityMemoryCompleted(date);
    }
  }
}

class _KidsRecentActivityRow extends StatelessWidget {
  const _KidsRecentActivityRow({required this.item});

  final KidsParentRecentActivityItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = item.title.isNotEmpty
        ? item.title
        : _fallbackTitle(l10n, item.type);
    final subtitle = _labelFor(context, l10n, item);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: _bedtimeNoorPanelDecoration(context, radius: 12),
          alignment: Alignment.center,
          child: Icon(_iconFor(item.type), size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconFor(KidsParentRecentActivityType type) {
    switch (type) {
      case KidsParentRecentActivityType.story:
        return Icons.menu_book_rounded;
      case KidsParentRecentActivityType.quiz:
        return Icons.quiz_rounded;
      case KidsParentRecentActivityType.memory:
        return Icons.style_rounded;
      case KidsParentRecentActivityType.duaLesson:
      case KidsParentRecentActivityType.duaPractice:
      case KidsParentRecentActivityType.duaMyDay:
        return Icons.auto_awesome_rounded;
      case KidsParentRecentActivityType.seerahNode:
      case KidsParentRecentActivityType.seerahStage:
      case KidsParentRecentActivityType.seerahJourney:
        return Icons.timeline_rounded;
      case KidsParentRecentActivityType.arabicLesson:
      case KidsParentRecentActivityType.arabicDailyMission:
        return Icons.spellcheck_rounded;
      case KidsParentRecentActivityType.bedtimeRoutine:
        return Icons.nightlight_round_rounded;
    }
  }

  String _fallbackTitle(
    AppLocalizations l10n,
    KidsParentRecentActivityType type,
  ) {
    switch (type) {
      case KidsParentRecentActivityType.story:
        return l10n.bedtimeParentRecentStoryTitle;
      case KidsParentRecentActivityType.quiz:
        return l10n.bedtimeParentRecentQuizTitle;
      case KidsParentRecentActivityType.memory:
        return l10n.bedtimeParentRecentMemoryTitle;
      case KidsParentRecentActivityType.duaLesson:
        return l10n.bedtimeParentRecentDuaLessonTitle;
      case KidsParentRecentActivityType.duaPractice:
        return l10n.bedtimeParentRecentDuaPracticeTitle;
      case KidsParentRecentActivityType.duaMyDay:
        return l10n.bedtimeParentRecentDuaDayTitle;
      case KidsParentRecentActivityType.seerahNode:
        return l10n.bedtimeParentRecentSeerahNodeTitle;
      case KidsParentRecentActivityType.seerahStage:
        return l10n.bedtimeParentRecentSeerahStageTitle;
      case KidsParentRecentActivityType.seerahJourney:
        return l10n.bedtimeParentRecentSeerahJourneyTitle;
      case KidsParentRecentActivityType.arabicLesson:
        return l10n.bedtimeParentRecentArabicLessonTitle;
      case KidsParentRecentActivityType.arabicDailyMission:
        return l10n.bedtimeParentRecentArabicDailyTitle;
      case KidsParentRecentActivityType.bedtimeRoutine:
        return l10n.bedtimeParentRecentBedtimeRoutineTitle;
    }
  }

  String _labelFor(
    BuildContext context,
    AppLocalizations l10n,
    KidsParentRecentActivityItem item,
  ) {
    final date = MaterialLocalizations.of(context).formatCompactDate(
      DateTime.tryParse(item.occurredAtIso) ?? DateTime.now(),
    );
    switch (item.type) {
      case KidsParentRecentActivityType.story:
        return l10n.bedtimeParentLearningActivityStory(date);
      case KidsParentRecentActivityType.quiz:
        return l10n.bedtimeParentLearningActivityQuiz(date);
      case KidsParentRecentActivityType.memory:
        return l10n.bedtimeParentLearningActivityMemory(date);
      case KidsParentRecentActivityType.duaLesson:
        return l10n.bedtimeParentLearningActivityDuaLesson(date);
      case KidsParentRecentActivityType.duaPractice:
        return l10n.bedtimeParentLearningActivityDuaPractice(date);
      case KidsParentRecentActivityType.duaMyDay:
        return l10n.bedtimeParentLearningActivityDuaMyDay(date);
      case KidsParentRecentActivityType.seerahNode:
        return l10n.bedtimeParentLearningActivitySeerahNode(date);
      case KidsParentRecentActivityType.seerahStage:
        return l10n.bedtimeParentLearningActivitySeerahStage(date);
      case KidsParentRecentActivityType.seerahJourney:
        return l10n.bedtimeParentLearningActivitySeerahJourney(date);
      case KidsParentRecentActivityType.arabicLesson:
        return l10n.bedtimeParentLearningActivityArabicLesson(date);
      case KidsParentRecentActivityType.arabicDailyMission:
        return l10n.bedtimeParentLearningActivityArabicDaily(date);
      case KidsParentRecentActivityType.bedtimeRoutine:
        return l10n.bedtimeParentLearningActivityBedtimeRoutine(date);
    }
  }
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({required this.item});

  final BedtimeParentRecommendation item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.tonal(
            onPressed: () {
              if (item.activityMode == BedtimeStoryLearningMode.quiz) {
                context.pushNamed(
                  'kidsBedtimeStoryQuiz',
                  pathParameters: {'storyId': item.storyId},
                );
                return;
              }
              if (item.activityMode == BedtimeStoryLearningMode.memoryCards) {
                context.pushNamed(
                  'kidsBedtimeStoryMemory',
                  pathParameters: {'storyId': item.storyId},
                );
                return;
              }
              context.pushNamed(
                'kidsBedtimeStoryDetail',
                pathParameters: {'storyId': item.storyId},
              );
            },
            child: Text(_actionLabel(l10n, item)),
          ),
        ],
      ),
    );
  }

  String _actionLabel(AppLocalizations l10n, BedtimeParentRecommendation item) {
    switch (item.type) {
      case BedtimeParentRecommendationType.continueStory:
        return l10n.bedtimeParentRecommendationContinueStory;
      case BedtimeParentRecommendationType.completeQuiz:
        return l10n.bedtimeParentRecommendationOpenQuiz;
      case BedtimeParentRecommendationType.completeMemory:
        return l10n.bedtimeParentRecommendationOpenMemory;
      case BedtimeParentRecommendationType.nextStory:
        return l10n.bedtimeParentRecommendationOpenStory;
      case BedtimeParentRecommendationType.tonightStory:
        return l10n.bedtimeParentRecommendationTonightStory;
    }
  }
}

BoxDecoration _bedtimeNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _bedtimeNoorPanelDecoration(
  BuildContext context, {
  double radius = 14,
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
    tintColor: tintColor,
  );
  return style.decoration(radius: radius);
}
