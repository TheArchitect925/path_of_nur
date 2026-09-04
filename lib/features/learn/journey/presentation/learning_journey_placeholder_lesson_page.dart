import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../application/learn_together_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../application/learning_path_provider.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../domain/learning_journey_models.dart';
import '../data/learning_journey_localized_metadata.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyPlaceholderLessonPage extends ConsumerWidget {
  const LearningJourneyPlaceholderLessonPage({
    super.key,
    required this.journey,
    required this.stage,
    this.learnTogetherChildProfileId,
  });

  final LearningJourney journey;
  final LearningJourneyStage stage;
  final String? learnTogetherChildProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final completed = ref.watch(
      learningJourneyProgressProvider.select(
        (state) => state.completedStageIds.contains(stage.id),
      ),
    );
    final suggestedTools = <LearningJourneyToolLink>[
      ...stage.relatedTools,
      ...journey.relatedTools.where(
        (tool) => !stage.relatedTools.any((item) => item.title == tool.title),
      ),
    ].take(kidsUi.enabled ? 2 : 4).toList(growable: false);
    final learnBody = localizedStageNotes(context, stage).trim().isNotEmpty
        ? localizedStageNotes(context, stage)
        : localizedStageSummary(context, stage);
    return LearnHubPageScaffold(
      title: localizedStageTitle(context, stage),
      subtitle: localizedStageSummary(context, stage),
      children: [
        PlaceholderLessonPageScaffold(
          stageTitle: localizedStageTitle(context, stage),
          summary: localizedStageSummary(context, stage),
          learnLabel: kidsUi.enabled
              ? l10n.kidsJourneyPlaceholderLearnLabel
              : l10n.learningJourneyPlaceholderLearnLabel,
          learnBody: learnBody,
          message: l10n.learningJourneyPlaceholderMessage,
          note: localizedStageNotes(context, stage),
          relatedTools: suggestedTools,
          onBackToJourney: () => context.goNamed(
            'learnJourneyDetail',
            pathParameters: {'journeyId': journey.id},
            queryParameters: {'currentStage': stage.id},
          ),
        ),
        if (localizedStagePlannedIncludes(context, stage).isNotEmpty &&
            !kidsUi.enabled) ...[
          const SizedBox(height: 14),
          Text(
            l10n.learningJourneyPlaceholderPlannedIncludesTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...localizedStagePlannedIncludes(context, stage).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.circle,
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
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: completed
              ? null
              : () {
                  final result = ref
                      .read(learningJourneyProgressProvider.notifier)
                      .completeStage(
                        journeyId: journey.id,
                        stageId: stage.id,
                        learnedTogether: learnTogetherChildProfileId != null,
                      );
                  if (result.stageCompleted) {
                    ref
                        .read(learningPathSelectionProvider.notifier)
                        .syncProgressSignals();
                    if (learnTogetherChildProfileId != null) {
                      ref
                          .read(learnTogetherProvider.notifier)
                          .markLearnedTogether(
                            childProfileId: learnTogetherChildProfileId!,
                            journeyId: journey.id,
                            stageId: stage.id,
                          );
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          [
                            l10n.learningJourneyFeedbackStageCompleted(
                              result.currentStreakDays,
                            ),
                            if (result.oceanDropsAwarded > 0)
                              kidsUi.enabled
                                  ? l10n.learningCommunityFeedbackStageKids
                                  : l10n.learningCommunityFeedbackStageAdult,
                            if (result.journeyCompleted)
                              l10n.learningCommunityFeedbackJourneyBonus,
                            if (result.phaseCompleted)
                              l10n.learningCommunityFeedbackPhaseBonus,
                          ].join('\n'),
                        ),
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  }
                },
          icon: Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
          ),
          label: Text(
            completed
                ? (kidsUi.enabled
                      ? l10n.kidsJourneyPlaceholderActionCompleted
                      : l10n.learningJourneyPlaceholderActionCompleted)
                : (kidsUi.enabled
                      ? l10n.kidsJourneyPlaceholderActionMarkComplete
                      : l10n.learningJourneyPlaceholderActionMarkComplete),
          ),
        ),
      ],
    );
  }
}
