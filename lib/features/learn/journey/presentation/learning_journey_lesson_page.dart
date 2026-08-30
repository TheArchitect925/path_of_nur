import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../content_linking/application/contextual_linking_providers.dart';
import '../../../content_linking/presentation/contextual_related_content_section.dart';
import '../application/family_learning_provider.dart';
import '../application/learn_together_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../application/learning_path_provider.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../data/learning_journey_quran_integration.dart';
import '../data/learning_journey_registry.dart';
import '../../quran/application/quran_user_intent_provider.dart';
import '../../quran/domain/quran_user_intent_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../domain/learning_journey_lesson_models.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyLessonPage extends ConsumerWidget {
  const LearningJourneyLessonPage({
    super.key,
    required this.journey,
    required this.stage,
    required this.lesson,
    this.learnTogetherChildProfileId,
  });

  final LearningJourney journey;
  final LearningJourneyStage stage;
  final LearningJourneyLessonContent lesson;
  final String? learnTogetherChildProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final activeFamily = ref.watch(activeFamilyLearningContextProvider);
    final ageGroup =
        ref.watch(learningPathStateProvider)?.ageGroup ??
        LearningAgeGroup.adults;
    final learnTogetherPrompt = learnTogetherChildProfileId == null
        ? null
        : ref.watch(
            learnTogetherPromptProvider((
              journeyId: journey.id,
              stageId: stage.id,
              ageGroup: ageGroup,
              l10n: l10n,
            )),
          );
    final learnTogetherEligible = ref
        .watch(learnTogetherEligibleJourneyIdsProvider)
        .contains(journey.id);
    final completed = ref.watch(
      learningJourneyProgressProvider.select(
        (state) => state.completedStageIds.contains(stage.id),
      ),
    );
    final references = <String>[
      ...lesson.quranReferences,
      ...lesson.sourceReferences,
    ];
    final quranContextEntry = learningJourneyQuranContextForStage(stage.id);
    final quranReaderQueryParameters = quranContextEntry == null
        ? const <String, String>{}
        : <String, String>{...quranContextEntry.toReaderQueryParameters()};
    final selectedIntent = ref.watch(quranSelectedUserIntentProvider);
    if (quranContextEntry != null &&
        !quranReaderQueryParameters.containsKey('mode') &&
        selectedIntent != null) {
      quranReaderQueryParameters['mode'] = quranPreferredReaderModeForIntent(
        selectedIntent,
        hasHighlightedTopic:
            quranContextEntry.topicId?.trim().isNotEmpty ?? false,
      ).wireName;
    }
    final filteredRelatedTools = quranContextEntry == null
        ? lesson.relatedTools
        : lesson.relatedTools
              .where(
                (tool) =>
                    !(tool.routeName == 'quranReader' &&
                        tool.pathParameters['surahNumber'] == '1' &&
                        tool.queryParameters.isEmpty),
              )
              .toList(growable: false);
    final continueJourneys = lesson.continueJourneyIds
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .toList(growable: false);
    final relatedJourneys = lesson.relatedJourneyIds
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .where(
          (item) => !continueJourneys.any((journey) => journey.id == item.id),
        )
        .toList(growable: false);
    final stages = LearningJourneyRegistry.stagesForJourney(journey.id);
    final stageIndex = stages.indexWhere((item) => item.id == stage.id);
    final nextStageId = stageIndex >= 0 && stageIndex + 1 < stages.length
        ? stages[stageIndex + 1].id
        : null;
    final nextStage = nextStageId == null
        ? null
        : LearningJourneyRegistry.stageById(nextStageId);
    final contextualRelatedAsync = ref.watch(
      contextualLinksForLearningJourneyStageProvider((
        journeyId: journey.id,
        stageId: stage.id,
      )),
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: localizedStageTitle(context, stage),
      subtitle: localizedStageSummary(context, stage),
      children: [
        if (learnTogetherEligible &&
            activeFamily.activeGuardianProfileId != null &&
            activeFamily.familyGroup != null &&
            activeFamily.familyGroup!.childProfileIds.isNotEmpty &&
            learnTogetherChildProfileId == null) ...[
          _SectionCard(
            title: l10n.learnTogetherTitle,
            comfortable: kidsUi.enabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnTogetherLessonIntro,
                  style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: activeFamily.familyGroup!.childProfileIds
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
                                  stageId: stage.id,
                                );
                            if (!context.mounted) {
                              return;
                            }
                            context.pushNamed(
                              'learnJourneyStage',
                              pathParameters: {
                                'journeyId': journey.id,
                                'stageId': stage.id,
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
          const SizedBox(height: 14),
        ],
        if (learnTogetherPrompt != null) ...[
          _SectionCard(
            title: l10n.learnTogetherDiscussionTitle,
            comfortable: kidsUi.enabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: learnTogetherPrompt.discussionPrompts
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '• $item',
                        style: const TextStyle(
                          color: Color(0xFF675B4E),
                          height: 1.4,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learnTogetherParentGuidanceTitle,
            comfortable: kidsUi.enabled,
            child: Text(
              learnTogetherPrompt.parentGuidance,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
            ),
          ),
          const SizedBox(height: 14),
        ],
        _SectionCard(
          title: kidsUi.enabled
              ? l10n.kidsJourneyLessonSectionIntroduction
              : l10n.learningJourneyLessonSectionIntroduction,
          comfortable: kidsUi.enabled,
          child: Text(
            lesson.introduction,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
        ),
        const SizedBox(height: 14),
        ...lesson.sections.expand(
          (section) => <Widget>[
            _SectionCard(
              title: section.title,
              comfortable: kidsUi.enabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.body,
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
                      height: 1.4,
                    ),
                  ),
                  if (section.bullets.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...section.bullets.map(
                      (bullet) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.circle,
                                size: 7,
                                color: Color(0xFF7B694F),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                bullet,
                                style: const TextStyle(
                                  color: Color(0xFF675B4E),
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
        if (lesson.invocations.isNotEmpty) ...[
          Text(
            l10n.learningJourneyLessonSectionArabicMeaning,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 8),
          ...lesson.invocations.expand(
            (invocation) => <Widget>[
              _InvocationCard(invocation: invocation),
              if (!kidsUi.enabled) const SizedBox(height: 12),
            ],
          ),
        ],
        _SectionCard(
          title: l10n.learningJourneyLessonSectionTakeaways,
          comfortable: kidsUi.enabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lesson.keyTakeaways
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle,
                            size: 7,
                            color: Color(0xFF7B694F),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Color(0xFF675B4E),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: l10n.learningJourneyLessonSectionReflection,
          comfortable: kidsUi.enabled,
          child: Text(
            lesson.reflectionPrompt,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
        ),
        if (lesson.actionStep != null) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learningJourneyLessonSectionActionStep,
            comfortable: kidsUi.enabled,
            child: Text(
              lesson.actionStep!,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
            ),
          ),
        ],
        if (lesson.reviewSuggestion != null) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learningJourneyLessonSectionReviewSuggestion,
            comfortable: kidsUi.enabled,
            child: Text(
              lesson.reviewSuggestion!,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
            ),
          ),
        ],
        if (references.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learningJourneyLessonSectionReferences,
            comfortable: kidsUi.enabled,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: references
                  .map(
                    (reference) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E8D9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        reference,
                        style: const TextStyle(
                          color: Color(0xFF725C42),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
        if (continueJourneys.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learningJourneyLessonSectionContinueWith,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: continueJourneys
                  .map(
                    (item) => _JourneyLinkButton(
                      label: localizedJourneyTitle(context, item),
                      onTap: () => context.pushNamed(
                        'learnJourneyDetail',
                        pathParameters: {'journeyId': item.id},
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
        if (relatedJourneys.isNotEmpty && !kidsUi.enabled) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learningJourneyLessonSectionRelatedJourneys,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: relatedJourneys
                  .map(
                    (item) => _JourneyLinkButton(
                      label: localizedJourneyTitle(context, item),
                      onTap: () => context.pushNamed(
                        'learnJourneyDetail',
                        pathParameters: {'journeyId': item.id},
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
        if (contextualRelatedAsync case AsyncData(
          :final value,
        ) when value.isNotEmpty) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.contextualLinksRelatedTitle,
            child: ContextualRelatedContentSection(items: value),
          ),
        ],
        if ((!kidsUi.enabled && filteredRelatedTools.isNotEmpty) ||
            quranContextEntry != null ||
            lesson.showDhikrCounterAction) ...[
          const SizedBox(height: 14),
          Text(
            l10n.learningJourneyLessonSectionExploreNow,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 8),
          if (lesson.showDhikrCounterAction) ...[
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed('worshipDhikrPage'),
              icon: const Icon(Icons.self_improvement_rounded),
              label: Text(
                kidsUi.enabled
                    ? l10n.kidsJourneyLessonActionOpenDhikrCounter
                    : l10n.learningJourneyLessonActionOpenDhikrCounter,
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (quranContextEntry != null) ...[
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed(
                'quranReader',
                pathParameters: {
                  'surahNumber': quranContextEntry.surahNumber.toString(),
                },
                queryParameters: quranReaderQueryParameters,
              ),
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(l10n.learningJourneyLessonActionStudyInQuran),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.learningJourneyLessonActionStudyInQuranSubtitle(
                quranContextEntry.referenceLabel,
              ),
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
            if (filteredRelatedTools.isNotEmpty) const SizedBox(height: 10),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filteredRelatedTools
                .map((tool) => LearningJourneyToolLinkButton(tool: tool))
                .toList(growable: false),
          ),
        ],
        if (learnTogetherPrompt != null) ...[
          const SizedBox(height: 14),
          _SectionCard(
            title: l10n.learnTogetherFamilyPromptTitle,
            comfortable: kidsUi.enabled,
            child: Text(
              learnTogetherPrompt.familyPrompt,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (!completed) ...[
          _SectionCard(
            title: l10n.learningJourneyLessonSectionRewardsTitle,
            child: Text(
              l10n.learningJourneyLessonSectionProgressSubtitle,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
            ),
          ),
          const SizedBox(height: 14),
        ],
        FilledButton.icon(
          onPressed: completed
              ? (nextStage == null
                    ? null
                    : () => context.pushNamed(
                        'learnJourneyStage',
                        pathParameters: {
                          'journeyId': journey.id,
                          'stageId': nextStage.id,
                        },
                      ))
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
                              result.learnedTogether
                                  ? (kidsUi.enabled
                                        ? l10n.learningCommunityFeedbackSharedKids
                                        : l10n.learningCommunityFeedbackSharedAdult)
                                  : (kidsUi.enabled
                                        ? l10n.learningCommunityFeedbackStageKids
                                        : l10n.learningCommunityFeedbackStageAdult),
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
                ? nextStage == null
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded
                : Icons.check_circle_outline_rounded,
          ),
          label: Text(
            completed
                ? nextStage == null
                      ? (kidsUi.enabled
                            ? l10n.kidsJourneyLessonActionCompleted
                            : l10n.learningJourneyLessonActionCompleted)
                      : (kidsUi.enabled
                            ? l10n.kidsJourneyLessonActionNextLesson
                            : l10n.learningJourneyLessonActionNextLesson)
                : (kidsUi.enabled
                      ? l10n.kidsJourneyLessonActionMarkComplete
                      : l10n.learningJourneyLessonActionMarkComplete),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          onPressed: () => context.goNamed(
            'learnJourneyDetail',
            pathParameters: {'journeyId': journey.id},
            queryParameters: {'currentStage': stage.id},
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(
            kidsUi.enabled
                ? l10n.kidsJourneyLessonActionReturnToJourney
                : l10n.learningJourneyLessonActionReturnToJourney,
          ),
        ),
      ],
    );
  }
}

class _JourneyLinkButton extends StatelessWidget {
  const _JourneyLinkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: const Icon(Icons.route_rounded),
      label: Text(label),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.comfortable = false,
  });

  final String title;
  final Widget child;
  final bool comfortable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(comfortable ? 18 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3D6C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: comfortable ? 17 : 16,
              color: Color(0xFF2E261F),
            ),
          ),
          SizedBox(height: comfortable ? 10 : 8),
          child,
        ],
      ),
    );
  }
}

class _InvocationCard extends StatelessWidget {
  const _InvocationCard({required this.invocation});

  final LearningJourneyLessonInvocation invocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3D6C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invocation.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            invocation.arabic,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 24,
              height: 1.7,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            invocation.transliteration,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF675B4E),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            invocation.meaning,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            invocation.context,
            style: const TextStyle(color: Color(0xFF7B694F), height: 1.35),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2E8D9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              invocation.sourceReference,
              style: const TextStyle(
                color: Color(0xFF725C42),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
