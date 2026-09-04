import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../../shared/widgets/app_hero_glass_shell.dart';
import '../application/family_learning_provider.dart';
import '../application/learn_together_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../application/learning_path_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../presentation/widgets/learn_contained_state_page.dart';
import '../../shared/application/learn_release_gate.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/learning_journey_models.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyDetailPage extends ConsumerWidget {
  const LearningJourneyDetailPage({
    super.key,
    required this.journeyId,
    this.currentStageId,
  });

  final String journeyId;
  final String? currentStageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final journey = LearningJourneyRegistry.journeyById(journeyId);
    if (journey == null) {
      return _LearningJourneyDetailMissingPage(l10n: l10n);
    }
    if (!isProductionSafeLearningJourney(journey)) {
      return LearnContainedStatePage(
        title: localizedJourneyTitle(context, journey),
        subtitle: l10n.learnContainedStateJourneySubtitle,
        body: l10n.learnContainedStateBody,
        primaryActionLabel: l10n.learnContainedStateBackToLearnAction,
        onPrimaryAction: () => context.go('/learn'),
        secondaryActionLabel: l10n.learnContainedStateOpenQuranLearningAction,
        onSecondaryAction: () => context.pushNamed('quranLearningHub'),
      );
    }
    final stages = LearningJourneyRegistry.stagesForJourney(journey.id);
    final progress = ref.watch(learningJourneyProgressProvider);
    final pathState = ref.watch(learningPathStateProvider);
    final familyContext = ref.watch(activeFamilyLearningContextProvider);
    final learnTogetherEligible = ref
        .watch(learnTogetherEligibleJourneyIdsProvider)
        .contains(journey.id);
    final readyCount = stages
        .where((item) => item.status == LearningJourneyStageStatus.real)
        .length;
    final partialCount = stages
        .where((item) => item.status == LearningJourneyStageStatus.partial)
        .length;
    final plannedCount = stages
        .where((item) => item.status == LearningJourneyStageStatus.placeholder)
        .length;
    final completedStageIds = progress.completedStageIds
        .where((stageId) => stages.any((stage) => stage.id == stageId))
        .toSet();
    final preferredStageId =
        currentStageId ??
        (progress.lastOpenedJourneyId == journey.id
            ? progress.lastOpenedStageId
            : null);
    final activeStageId =
        resolveAccessibleLearningJourneyStageId(
          journey: journey,
          preferredStageId: preferredStageId,
          completedStageIds: completedStageIds,
        ) ??
        stages.first.id;
    final progressValue = stages.isEmpty
        ? 0.0
        : (completedStageIds.length / stages.length).clamp(0.0, 1.0);
    final isComplete =
        stages.isNotEmpty && completedStageIds.length == stages.length;
    final primaryStage = stages.firstWhere(
      (stage) => stage.id == activeStageId,
      orElse: () => stages.first,
    );
    final pathPhase = pathState?.phaseForJourney(journey.id);
    final pathNextJourney = pathState?.path.phases
        .expand((phase) => phase.journeyIds)
        .where(
          (id) =>
              id != journey.id && !pathState.completedJourneyIds.contains(id),
        )
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .firstOrNull;

    return LearnHubPageScaffold(
      title: localizedJourneyTitle(context, journey),
      subtitle: localizedJourneySubtitle(context, journey),
      children: [
        if (pathState != null && pathState.containsJourney(journey.id)) ...[
          _SectionBlock(
            title: l10n.learningPathJourneyTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learningPathJourneyPartOfPath(
                    LearningPathRegistry.localizedPathTitle(
                      l10n,
                      pathState.path,
                    ),
                  ),
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
                if (pathPhase != null) ...[
                  const SizedBox(height: 8),
                  _ProgressChip(
                    label: l10n.learningPathJourneyPhaseLabel(
                      LearningPathRegistry.localizedPhaseTitle(l10n, pathPhase),
                    ),
                    color: const Color(0xFFE7EEE1),
                    textColor: const Color(0xFF4C6540),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        _SectionBlock(
          title: l10n.learningJourneyDetailAboutTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ProgressChip(
                    label: _difficultyLabel(journey.difficulty, l10n),
                    color: const Color(0xFFEADCC7),
                    textColor: const Color(0xFF755937),
                  ),
                  _ProgressChip(
                    label: l10n.learningJourneyDurationMinutes(
                      journey.estimatedDurationMinutes,
                    ),
                    color: const Color(0xFFF1E7D9),
                    textColor: const Color(0xFF7A6243),
                  ),
                  _ProgressChip(
                    label: l10n.learningJourneyDetailLessonCount(
                      journey.totalLessons,
                    ),
                    color: const Color(0xFFF4EBDE),
                    textColor: context.palette.onSurfaceSubtle,
                  ),
                  if (journey.isFeatured)
                    _ProgressChip(
                      label: l10n.learningJourneyFeaturedBadge,
                      color: const Color(0xFFE7EEE1),
                      textColor: const Color(0xFF4C6540),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                localizedJourneyDescription(context, journey),
                style: TextStyle(
                  color: context.palette.onSurfaceSubtle,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.learningJourneyDetailLearnTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF312920),
                ),
              ),
              const SizedBox(height: 10),
              ...localizedJourneyLearningOutcomes(context, journey)
                  .take(kidsUi.enabled ? 3 : 4)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle_rounded,
                              size: 7,
                              color: context.palette.onSurfaceSubtle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                color: context.palette.onSurfaceSubtle,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              if (localizedJourneyWhyThisMatters(context, journey) != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.learningJourneyDetailWhyThisMattersTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF312920),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizedJourneyWhyThisMatters(context, journey)!,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionBlock(
          title: kidsUi.enabled
              ? l10n.kidsJourneyDetailProgressTitle
              : l10n.learningJourneyDetailProgressTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JourneyProgressBar(
                value: progressValue,
                label: l10n.learningJourneyDetailProgressLabel(
                  completedStageIds.length,
                  stages.length,
                ),
              ),
              if (!kidsUi.enabled) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ProgressChip(
                      label: l10n.learningJourneyDetailReadyChip(readyCount),
                      color: const Color(0xFFE2ECDD),
                      textColor: const Color(0xFF4E7241),
                    ),
                    if (partialCount > 0)
                      _ProgressChip(
                        label: l10n.learningJourneyDetailPartialChip(
                          partialCount,
                        ),
                        color: const Color(0xFFF3E8D9),
                        textColor: const Color(0xFF8B653A),
                      ),
                    if (plannedCount > 0)
                      _ProgressChip(
                        label: l10n.learningJourneyDetailPlannedChip(
                          plannedCount,
                        ),
                        color: const Color(0xFFEAE5E0),
                        textColor: const Color(0xFF6C6257),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (isComplete) ...[
          const SizedBox(height: 14),
          _SectionBlock(
            title: l10n.learningJourneyDetailCompletionTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learningJourneyDetailCompletionSubtitle,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
                if (pathNextJourney != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.learningPathNextJourneyLabel(
                      localizedJourneyTitle(context, pathNextJourney),
                    ),
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (learnTogetherEligible &&
            familyContext.activeGuardianProfileId != null &&
            familyContext.familyGroup != null &&
            familyContext.familyGroup!.childProfileIds.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionBlock(
            title: l10n.learnTogetherTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnTogetherJourneyIntro,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: familyContext.familyGroup!.childProfileIds
                      .map((childId) {
                        final child = ref
                            .read(familyLearningProvider)
                            .childProfiles[childId];
                        if (child == null) {
                          return const SizedBox.shrink();
                        }
                        return FilledButton.tonalIcon(
                          onPressed: () async {
                            await ref
                                .read(learnTogetherProvider.notifier)
                                .startSession(
                                  childProfileId: child.id,
                                  journeyId: journey.id,
                                  stageId: primaryStage.id,
                                );
                            if (!context.mounted) {
                              return;
                            }
                            context.pushNamed(
                              'learnJourneyStage',
                              pathParameters: {
                                'journeyId': journey.id,
                                'stageId': primaryStage.id,
                              },
                              queryParameters: {
                                'learnTogetherChildProfileId': child.id,
                              },
                            );
                          },
                          icon: const Icon(Icons.family_restroom_rounded),
                          label: Text(
                            l10n.learnTogetherStartWithChild(child.displayName),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
        if (journey.relatedTools.isNotEmpty && !kidsUi.enabled) ...[
          const SizedBox(height: 14),
          RelatedToolsSection(
            title: l10n.learningJourneyDetailRelatedToolsTitle,
            subtitle: l10n.learningJourneyDetailRelatedToolsSubtitle,
            tools: journey.relatedTools,
          ),
        ],
        if (localizedJourneyMappingNotes(context, journey).isNotEmpty &&
            !kidsUi.enabled) ...[
          const SizedBox(height: 14),
          _SectionBlock(
            title: l10n.learningJourneyDetailCurrentMappingTitle,
            child: Text(
              localizedJourneyMappingNotes(context, journey),
              style: TextStyle(
                color: context.palette.onSurfaceSubtle,
                height: 1.35,
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        JourneyHomeSectionHeader(
          title: l10n.learningJourneyDetailStagesTitle,
          subtitle: l10n.learningJourneyDetailStagesSubtitle,
        ),
        const SizedBox(height: 12),
        ...stages.map(
          (stage) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LearningJourneyStageCard(
              stage: stage,
              isCurrent: stage.id == activeStageId,
              isCompleted: completedStageIds.contains(stage.id),
              isLocked:
                  !completedStageIds.contains(stage.id) &&
                  !isLearningJourneyStageUnlocked(
                    journey: journey,
                    stageId: stage.id,
                    completedStageIds: completedStageIds,
                  ),
              onTap:
                  completedStageIds.contains(stage.id) ||
                      isLearningJourneyStageUnlocked(
                        journey: journey,
                        stageId: stage.id,
                        completedStageIds: completedStageIds,
                      )
                  ? () => context.pushNamed(
                      'learnJourneyStage',
                      pathParameters: {
                        'journeyId': journey.id,
                        'stageId': stage.id,
                      },
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
        AppHeroGlassShell(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
          tintColor: context.palette.accent,
          surfaceAlphaOverride: 0.2,
          radius: 36,
          borderColor: const Color(0x42FFFFFF),
          highlightGradientColors: const [
            Color(0x24FFFFFF),
            Colors.transparent,
            Color(0x16E8C98F),
          ],
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                if (isComplete && pathNextJourney != null) {
                  context.pushNamed(
                    'learnJourneyDetail',
                    pathParameters: {'journeyId': pathNextJourney.id},
                  );
                  return;
                }
                context.pushNamed(
                  'learnJourneyStage',
                  pathParameters: {
                    'journeyId': journey.id,
                    'stageId': isComplete ? stages.last.id : activeStageId,
                  },
                );
              },
              icon: Icon(
                isComplete
                    ? (pathNextJourney != null
                          ? Icons.route_rounded
                          : Icons.replay_rounded)
                    : completedStageIds.isEmpty
                    ? Icons.play_arrow_rounded
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(
                isComplete
                    ? (pathNextJourney != null
                          ? l10n.learningPathNextJourneyAction
                          : l10n.learningJourneyDetailActionReviewJourney)
                    : completedStageIds.isEmpty
                    ? l10n.learningJourneyDetailActionStart
                    : l10n.learningJourneyDetailActionContinue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _difficultyLabel(
  LearningJourneyDifficulty difficulty,
  AppLocalizations l10n,
) {
  return switch (difficulty) {
    LearningJourneyDifficulty.beginner =>
      l10n.learningJourneyDifficultyBeginner,
    LearningJourneyDifficulty.intermediate =>
      l10n.learningJourneyDifficultyIntermediate,
    LearningJourneyDifficulty.advanced =>
      l10n.learningJourneyDifficultyAdvanced,
  };
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12.2,
        ),
      ),
    );
  }
}

class _LearningJourneyDetailMissingPage extends StatelessWidget {
  const _LearningJourneyDetailMissingPage({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      title: l10n.learningJourneyDetailMissingTitle,
      subtitle: l10n.learningJourneyDetailMissingSubtitle,
      children: [
        Text(
          l10n.learningJourneyDetailMissingBody,
          style: TextStyle(color: context.palette.onSurfaceSubtle),
        ),
      ],
    );
  }
}
