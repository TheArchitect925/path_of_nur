import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../progression/domain/learner_progression_models.dart';
import '../../../core/theme/app_theme.dart';
import '../application/garden_scene_provider.dart';
import '../application/garden_service.dart';
import '../domain/garden_models.dart';
import '../domain/garden_scene_models.dart';
import 'widgets/garden_vista/garden_element_meaning_sheet.dart';
import 'widgets/garden_vista/garden_element_strings.dart';
import 'widgets/garden_vista/garden_vista_view.dart';
import '../../../core/theme/app_icons.dart';

class GardenPage extends ConsumerWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeLearner = ref.watch(bedtimeActiveLearnerProvider);
    final learners = ref.watch(bedtimeAvailableLearnersProvider);
    final garden = ref.watch(activeGardenStateProvider);
    final scene = ref.watch(activeGardenSceneSpecProvider);

    return AppPageScaffold(
      headerIcon: AppIcons.garden,
      title: l10n.gardenPageTitle,
      subtitle: l10n.gardenPageSubtitle,
      children: [
        if (learners.where((item) => !item.isArchived).length > 1) ...[
          _SectionCard(
            title: l10n.gardenPageLearnerSectionTitle,
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
          const SizedBox(height: 14),
        ],
        _GardenHeroCard(garden: garden, scene: scene),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageNextGrowthTitle,
          child: _NextGrowthCard(garden: garden),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageBreakdownTitle,
          // Two even columns rather than fixed-width tiles, so these match
          // the full-width cards around them instead of leaving a ragged
          // gap at the end of each row.
          child: Column(
            children: [
              for (var row = 0; row < garden.dimensions.length; row += 2)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: row + 2 < garden.dimensions.length ? 10 : 0,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _DimensionCard(
                            dimension: garden.dimensions[row],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: row + 1 < garden.dimensions.length
                              ? _DimensionCard(
                                  dimension: garden.dimensions[row + 1],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageInsightTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: garden.insights
                .map(
                  (insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _InsightRow(
                      icon: _iconForDimension(insight.dimension),
                      body: _localizedInsight(l10n, insight.messageKey),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageRecentGrowthTitle,
          child: garden.recentGrowth.isEmpty
              ? Text(l10n.gardenPageRecentGrowthEmpty)
              : Column(
                  children: garden.recentGrowth
                      .map((item) => _RecentGrowthTile(item: item))
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageMilestonesTitle,
          child: SizedBox(
            height: 214,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: garden.milestones.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final visual = garden.milestones[index];
                return _MilestoneTile(visual: visual);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.gardenPageHowItWorksTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MeaningLine(
                icon: Icons.account_tree_rounded,
                title: l10n.gardenPagePrayerMeaningTitle,
                body: l10n.gardenPagePrayerMeaningBody,
              ),
              const SizedBox(height: 10),
              _MeaningLine(
                icon: Icons.auto_stories_rounded,
                title: l10n.gardenPageLearningMeaningTitle,
                body: l10n.gardenPageLearningMeaningBody,
              ),
              const SizedBox(height: 10),
              _MeaningLine(
                icon: Icons.wb_sunny_rounded,
                title: l10n.gardenPageLightMeaningTitle,
                body: l10n.gardenPageLightMeaningBody,
              ),
              const SizedBox(height: 10),
              _MeaningLine(
                icon: Icons.water_drop_rounded,
                title: l10n.gardenPageDropsMeaningTitle,
                body: l10n.gardenPageDropsMeaningBody,
              ),
              const SizedBox(height: 10),
              _MeaningLine(
                icon: AppIcons.reflection,
                title: l10n.gardenPageFruitMeaningTitle,
                body: l10n.gardenPageFruitMeaningBody,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static IconData _iconForDimension(GardenGrowthDimension dimension) {
    return switch (dimension) {
      GardenGrowthDimension.prayerFoundation => Icons.account_tree_rounded,
      GardenGrowthDimension.learningGrowth => Icons.auto_stories_rounded,
      GardenGrowthDimension.remembranceLight => Icons.wb_sunny_rounded,
      GardenGrowthDimension.mercyWater => Icons.water_drop_rounded,
      GardenGrowthDimension.wisdomFruit => AppIcons.reflection,
      GardenGrowthDimension.consistencyBloom => Icons.calendar_month_rounded,
    };
  }

  static String _localizedInsight(AppLocalizations l10n, String key) {
    return switch (key) {
      'gardenInsightPrayer' => l10n.gardenInsightPrayer,
      'gardenInsightLearning' => l10n.gardenInsightLearning,
      'gardenInsightLight' => l10n.gardenInsightLight,
      'gardenInsightWater' => l10n.gardenInsightWater,
      'gardenInsightFruit' => l10n.gardenInsightFruit,
      'gardenInsightConsistency' => l10n.gardenInsightConsistency,
      _ => key,
    };
  }
}

/// The quiet caption under the vista when the garden has changed since the
/// last visit — a note, never a popup or a reward screen.
class _NewGrowthNote extends StatelessWidget {
  const _NewGrowthNote({required this.scene});

  final GardenSceneSpec scene;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final tint = appearance?.accent ?? theme.colorScheme.primary;
    final title = scene.newlyAppeared.isNotEmpty
        ? l10n.gardenVistaNewGrowthTitle
        : l10n.gardenVistaStageAdvancedTitle;
    final named = <String>[
      for (final id in [...scene.newlyAppeared, ...scene.newlyGrown].take(3))
        GardenElementStrings.title(l10n, id),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome_rounded, size: 18, color: tint),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                named.isEmpty
                    ? l10n.gardenVistaNewGrowthBody
                    : named.join(' · '),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GardenHeroCard extends StatelessWidget {
  const _GardenHeroCard({required this.garden, required this.scene});

  final GardenState garden;
  final GardenSceneSpec scene;

  /// Current strength of whatever grows this element, for the detail sheet.
  static double _dimensionScore(
    GardenState garden,
    GardenSceneElementSpec element,
  ) {
    final dimension = element.dimension;
    if (dimension == null) {
      return (garden.maturityPercent / 100).clamp(0.0, 1.0);
    }
    for (final state in garden.dimensions) {
      if (state.dimension == dimension) {
        return state.score;
      }
    }
    return switch (dimension) {
      GardenGrowthDimension.prayerFoundation => garden.prayerFoundationScore,
      GardenGrowthDimension.learningGrowth => garden.learningGrowthScore,
      GardenGrowthDimension.remembranceLight => garden.remembranceLightScore,
      GardenGrowthDimension.consistencyBloom => garden.consistencyScore,
      GardenGrowthDimension.wisdomFruit => garden.wisdomFruitScore,
      GardenGrowthDimension.mercyWater => (garden.totalOceanDrops / 1000).clamp(
        0.0,
        1.0,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = NumberFormat.decimalPattern(locale);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(
              aspectRatio: 1.45,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: GardenVistaView(
                      spec: scene,
                      manageSeenLifecycle: true,
                      onElementTap: (element) => showGardenElementMeaningSheet(
                        context,
                        element: element,
                        dimensionScore: _dimensionScore(garden, element),
                      ),
                      semanticLabel:
                          '${_localizedStageTitle(l10n, garden.currentVisualStage.stageId)} · ${l10n.gardenPageMaturityValue('${garden.maturityPercent}')}',
                    ),
                  ),
                  // Scrim and caption must not swallow taps meant for the
                  // plants and creatures beneath them.
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF1E1915).withValues(alpha: 0.48),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: IgnorePointer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _localizedStageTitle(
                              l10n,
                              garden.currentVisualStage.stageId,
                            ),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _localizedAmbientLabel(l10n, garden.ambientState),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (scene.hasNewGrowth)
            _NewGrowthNote(scene: scene)
          else
            Text(
              l10n.gardenVistaExploreHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: 14),
          Text(
            l10n.gardenPageHeroTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.gardenPageHeroBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroPill(
                label: l10n.gardenPageLevelLabel,
                value: numberFormat.format(garden.currentGardenLevel),
              ),
              _HeroPill(
                label: l10n.gardenPageXpLabel,
                value: numberFormat.format(garden.totalXp),
              ),
              _HeroPill(
                label: l10n.gardenPageTotalDrops,
                value: numberFormat.format(garden.totalOceanDrops),
              ),
              _HeroPill(
                label: l10n.gardenPageMaturityLabel,
                value: l10n.gardenPageMaturityValue(
                  '${garden.maturityPercent}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _localizedAmbientLabel(
    AppLocalizations l10n,
    GardenAmbientState state,
  ) {
    return switch (state) {
      GardenAmbientState.quietDawn => l10n.gardenAmbientQuietDawn,
      GardenAmbientState.gentleMorning => l10n.gardenAmbientGentleMorning,
      GardenAmbientState.warmLight => l10n.gardenAmbientWarmLight,
      GardenAmbientState.eveningGlow => l10n.gardenAmbientEveningGlow,
    };
  }

  static String _localizedStageTitle(
    AppLocalizations l10n,
    GardenVisualStageId stageId,
  ) => GardenElementStrings.stageTitle(l10n, stageId);
}

class _NextGrowthCard extends StatelessWidget {
  const _NextGrowthCard({required this.garden});

  final GardenState garden;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nextStage = garden.nextVisualStage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nextStage == null
              ? l10n.gardenPageAllUnlockedTitle
              : l10n.gardenPageNextGrowthValue(
                  _GardenHeroCard._localizedStageTitle(l10n, nextStage.stageId),
                ),
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          nextStage == null
              ? l10n.gardenPageAllUnlockedBody
              : l10n.gardenPageNextGrowthSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: garden.progressToNextStage,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension});

  final GardenDimensionState dimension;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            GardenPage._iconForDimension(dimension.dimension),
            color: const Color(0xFF72553C),
          ),
          const SizedBox(height: 8),
          Text(
            _dimensionTitle(l10n, dimension.dimension),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            _dimensionBody(l10n, dimension.dimension),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: dimension.score,
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.gardenPageDimensionStrengthValue(
              '${dimension.emphasisPercent}',
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _dimensionTitle(
    AppLocalizations l10n,
    GardenGrowthDimension dimension,
  ) {
    return switch (dimension) {
      GardenGrowthDimension.prayerFoundation => l10n.gardenDimensionPrayerTitle,
      GardenGrowthDimension.learningGrowth => l10n.gardenDimensionLearningTitle,
      GardenGrowthDimension.remembranceLight => l10n.gardenDimensionLightTitle,
      GardenGrowthDimension.mercyWater => l10n.gardenDimensionWaterTitle,
      GardenGrowthDimension.wisdomFruit => l10n.gardenDimensionFruitTitle,
      GardenGrowthDimension.consistencyBloom =>
        l10n.gardenDimensionConsistencyTitle,
    };
  }

  String _dimensionBody(
    AppLocalizations l10n,
    GardenGrowthDimension dimension,
  ) {
    return switch (dimension) {
      GardenGrowthDimension.prayerFoundation => l10n.gardenDimensionPrayerBody,
      GardenGrowthDimension.learningGrowth => l10n.gardenDimensionLearningBody,
      GardenGrowthDimension.remembranceLight => l10n.gardenDimensionLightBody,
      GardenGrowthDimension.mercyWater => l10n.gardenDimensionWaterBody,
      GardenGrowthDimension.wisdomFruit => l10n.gardenDimensionFruitBody,
      GardenGrowthDimension.consistencyBloom =>
        l10n.gardenDimensionConsistencyBody,
    };
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.icon, required this.body});

  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF72553C)),
        const SizedBox(width: 10),
        Expanded(child: Text(body)),
      ],
    );
  }
}

class _RecentGrowthTile extends StatelessWidget {
  const _RecentGrowthTile({required this.item});

  final GardenRecentGrowthItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);
    final parsedDate = DateTime.tryParse(item.occurredAtIso);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _activityIcon(item.activityType),
        color: const Color(0xFF72553C),
      ),
      title: Text(_activityLabel(l10n, item.activityType)),
      subtitle: Text(
        parsedDate == null
            ? l10n.gardenPageRecentGrowthJustNow
            : dateFormat.format(parsedDate),
      ),
      trailing: Text(
        l10n.gardenPageRecentGrowthTracked,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  IconData _activityIcon(LearnerProgressionActivityType type) {
    return switch (type) {
      LearnerProgressionActivityType.kidsArabicLessonCompletion =>
        Icons.draw_rounded,
      LearnerProgressionActivityType.kidsArabicDailyMissionCompletion =>
        Icons.wb_sunny_rounded,
      LearnerProgressionActivityType.bedtimeStoryCompletion =>
        Icons.auto_stories_rounded,
      LearnerProgressionActivityType.bedtimeQuizCompletion =>
        Icons.quiz_rounded,
      LearnerProgressionActivityType.bedtimeMemoryCompletion =>
        Icons.style_rounded,
      LearnerProgressionActivityType.duaLessonCompletion =>
        Icons.favorite_border_rounded,
      LearnerProgressionActivityType.duaPracticeCompletion =>
        Icons.repeat_rounded,
      LearnerProgressionActivityType.duaMyDayCompletion =>
        Icons.wb_sunny_rounded,
      LearnerProgressionActivityType.bedtimeRoutineCompletion =>
        Icons.bedtime_rounded,
      LearnerProgressionActivityType.seerahNodeCompletion =>
        Icons.timeline_rounded,
      LearnerProgressionActivityType.seerahStageCompletion =>
        Icons.flag_rounded,
      LearnerProgressionActivityType.seerahJourneyCompletion =>
        Icons.route_rounded,
    };
  }

  String _activityLabel(
    AppLocalizations l10n,
    LearnerProgressionActivityType type,
  ) {
    return switch (type) {
      LearnerProgressionActivityType.kidsArabicLessonCompletion =>
        l10n.gardenRecentKidsArabicLesson,
      LearnerProgressionActivityType.kidsArabicDailyMissionCompletion =>
        l10n.gardenRecentKidsArabicDaily,
      LearnerProgressionActivityType.bedtimeStoryCompletion =>
        l10n.gardenRecentStory,
      LearnerProgressionActivityType.bedtimeQuizCompletion =>
        l10n.gardenRecentQuiz,
      LearnerProgressionActivityType.bedtimeMemoryCompletion =>
        l10n.gardenRecentMemory,
      LearnerProgressionActivityType.duaLessonCompletion =>
        l10n.gardenRecentDuaLesson,
      LearnerProgressionActivityType.duaPracticeCompletion =>
        l10n.gardenRecentDuaPractice,
      LearnerProgressionActivityType.duaMyDayCompletion =>
        l10n.gardenRecentDuaDay,
      LearnerProgressionActivityType.bedtimeRoutineCompletion =>
        l10n.gardenRecentRoutine,
      LearnerProgressionActivityType.seerahNodeCompletion =>
        l10n.gardenRecentSeerahNode,
      LearnerProgressionActivityType.seerahStageCompletion =>
        l10n.gardenRecentSeerahStage,
      LearnerProgressionActivityType.seerahJourneyCompletion =>
        l10n.gardenRecentSeerahJourney,
    };
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.visual});

  final GardenMilestoneVisual visual;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: 168,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // Milestone art is the reward for reaching it: until then the
                // tile stays covered rather than showing a dimmed preview.
                child: visual.unlocked
                    ? Image.asset(
                        visual.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE7D7AE), Color(0xFF8BA06B)],
                              ),
                            ),
                            child: Center(child: Icon(AppIcons.garden)),
                          );
                        },
                      )
                    : DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFE9E2D6), Color(0xFFD9D0C2)],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.lock_rounded,
                            size: 26,
                            color: const Color(
                              0xFF6A5A4A,
                            ).withValues(alpha: 0.42),
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _milestoneTitle(l10n, visual.milestone.titleKey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visual.unlocked
                          ? l10n.gardenGalleryUnlocked
                          : l10n.gardenGalleryLockedAtValue(
                              '${visual.milestone.requiredDrops}',
                            ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _milestoneTitle(AppLocalizations l10n, String key) {
    return switch (key) {
      'gardenMilestoneTitle1' => l10n.gardenMilestoneTitle1,
      'gardenMilestoneTitle2' => l10n.gardenMilestoneTitle2,
      'gardenMilestoneTitle3' => l10n.gardenMilestoneTitle3,
      'gardenMilestoneTitle4' => l10n.gardenMilestoneTitle4,
      'gardenMilestoneTitle5' => l10n.gardenMilestoneTitle5,
      'gardenMilestoneTitle6' => l10n.gardenMilestoneTitle6,
      'gardenMilestoneTitle7' => l10n.gardenMilestoneTitle7,
      'gardenMilestoneTitle8' => l10n.gardenMilestoneTitle8,
      'gardenMilestoneTitle9' => l10n.gardenMilestoneTitle9,
      'gardenMilestoneTitle10' => l10n.gardenMilestoneTitle10,
      _ => key,
    };
  }
}

class _MeaningLine extends StatelessWidget {
  const _MeaningLine({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF72553C)),
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
              const SizedBox(height: 3),
              Text(body, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5D5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
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
