import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../../shared/content/learning_quote.dart';
import '../application/learn_together_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../application/learning_path_provider.dart';
import '../../dua/presentation/dua_hub_page.dart';
import '../../hadith/presentation/hadith_landing_page.dart';
import '../../presentation/widgets/learn_contained_state_localizations.dart';
import '../../presentation/widgets/learn_contained_state_page.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../prophets/domain/prophets_tab.dart';
import '../../prophets/presentation/prophets_page.dart';
import '../../quran_teaching/presentation/quran_teaching_listen_only_page.dart';
import '../../quran_teaching/presentation/quran_teaching_review_page.dart';
import '../../shared/application/learn_release_gate.dart';
import '../data/learning_journey_lesson_content.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import 'learning_journey_lesson_page.dart';
import 'learning_journey_placeholder_lesson_page.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyStagePage extends ConsumerStatefulWidget {
  const LearningJourneyStagePage({
    super.key,
    required this.journeyId,
    required this.stageId,
    this.learnTogetherChildProfileId,
  });

  final String journeyId;
  final String stageId;
  final String? learnTogetherChildProfileId;

  @override
  ConsumerState<LearningJourneyStagePage> createState() =>
      _LearningJourneyStagePageState();
}

class _LearningJourneyStagePageState
    extends ConsumerState<LearningJourneyStagePage> {
  bool _redirectStarted = false;
  bool _trackingStarted = false;
  bool _firstStartNotified = false;
  Timer? _completionTimer;

  @override
  void dispose() {
    _completionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journey = LearningJourneyRegistry.journeyById(widget.journeyId);
    final stage = LearningJourneyRegistry.stageById(widget.stageId);
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    if (journey == null || stage == null || stage.journeyId != journey.id) {
      return LearnHubPageScaffold(
        headerIcon: Icons.error_outline_rounded,
        title: l10n.learningJourneyStageNotFoundTitle,
        subtitle: l10n.learningJourneyStageNotFoundSubtitle,
        children: [
          Text(
            l10n.learningJourneyStageNotFoundBody,
            style: TextStyle(color: Color(0xFF675B4E)),
          ),
        ],
      );
    }
    if (!isProductionSafeLearningJourney(journey)) {
      return LearnContainedStatePage(
        headerIcon: Icons.auto_stories_rounded,
        title: localizedStageTitle(context, stage),
        subtitle: l10n.learnContainedStateJourneySubtitle,
        body: l10n.learnContainedStateBody,
        primaryActionLabel: l10n.learningJourneyStageUnavailableFallbackTitle,
        onPrimaryAction: () => context.goNamed(
          'learnJourneyDetail',
          pathParameters: {'journeyId': journey.id},
        ),
        secondaryActionLabel: l10n.learnContainedStateOpenQuranLearningAction,
        onSecondaryAction: () => context.pushNamed('quranLearningHub'),
      );
    }

    final completedStageIds = ref.watch(
      learningJourneyProgressProvider.select(
        (state) => state.completedStageIds,
      ),
    );
    final stageUnlocked =
        completedStageIds.contains(stage.id) ||
        isLearningJourneyStageUnlocked(
          journey: journey,
          stageId: stage.id,
          completedStageIds: completedStageIds,
        );
    final accessibleStageId = resolveAccessibleLearningJourneyStageId(
      journey: journey,
      preferredStageId: stage.id,
      completedStageIds: completedStageIds,
    );

    if (!stageUnlocked && accessibleStageId != null && !_redirectStarted) {
      _redirectStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.replaceNamed(
          'learnJourneyStage',
          pathParameters: {
            'journeyId': journey.id,
            'stageId': accessibleStageId,
          },
          queryParameters: widget.learnTogetherChildProfileId == null
              ? const <String, String>{}
              : {
                  'learnTogetherChildProfileId':
                      widget.learnTogetherChildProfileId!,
                },
        );
      });
    }

    if (stageUnlocked && !_trackingStarted) {
      _trackingStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final alreadyCompleted = ref
            .read(learningJourneyProgressProvider)
            .completedStageIds
            .contains(stage.id);
        if (!alreadyCompleted && !_firstStartNotified) {
          _firstStartNotified = true;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                kidsUi.enabled
                    ? l10n.kidsJourneyFeedbackFirstStageOpened
                    : l10n.learningJourneyFeedbackFirstStageOpened,
              ),
              duration: const Duration(milliseconds: 1300),
            ),
          );
        }
        ref
            .read(learningJourneyProgressProvider.notifier)
            .recordStageOpened(journeyId: journey.id, stageId: stage.id);
        ref
            .read(learningPathSelectionProvider.notifier)
            .recordJourneyInteraction(journey.id);
        ref.read(learningPathSelectionProvider.notifier).syncProgressSignals();
        if (stage.targetType != LearningJourneyStageTargetType.existingRoute &&
            !ref
                .read(learningJourneyProgressProvider)
                .completedStageIds
                .contains(stage.id)) {
          _completionTimer = Timer(const Duration(seconds: 8), () {
            if (!mounted) return;
            final result = ref
                .read(learningJourneyProgressProvider.notifier)
                .completeStage(
                  journeyId: journey.id,
                  stageId: stage.id,
                  learnedTogether: widget.learnTogetherChildProfileId != null,
                );
            ref
                .read(learningPathSelectionProvider.notifier)
                .syncProgressSignals();
            if (widget.learnTogetherChildProfileId != null &&
                result.stageCompleted) {
              ref
                  .read(learnTogetherProvider.notifier)
                  .markLearnedTogether(
                    childProfileId: widget.learnTogetherChildProfileId!,
                    journeyId: journey.id,
                    stageId: stage.id,
                  );
            }
            if (!mounted || !result.stageCompleted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  _completionFeedbackMessage(l10n, kidsUi.enabled, result),
                ),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          });
        }
      });
    }

    if (stage.targetType == LearningJourneyStageTargetType.placeholder) {
      return LearningJourneyPlaceholderLessonPage(
        journey: journey,
        stage: stage,
        learnTogetherChildProfileId: widget.learnTogetherChildProfileId,
      );
    }

    if (stage.targetType == LearningJourneyStageTargetType.existingPage) {
      final page = _buildExistingPage(journey, stage);
      if (page != null) return page;
      return _UnavailableStagePage(journey: journey, stage: stage);
    }

    if (stage.targetType == LearningJourneyStageTargetType.existingRoute &&
        !_redirectStarted) {
      _redirectStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.replaceNamed(
          stage.targetReference!,
          pathParameters: stage.pathParameters,
          queryParameters: stage.queryParameters,
        );
      });
    }

    return LearnHubPageScaffold(
      headerIcon: Icons.open_in_new_rounded,
      title: localizedStageTitle(context, stage),
      subtitle: stageUnlocked
          ? l10n.learningJourneyStageOpeningSubtitle
          : l10n.learningJourneyStageLockedRedirectSubtitle,
      quote: buildLearningCompactQuote(),
      children: [
        SizedBox(height: 32),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: 14),
        Center(
          child: Text(
            stageUnlocked
                ? l10n.learningJourneyStageLaunchingBody
                : l10n.learningJourneyStageLockedRedirectBody,
            style: TextStyle(color: Color(0xFF675B4E)),
          ),
        ),
      ],
    );
  }

  Widget? _buildExistingPage(
    LearningJourney journey,
    LearningJourneyStage stage,
  ) {
    switch (stage.targetReference) {
      case 'journey_lesson':
        final ageGroup =
            ref.read(learningPathStateProvider)?.ageGroup ??
            LearningAgeGroup.adults;
        final lesson = LearningJourneyLessonContentRegistry.lessonForStage(
          stage.id,
          AppLocalizations.of(context),
          ageGroup: ageGroup,
        );
        if (lesson == null) return null;
        return LearningJourneyLessonPage(
          journey: journey,
          stage: stage,
          lesson: lesson,
          learnTogetherChildProfileId: widget.learnTogetherChildProfileId,
        );
      case 'prophets_home':
        return const ProphetsPage();
      case 'prophets_journey':
        return const ProphetsPage(initialTab: ProphetsTab.journey);
      case 'prophets_quiz':
        return const ProphetsPage(initialTab: ProphetsTab.quiz);
      case 'dua_hub':
        return const DuaHubPage();
      case 'hadith_themes':
        return const HadithLandingPage(initialTabName: 'themes');
      case 'hadith_review':
        return const HadithLandingPage(initialTabName: 'review');
      case 'quran_teaching_listen_only':
        return const QuranTeachingListenOnlyPage();
      case 'quran_teaching_review':
        return const QuranTeachingReviewPage();
      default:
        return null;
    }
  }
}

String _completionFeedbackMessage(
  AppLocalizations l10n,
  bool kidsUiEnabled,
  LearningJourneyCompletionResult result,
) {
  final lines = <String>[
    l10n.learningJourneyFeedbackStageCompleted(result.currentStreakDays),
  ];
  if (result.oceanDropsAwarded > 0) {
    lines.add(
      result.learnedTogether
          ? (kidsUiEnabled
                ? l10n.learningCommunityFeedbackSharedKids
                : l10n.learningCommunityFeedbackSharedAdult)
          : (kidsUiEnabled
                ? l10n.learningCommunityFeedbackStageKids
                : l10n.learningCommunityFeedbackStageAdult),
    );
  }
  if (result.journeyCompleted) {
    lines.add(l10n.learningCommunityFeedbackJourneyBonus);
  }
  if (result.phaseCompleted) {
    lines.add(l10n.learningCommunityFeedbackPhaseBonus);
  }
  return lines.join('\n');
}

class _UnavailableStagePage extends StatelessWidget {
  const _UnavailableStagePage({required this.journey, required this.stage});

  final LearningJourney journey;
  final LearningJourneyStage stage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LearnHubPageScaffold(
      headerIcon: Icons.offline_bolt_rounded,
      title: localizedStageTitle(context, stage),
      subtitle: l10n.learningJourneyStageUnavailableTitle,
      children: [
        Text(
          l10n.learningJourneyStageUnavailableBody,
          style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
        ),
        const SizedBox(height: 14),
        LearningJourneyToolCard(
          title: stage.relatedTools.isNotEmpty
              ? stage.relatedTools.first.title
              : l10n.learningJourneyStageUnavailableFallbackTitle,
          subtitle: stage.relatedTools.isNotEmpty
              ? stage.relatedTools.first.subtitle
              : l10n.learningJourneyStageUnavailableFallbackSubtitle,
          icon: stage.relatedTools.isNotEmpty
              ? Icons.open_in_new_rounded
              : Icons.route_rounded,
          onTap: () {
            if (stage.relatedTools.isNotEmpty) {
              GoRouter.of(context).pushNamed(
                stage.relatedTools.first.routeName,
                pathParameters: stage.relatedTools.first.pathParameters,
                queryParameters: stage.relatedTools.first.queryParameters,
              );
              return;
            }
            GoRouter.of(context).pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': journey.id},
            );
          },
        ),
      ],
    );
  }
}
