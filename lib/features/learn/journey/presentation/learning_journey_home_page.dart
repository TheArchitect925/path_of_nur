import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../application/family_learning_provider.dart';
import '../application/learn_together_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../application/learning_path_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/family_learning_models.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyHomePage extends ConsumerWidget {
  const LearningJourneyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final familyContext = ref.watch(activeFamilyLearningContextProvider);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final switcherProfiles = ref.watch(familyLearningSwitcherProfilesProvider);
    final guardianChildren = ref.watch(
      familyLearningChildProfilesForGuardianProvider,
    );
    final learnTogetherState = ref.watch(learnTogetherProvider);
    final activeProfile = ref.watch(
      accountsSyncControllerProvider.select((state) => state.activeProfile),
    );
    final visibilityPolicy = familyContext.visibilityPolicy;
    final islands = [...LearningJourneyRegistry.islands]
      ..sort((a, b) => a.order.compareTo(b.order))
      ..removeWhere(
        (island) => !learningVisibilityAllowsIsland(visibilityPolicy, island),
      );
    final continueState = ref.watch(learningJourneyContinueProvider);
    final todayLight = ref.watch(learningJourneyTodayLightProvider);
    final recommendations = ref.watch(learningJourneyRecommendationsProvider);
    final progress = ref.watch(learningJourneyProgressProvider);
    final learningCommunity = ref.watch(learningCommunitySummaryProvider);
    final pathState = ref.watch(learningPathStateProvider);
    final adaptiveGuidance = ref.watch(learningPathAdaptiveGuidanceProvider);
    final continueJourneyLabel = _continueJourneyTitle(
      context,
      continueState,
      l10n,
    );
    final continueStageTitle = _continueJourneySubtitle(
      context,
      continueState,
      l10n,
    );
    final personalizedTodayJourney = adaptiveGuidance?.personalizedTodayJourney;
    final pathRecommendations = pathState == null
        ? const <LearningJourney>[]
        : adaptiveGuidance?.recommendedJourneys ?? const <LearningJourney>[];
    final rawRecommendations = pathState == null
        ? recommendations.journeys.take(4).toList(growable: false)
        : pathRecommendations;
    final displayRecommendations = rawRecommendations
        .where(
          (journey) =>
              learningVisibilityAllowsJourney(visibilityPolicy, journey),
        )
        .take(
          kidsUi.enabled
              ? 2
              : visibilityPolicy.isChildProfile
              ? 3
              : 4,
        )
        .toList(growable: false);
    final fallbackJourneys =
        adaptiveGuidance?.fallbackJourneys
            .where(
              (journey) =>
                  learningVisibilityAllowsJourney(visibilityPolicy, journey),
            )
            .toList(growable: false) ??
        const <LearningJourney>[];
    final secondaryJourneys =
        adaptiveGuidance?.secondaryJourneys
            .where(
              (journey) =>
                  learningVisibilityAllowsJourney(visibilityPolicy, journey),
            )
            .toList(growable: false) ??
        const <LearningJourney>[];
    final starterJourney = _resolveStarterJourney(
      visibilityPolicy: visibilityPolicy,
      displayRecommendations: displayRecommendations,
      fallbackJourneys: fallbackJourneys,
    );
    final safeTodayJourney = _resolveSafeTodayJourney(
      visibilityPolicy,
      personalizedTodayJourney,
      pathState,
      displayRecommendations,
      fallbackJourneys,
    );
    final todayLightTitle = safeTodayJourney != null
        ? localizedJourneyTitle(context, safeTodayJourney)
        : todayLight.title.isNotEmpty
        ? todayLight.title
        : _localizedTodayLightTitle(todayLight.kind, l10n);
    final todayLightSubtitle = safeTodayJourney != null
        ? l10n.learningPathTodayLightSubtitle(
            localizedJourneySubtitle(context, safeTodayJourney),
          )
        : todayLight.subtitle.isNotEmpty
        ? todayLight.subtitle
        : _localizedTodayLightSubtitle(todayLight.kind, l10n);
    final todayLightBadge = safeTodayJourney != null
        ? l10n.learningPathTodayLightBadge
        : _localizedTodayLightBadge(todayLight.kind, l10n);
    return LearnHubPageScaffold(
      headerIcon: Icons.hub_rounded,
      title: l10n.learningJourneyHomeTitle,
      subtitle: l10n.learningJourneyHomeSubtitle,
      quote: buildLearningCompactQuote(),
      children: [
        if (switcherProfiles.length > 1 || guardianChildren.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _LearningProfileSwitcherCard(
              title: familyContext.isChildProfile
                  ? l10n.familyLearningHomeChildTitle(
                      familyContext.activeChildProfile!.displayName,
                    )
                  : l10n.familyLearningHomeGuardianTitle,
              subtitle: familyContext.isChildProfile
                  ? l10n.familyLearningHomeChildSubtitle
                  : guardianChildren.isEmpty
                  ? l10n.familyLearningHomeGuardianEmptySubtitle
                  : l10n.familyLearningHomeGuardianSubtitle(
                      guardianChildren.length,
                    ),
              currentProfileName:
                  activeProfile?.displayName ??
                  l10n.familyLearningNoGuardianSelected,
              onSwitch: () => _showLearningProfileSwitcher(context, ref),
              onManage:
                  guardianChildren.isNotEmpty && !familyContext.isChildProfile
                  ? () => context.pushNamed('learnFamilyManagement')
                  : null,
            ),
          ),
        if (continueState.hasJourney &&
            continueState.journey != null &&
            continueState.stage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ContinueJourneyCard(
              title: continueJourneyLabel,
              stageTitle: continueStageTitle,
              progressLabel: continueState.journeyCompleted
                  ? _journeyHomeCompletedBadge(l10n, kidsUi.enabled)
                  : _journeyHomeContinueBadge(l10n, kidsUi.enabled),
              progress: _journeyProgressValue(
                continueState.journey!.stageIds.length,
                progress.completedStageIds
                    .where((id) => continueState.journey!.stageIds.contains(id))
                    .length,
              ),
              ctaLabel: continueState.journeyCompleted
                  ? _journeyHomeExploreNextAction(l10n, kidsUi.enabled)
                  : _journeyHomeContinueAction(l10n, kidsUi.enabled),
              onTap: () => context.pushNamed(
                'learnJourneyStage',
                pathParameters: {
                  'journeyId': continueState.journey!.id,
                  'stageId': continueState.stage!.id,
                },
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ContinueJourneyCard(
              title: _journeyHomeStartTitle(l10n, kidsUi.enabled),
              stageTitle: _journeyHomeStartSubtitle(l10n, kidsUi.enabled),
              progressLabel: null,
              progress: null,
              ctaLabel: _journeyHomeExploreJourneys(l10n, kidsUi.enabled),
              onTap: starterJourney == null
                  ? () => context.pushNamed('learnExploreAllKnowledge')
                  : () => context.pushNamed(
                      'learnJourneyDetail',
                      pathParameters: {'journeyId': starterJourney.id},
                    ),
            ),
          ),
        const SizedBox(height: 14),
        _TodayLightCard(
          title: todayLightTitle,
          badge: todayLightBadge,
          subtitle: todayLightSubtitle,
          onTap: () {
            final streakChanged = ref
                .read(learningJourneyProgressProvider.notifier)
                .markTodayLightOpened(todayLight.id);
            if (streakChanged) {
              final updatedProgress = ref.read(learningJourneyProgressProvider);
              if (updatedProgress.currentStreakDays > 0) {
                final streakMessage = kidsUi.enabled
                    ? l10n.kidsJourneyHomeStreakMessage(
                        updatedProgress.currentStreakDays,
                      )
                    : l10n.learningJourneyHomeStreakMessage(
                        updatedProgress.currentStreakDays,
                      );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      [
                        streakMessage,
                        kidsUi.enabled
                            ? l10n.learningCommunityFeedbackTodayLightKids
                            : l10n.learningCommunityFeedbackTodayLightAdult,
                      ].join('\n'),
                    ),
                    duration: const Duration(milliseconds: 1400),
                  ),
                );
              }
            }
            if (safeTodayJourney != null) {
              ref
                  .read(learningPathSelectionProvider.notifier)
                  .recordJourneyInteraction(safeTodayJourney.id);
              context.pushNamed(
                'learnJourneyDetail',
                pathParameters: {'journeyId': safeTodayJourney.id},
              );
              return;
            }
            if (todayLight.routeName != null) {
              context.pushNamed(
                todayLight.routeName!,
                pathParameters: todayLight.pathParameters,
                queryParameters: todayLight.queryParameters,
              );
            }
          },
        ),
        const SizedBox(height: 18),
        if (learningCommunity.hasContribution ||
            familyContext.isChildProfile ||
            guardianChildren.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEE6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2D5C4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learningCommunitySummaryTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E261F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  learningCommunity.weekDrops > 0
                      ? (kidsUi.enabled
                            ? l10n.learningCommunitySummaryKidsSubtitle(
                                learningCommunity.weekDrops,
                              )
                            : familyContext.isChildProfile ||
                                  learningCommunity.learnTogetherDrops > 0
                            ? l10n.learningCommunitySummaryFamilySubtitle(
                                learningCommunity.weekDrops,
                              )
                            : l10n.learningCommunitySummarySubtitle(
                                learningCommunity.weekDrops,
                              ))
                      : l10n.learningCommunitySummaryEmpty,
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
                    height: 1.35,
                  ),
                ),
                if (learningCommunity.learnTogetherDrops > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.learningCommunitySummaryTogetherNote(
                      learningCommunity.learnTogetherDrops,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF7A6650),
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (pathState == null) ...[
          LearningJourneyToolCard(
            title: l10n.learningPathNoSelectionTitle,
            subtitle: l10n.learningPathNoSelectionSubtitle,
            icon: Icons.route_rounded,
            onTap: () => _showPathSelector(context, ref, null),
          ),
          const SizedBox(height: 18),
        ],
        if (pathState != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: JourneyHomeSectionHeader(
                  title: l10n.learningPathHomeTitle,
                  subtitle: l10n.learningPathHomeSubtitle(
                    LearningPathRegistry.localizedPathTitle(
                      l10n,
                      pathState.path,
                    ),
                  ),
                ),
              ),
              if (!visibilityPolicy.isChildProfile)
                TextButton(
                  onPressed: () => _showPathSwitcher(context, ref, pathState),
                  child: Text(l10n.learningPathChangeAction),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (adaptiveGuidance?.completedPhase != null &&
              adaptiveGuidance?.nextPhase != null) ...[
            LearningJourneyToolCard(
              title: l10n.learningPathPhaseCompletedTitle(
                LearningPathRegistry.localizedPhaseTitle(
                  l10n,
                  adaptiveGuidance!.completedPhase!,
                ),
              ),
              subtitle: l10n.learningPathPhaseCompletedSubtitle(
                LearningPathRegistry.localizedPhaseTitle(
                  l10n,
                  adaptiveGuidance.nextPhase!,
                ),
              ),
              icon: Icons.flag_rounded,
              onTap: () => context.pushNamed(
                'learnJourneyDetail',
                pathParameters: {'journeyId': pathState.primaryJourney!.id},
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EEE4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4D6C3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LearningPathRegistry.localizedPhaseTitle(
                    l10n,
                    pathState.currentPhase,
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D241A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  LearningPathRegistry.localizedPhaseDescription(
                    l10n,
                    pathState.currentPhase,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LearningPathRegistry.localizedPathDescription(
                    l10n,
                    pathState.path,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF7A6A57),
                    height: 1.35,
                    fontSize: 12.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _localizedAgeGroupHint(pathState.ageGroup, l10n),
                  style: const TextStyle(
                    color: Color(0xFF7A6A57),
                    height: 1.35,
                    fontSize: 12.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                JourneyProgressBar(
                  value: pathState.phaseProgress,
                  label: l10n.learningPathHomePhaseLabel(
                    pathState.phaseIndex + 1,
                    pathState.totalPhases,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  adaptiveGuidance?.shouldEaseLoad == true
                      ? l10n.learningPathAdaptiveEaseLoad
                      : adaptiveGuidance?.shouldSurfaceDepth == true
                      ? l10n.learningPathAdaptiveDepth
                      : l10n.learningPathAdaptiveSteady,
                  style: const TextStyle(
                    color: Color(0xFF6B5B49),
                    fontSize: 12.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...pathState.currentPhaseJourneys.map((journey) {
                  final stageCount = LearningJourneyRegistry.stagesForJourney(
                    journey.id,
                  ).length;
                  final completedCount = progress.completedStageIds
                      .where((id) => journey.stageIds.contains(id))
                      .length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LearningJourneyCard(
                      journey: journey,
                      stageCount: stageCount,
                      progress: _journeyProgressValue(
                        stageCount,
                        completedCount,
                      ),
                      onTap: () {
                        ref
                            .read(learningPathSelectionProvider.notifier)
                            .recordJourneyInteraction(journey.id);
                        context.pushNamed(
                          'learnJourneyDetail',
                          pathParameters: {'journeyId': journey.id},
                        );
                      },
                    ),
                  );
                }),
                if (pathState.primaryJourney != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: () => context.pushNamed(
                        'learnJourneyDetail',
                        pathParameters: {
                          'journeyId': pathState.primaryJourney!.id,
                        },
                      ),
                      child: Text(l10n.learningPathHomeContinueAction),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (!kidsUi.enabled &&
              visibilityPolicy.showSecondaryExploration &&
              secondaryJourneys.isNotEmpty) ...[
            JourneyHomeSectionHeader(
              title: l10n.learningPathAlsoExploringTitle,
              subtitle: l10n.learningPathAlsoExploringSubtitle,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: secondaryJourneys.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final journey = secondaryJourneys[index];
                  final stageCount = LearningJourneyRegistry.stagesForJourney(
                    journey.id,
                  ).length;
                  final completedCount = progress.completedStageIds
                      .where((id) => journey.stageIds.contains(id))
                      .length;
                  return SizedBox(
                    width: 268,
                    child: LearningJourneyCard(
                      journey: journey,
                      stageCount: stageCount,
                      progress: _journeyProgressValue(
                        stageCount,
                        completedCount,
                      ),
                      onTap: () {
                        ref
                            .read(learningPathSelectionProvider.notifier)
                            .recordJourneyInteraction(journey.id);
                        context.pushNamed(
                          'learnJourneyDetail',
                          pathParameters: {'journeyId': journey.id},
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
          ],
          if (adaptiveGuidance?.nextLevelPath != null) ...[
            LearningJourneyToolCard(
              title: l10n.learningPathCompletedTitle,
              subtitle: l10n.learningPathCompletedSubtitle(
                LearningPathRegistry.localizedPathTitle(
                  l10n,
                  adaptiveGuidance!.nextLevelPath!,
                ),
              ),
              icon: Icons.workspace_premium_rounded,
              onTap: () =>
                  _showPathSelector(context, ref, pathState.path.level),
            ),
            const SizedBox(height: 18),
          ],
        ],
        if (!familyContext.isChildProfile && guardianChildren.isNotEmpty) ...[
          LearningJourneyToolCard(
            title: l10n.learnTogetherTitle,
            subtitle: learnTogetherState.sessions.isEmpty
                ? l10n.learnTogetherHomeSubtitle
                : l10n.learnTogetherHomeContinueSubtitle,
            icon: Icons.family_restroom_rounded,
            onTap: () => context.pushNamed('learnFamilyManagement'),
          ),
          const SizedBox(height: 18),
        ] else if (familyContext.isChildProfile &&
            familyContext.activeGuardianProfileId != null &&
            continueState.stage != null &&
            ref
                .watch(learnTogetherEligibleJourneyIdsProvider)
                .contains(continueState.journey?.id ?? '')) ...[
          LearningJourneyToolCard(
            title: l10n.learnTogetherTitle,
            subtitle: l10n.learnTogetherChildHomeSubtitle,
            icon: Icons.favorite_outline_rounded,
            onTap: () => context.pushNamed(
              'learnJourneyStage',
              pathParameters: {
                'journeyId': continueState.journey!.id,
                'stageId': continueState.stage!.id,
              },
              queryParameters: {
                'learnTogetherChildProfileId':
                    familyContext.activeChildProfile!.id,
              },
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (familyContext.isChildProfile &&
            (continueState.journey != null ||
                pathState?.primaryJourney != null)) ...[
          LearningJourneyToolCard(
            title: l10n.familyLearningContinueTogetherTitle,
            subtitle: l10n.familyLearningContinueTogetherSubtitle(
              _sharedFamilyPrompt(
                l10n,
                continueState.journey?.id ?? pathState?.primaryJourney?.id,
              ),
            ),
            icon: Icons.favorite_outline_rounded,
            onTap: () => context.pushNamed('learnFamilyManagement'),
          ),
          const SizedBox(height: 18),
        ],
        if (displayRecommendations.isNotEmpty) ...[
          JourneyHomeSectionHeader(
            title: pathState == null
                ? l10n.learningJourneyHomeRecommendedTitle
                : l10n.learningPathHomeNextTitle,
            subtitle: pathState == null
                ? _recommendedJourneysSubtitle(
                    context,
                    recommendations.reason,
                    l10n,
                  )
                : adaptiveGuidance?.shouldEaseLoad == true
                ? l10n.learningPathHomeNextSubtitleEase
                : adaptiveGuidance?.shouldSurfaceDepth == true
                ? l10n.learningPathHomeNextSubtitleDepth
                : l10n.learningPathHomeNextSubtitle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 186,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayRecommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final journey = displayRecommendations[index];
                final stageCount = LearningJourneyRegistry.stagesForJourney(
                  journey.id,
                ).length;
                final completedCount = progress.completedStageIds
                    .where((id) => journey.stageIds.contains(id))
                    .length;
                return SizedBox(
                  width: 280,
                  child: LearningJourneyCard(
                    journey: journey,
                    stageCount: stageCount,
                    progress: _journeyProgressValue(stageCount, completedCount),
                    onTap: () {
                      ref
                          .read(learningPathSelectionProvider.notifier)
                          .recordJourneyInteraction(journey.id);
                      context.pushNamed(
                        'learnJourneyDetail',
                        pathParameters: {'journeyId': journey.id},
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ] else if (fallbackJourneys.isNotEmpty) ...[
          LearningJourneyToolCard(
            title: l10n.learningPathFallbackTitle,
            subtitle: l10n.learningPathFallbackSubtitle,
            icon: Icons.explore_rounded,
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': fallbackJourneys.first.id},
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (visibilityPolicy.guidedOnly || kidsUi.enabled) ...[
          LearningJourneyToolCard(
            title: l10n.familyLearningGuidedHomeTitle,
            subtitle: l10n.familyLearningGuidedHomeSubtitle,
            icon: Icons.route_rounded,
            onTap: () {
              final primaryJourney = pathState?.primaryJourney;
              if (primaryJourney == null) {
                return;
              }
              context.pushNamed(
                'learnJourneyDetail',
                pathParameters: {'journeyId': primaryJourney.id},
              );
            },
          ),
          const SizedBox(height: 10),
        ],
        if (islands.isNotEmpty) ...[
          JourneyHomeSectionHeader(
            title: l10n.learningJourneyHomeIslandsTitle,
            subtitle: l10n.learningJourneyHomeIslandsSubtitle,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: islands
                .map((island) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 42) / 2,
                    child: LearningJourneyIslandCard(
                      island: island,
                      title: localizedIslandTitle(context, island),
                      subtitle: localizedIslandSubtitle(context, island),
                      onTap: () => context.pushNamed(
                        'learnJourneyIsland',
                        pathParameters: {'islandId': island.id},
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 6),
        ],
        if (visibilityPolicy.showLegacyLearning && !kidsUi.enabled)
          LearningJourneyToolCard(
            title: l10n.learningJourneyHomeLegacyTitle,
            subtitle: l10n.learningJourneyHomeLegacySubtitle,
            icon: Icons.inventory_2_outlined,
            onTap: () => context.pushNamed('learnLegacy'),
          ),
      ],
    );
  }

  double? _journeyProgressValue(int total, int complete) {
    if (total <= 0) return null;
    return (complete / total).clamp(0.0, 1.0);
  }
}

String _localizedAgeGroupHint(
  LearningAgeGroup ageGroup,
  AppLocalizations l10n,
) {
  switch (ageGroup) {
    case LearningAgeGroup.kids:
      return l10n.learningAgeGroupHintKids;
    case LearningAgeGroup.teens:
      return l10n.learningAgeGroupHintTeens;
    case LearningAgeGroup.adults:
      return l10n.learningAgeGroupHintAdults;
  }
}

LearningJourney? _resolveSafeTodayJourney(
  FamilyLearningVisibilityPolicy policy,
  LearningJourney? personalizedTodayJourney,
  LearningPathResolvedState? pathState,
  List<LearningJourney> recommendations,
  List<LearningJourney> fallbackJourneys,
) {
  if (personalizedTodayJourney != null &&
      learningVisibilityAllowsJourney(policy, personalizedTodayJourney)) {
    return personalizedTodayJourney;
  }
  final candidates = <LearningJourney>[
    ...?pathState?.activeJourneys,
    ...recommendations,
    ...fallbackJourneys,
  ];
  for (final item in candidates) {
    if (learningVisibilityAllowsJourney(policy, item)) {
      return item;
    }
  }
  return null;
}

LearningJourney? _resolveStarterJourney({
  required FamilyLearningVisibilityPolicy visibilityPolicy,
  required List<LearningJourney> displayRecommendations,
  required List<LearningJourney> fallbackJourneys,
}) {
  final candidates = <LearningJourney>[
    ...displayRecommendations.where((journey) => journey.isFeatured),
    ...displayRecommendations,
    ...fallbackJourneys.where((journey) => journey.isFeatured),
    ...fallbackJourneys,
    ...LearningJourneyRegistry.journeys.where(
      (journey) =>
          journey.isFeatured &&
          journey.isPublished &&
          learningVisibilityAllowsJourney(visibilityPolicy, journey),
    ),
    ...LearningJourneyRegistry.journeys.where(
      (journey) =>
          journey.isPublished &&
          learningVisibilityAllowsJourney(visibilityPolicy, journey),
    ),
  ];
  final seen = <String>{};
  for (final journey in candidates) {
    if (seen.add(journey.id)) {
      return journey;
    }
  }
  return null;
}

String _sharedFamilyPrompt(AppLocalizations l10n, String? journeyId) {
  switch (journeyId) {
    case 'prophets-journey':
    case 'seerah-journey':
      return l10n.familyLearningPromptProphets;
    case 'duas-daily-life':
      return l10n.familyLearningPromptDua;
    case 'daily-dhikr':
      return l10n.familyLearningPromptDhikr;
    default:
      return l10n.familyLearningPromptGeneral;
  }
}

Future<void> _showLearningProfileSwitcher(
  BuildContext context,
  WidgetRef ref,
) async {
  final profiles = ref.read(familyLearningSwitcherProfilesProvider);
  final activeProfileId = ref.read(
    accountsSyncControllerProvider.select((state) => state.activeProfileId),
  );
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return ListTile(
              leading: CircleAvatar(child: Text(profile.avatar)),
              title: Text(profile.displayName),
              subtitle: Text(
                _localizedProfileType(
                  profile.profileType,
                  AppLocalizations.of(context),
                ),
              ),
              trailing: profile.profileId == activeProfileId
                  ? const Icon(Icons.check_circle_rounded)
                  : null,
              onTap: () async {
                await ref
                    .read(familyLearningProvider.notifier)
                    .switchToProfile(profile.profileId);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
          },
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemCount: profiles.length,
        ),
      );
    },
  );
}

String _localizedProfileType(ProfileKind kind, AppLocalizations l10n) {
  switch (kind) {
    case ProfileKind.adult:
      return l10n.familyLearningProfileTypeAdult;
    case ProfileKind.youth:
      return l10n.familyLearningProfileTypeYouth;
    case ProfileKind.child:
      return l10n.familyLearningProfileTypeChild;
    case ProfileKind.guest:
      return l10n.familyLearningProfileTypeGuest;
  }
}

class _LearningProfileSwitcherCard extends StatelessWidget {
  const _LearningProfileSwitcherCard({
    required this.title,
    required this.subtitle,
    required this.currentProfileName,
    required this.onSwitch,
    this.onManage,
  });

  final String title;
  final String subtitle;
  final String currentProfileName;
  final VoidCallback onSwitch;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0CEB4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
          ),
          const SizedBox(height: 10),
          Text(
            currentProfileName,
            style: const TextStyle(
              color: Color(0xFF866A49),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onSwitch,
                  icon: const Icon(Icons.switch_account_rounded),
                  label: Text(
                    l10n.familyLearningSwitchAction,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (onManage != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onManage,
                    icon: const Icon(Icons.family_restroom_rounded),
                    label: Text(
                      l10n.familyLearningManageAction,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ContinueJourneyCard extends StatelessWidget {
  const _ContinueJourneyCard({
    required this.title,
    required this.stageTitle,
    required this.progressLabel,
    required this.progress,
    required this.ctaLabel,
    required this.onTap,
  });

  final String title;
  final String stageTitle;
  final String? progressLabel;
  final double? progress;
  final String ctaLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0CEB4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (progressLabel != null) ...[
            Text(
              progressLabel!,
              style: const TextStyle(
                fontSize: 12.4,
                fontWeight: FontWeight.w700,
                color: Color(0xFF866A49),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            stageTitle,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            JourneyProgressBar(value: progress!, label: null),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onTap,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(ctaLabel),
          ),
        ],
      ),
    );
  }
}

class _TodayLightCard extends StatelessWidget {
  const _TodayLightCard({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String badge;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3D6C4)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DCC8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.wb_twilight_rounded,
              color: Color(0xFF71593C),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 12.2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF866A49),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF30281F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: onTap,
            child: Text(l10n.learningJourneyTodayLightOpenAction),
          ),
        ],
      ),
    );
  }
}

String _continueJourneyTitle(
  BuildContext context,
  LearningJourneyContinueState continueState,
  AppLocalizations l10n,
) {
  if (!continueState.hasJourney || continueState.journey == null) {
    return l10n.learningJourneyHomeStartFirstJourneyTitle;
  }

  if (continueState.journeyCompleted) {
    return '${localizedJourneyTitle(context, continueState.journey!)} '
        '${l10n.learningJourneyHomeCompletedSuffix}';
  }

  return localizedJourneyTitle(context, continueState.journey!);
}

String _continueJourneySubtitle(
  BuildContext context,
  LearningJourneyContinueState continueState,
  AppLocalizations l10n,
) {
  if (!continueState.hasJourney || continueState.journey == null) {
    return l10n.learningJourneyHomeStartFirstJourneySubtitle;
  }

  if (continueState.journeyCompleted &&
      continueState.suggestedNextJourney != null) {
    return l10n.learningJourneyHomeSuggestedNextIntro(
      localizedJourneyTitle(context, continueState.suggestedNextJourney!),
    );
  }

  if (continueState.journeyCompleted) {
    return l10n.learningJourneyHomeCompletedMessage;
  }

  return localizedStageTitle(context, continueState.stage!);
}

String _recommendedJourneysSubtitle(
  BuildContext context,
  LearningJourneyRecommendationReason reason,
  AppLocalizations l10n,
) {
  switch (reason) {
    case LearningJourneyRecommendationReason.worship:
      return l10n.learningJourneyHomeRecommendedReasonWorship;
    case LearningJourneyRecommendationReason.arabic:
      return l10n.learningJourneyHomeRecommendedReasonArabic;
    case LearningJourneyRecommendationReason.nearCompletion:
      return l10n.learningJourneyHomeRecommendedReasonNearCompletion;
    case LearningJourneyRecommendationReason.completed:
      return l10n.learningJourneyHomeRecommendedReasonCompleted;
    case LearningJourneyRecommendationReason.defaultJourney:
      return l10n.learningJourneyHomeRecommendedReasonDefault;
    case LearningJourneyRecommendationReason.fallback:
      return l10n.learningJourneyHomeRecommendedReasonFallback;
  }
}

Future<void> _showPathSwitcher(
  BuildContext context,
  WidgetRef ref,
  LearningPathResolvedState pathState,
) async {
  await _showPathSelector(context, ref, pathState.path.level);
}

Future<void> _showPathSelector(
  BuildContext context,
  WidgetRef ref,
  LearningPathLevel? selectedLevel,
) async {
  final l10n = AppLocalizations.of(context);
  final level = await showModalBottomSheet<LearningPathLevel>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: LearningPathRegistry.paths
              .map((path) {
                final selected = path.level == selectedLevel;
                return ListTile(
                  leading: Icon(
                    selected ? Icons.check_circle_rounded : Icons.route_rounded,
                  ),
                  title: Text(
                    LearningPathRegistry.localizedPathTitle(l10n, path),
                  ),
                  subtitle: Text(
                    LearningPathRegistry.localizedPathDescription(l10n, path),
                  ),
                  onTap: () => Navigator.of(context).pop(path.level),
                );
              })
              .toList(growable: false),
        ),
      );
    },
  );
  if (level == null || level == selectedLevel || !context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.learningPathSwitchConfirmTitle),
        content: Text(l10n.learningPathSwitchConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.learningPathSwitchCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.learningPathSwitchConfirm),
          ),
        ],
      );
    },
  );
  if (confirmed != true || !context.mounted) return;
  ref.read(learningPathSelectionProvider.notifier).setLevel(level);
}

String _localizedTodayLightBadge(TodayLightKind kind, AppLocalizations l10n) {
  switch (kind) {
    case TodayLightKind.prophet:
      return l10n.learningJourneyTodayLightBadgeProphet;
    case TodayLightKind.hadith:
      return l10n.learningJourneyTodayLightBadgeHadith;
    case TodayLightKind.verse:
      return l10n.learningJourneyTodayLightBadgeVerse;
    case TodayLightKind.reflection:
      return l10n.learningJourneyTodayLightBadgeReflection;
    case TodayLightKind.trivia:
      return l10n.learningJourneyTodayLightBadgeTrivia;
    case TodayLightKind.dhikr:
      return l10n.learningJourneyTodayLightBadgeDhikr;
  }
}

String _localizedTodayLightTitle(TodayLightKind kind, AppLocalizations l10n) {
  switch (kind) {
    case TodayLightKind.prophet:
      return l10n.learningJourneyTodayLightProphetTitleFallback;
    case TodayLightKind.hadith:
      return l10n.learningJourneyTodayLightHadithTitleFallback;
    case TodayLightKind.verse:
      return l10n.learningJourneyTodayLightVerseTitleFallback;
    case TodayLightKind.reflection:
      return l10n.learningJourneyTodayLightReflectionTitleFallback;
    case TodayLightKind.trivia:
      return l10n.learningJourneyTodayLightTriviaTitleFallback;
    case TodayLightKind.dhikr:
      return l10n.learningJourneyTodayLightDhikrTitleFallback;
  }
}

String _localizedTodayLightSubtitle(
  TodayLightKind kind,
  AppLocalizations l10n,
) {
  switch (kind) {
    case TodayLightKind.prophet:
      return l10n.learningJourneyTodayLightProphetSubtitleFallback;
    case TodayLightKind.hadith:
      return l10n.learningJourneyTodayLightHadithSubtitleFallback;
    case TodayLightKind.verse:
      return l10n.learningJourneyTodayLightVerseSubtitleFallback;
    case TodayLightKind.reflection:
      return l10n.learningJourneyTodayLightReflectionSubtitleFallback;
    case TodayLightKind.trivia:
      return l10n.learningJourneyTodayLightTriviaSubtitleFallback;
    case TodayLightKind.dhikr:
      return l10n.learningJourneyTodayLightDhikrSubtitleFallback;
  }
}

String _journeyHomeCompletedBadge(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeCompletedBadge
      : l10n.learningJourneyHomeCompletedBadge;
}

String _journeyHomeContinueBadge(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeContinueBadge
      : l10n.learningJourneyHomeContinueBadge;
}

String _journeyHomeExploreNextAction(
  AppLocalizations l10n,
  bool kidsUiEnabled,
) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeExploreNextAction
      : l10n.learningJourneyHomeExploreNextAction;
}

String _journeyHomeContinueAction(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeContinueAction
      : l10n.learningJourneyHomeContinueAction;
}

String _journeyHomeStartTitle(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeStartFirstJourneyTitle
      : l10n.learningJourneyHomeStartFirstJourneyTitle;
}

String _journeyHomeStartSubtitle(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeStartFirstJourneySubtitle
      : l10n.learningJourneyHomeStartFirstJourneySubtitle;
}

String _journeyHomeExploreJourneys(AppLocalizations l10n, bool kidsUiEnabled) {
  return kidsUiEnabled
      ? l10n.kidsJourneyHomeExploreJourneys
      : l10n.learningJourneyHomeExploreJourneys;
}
