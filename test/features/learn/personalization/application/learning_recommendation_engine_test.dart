import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/guided_paths/data/guided_learning_paths_seed.dart';
import 'package:path_of_nur/features/learn/personalization/application/learning_recommendation_engine.dart';
import 'package:path_of_nur/features/learn/personalization/domain/learning_personalization_models.dart';
import 'package:path_of_nur/features/learn/shared/domain/learn_system_models.dart';

void main() {
  const engine = LearningRecommendationEngine();

  test('prioritizes the active guided path next step first', () {
    final summary = engine.build(
      signals: _signals(
        activePathId: 'salah-starter',
        activeStepId: 'salah-learn-hub',
        startedPathIds: const <String>{'salah-starter'},
        pathLastUpdatedAtById: <String, DateTime>{
          'salah-starter': DateTime(2026, 3, 31, 9),
        },
      ),
      visiblePaths: kGuidedLearningPaths,
    );

    expect(
      summary.primaryRecommendation.kind,
      LearningRecommendationKind.continueGuidedPathStep,
    );
    expect(summary.primaryRecommendation.pathId, 'salah-starter');
    expect(summary.primaryRecommendation.stepId, 'salah-learn-hub');
    expect(
      summary.primaryRecommendation.reason,
      LearningRecommendationReason.activeGuidedPath,
    );
  });

  test('falls back to foundations for a brand-new learner', () {
    final summary = engine.build(
      signals: _signals(),
      visiblePaths: kGuidedLearningPaths,
    );

    expect(
      summary.primaryRecommendation.kind,
      LearningRecommendationKind.startGuidedPath,
    );
    expect(summary.primaryRecommendation.pathId, 'foundations-starter');
    expect(
      summary.primaryRecommendation.reason,
      LearningRecommendationReason.noHistory,
    );
  });

  test('prioritizes kids starter for child profiles', () {
    final summary = engine.build(
      signals: _signals(isChildProfile: true),
      visiblePaths: kGuidedLearningPaths,
    );

    expect(summary.primaryRecommendation.pathId, 'kids-starter');
    expect(
      summary.primaryRecommendation.reason,
      LearningRecommendationReason.kidsProfile,
    );
  });

  test('uses quran momentum when quran signals are strong', () {
    final summary = engine.build(
      signals: _signals(
        quranReadingCountLast7Days: 3,
        quranReadingSecondsToday: 420,
        quranHasPersonalizationSignals: true,
        recentLearnDomains: const [],
      ),
      visiblePaths: kGuidedLearningPaths,
    );

    expect(summary.primaryRecommendation.pathId, 'quran-beginner-starter');
    expect(
      summary.primaryRecommendation.reason,
      LearningRecommendationReason.quranMomentum,
    );
  });

  test('sequences to the next path after a recent completion', () {
    final summary = engine.build(
      signals: _signals(
        completedPathIds: const <String>{'foundations-starter'},
        startedPathIds: const <String>{'foundations-starter'},
        pathCompletedAtById: <String, DateTime>{
          'foundations-starter': DateTime(2026, 3, 31, 8),
        },
        pathLastUpdatedAtById: <String, DateTime>{
          'foundations-starter': DateTime(2026, 3, 31, 8),
        },
      ),
      visiblePaths: kGuidedLearningPaths,
    );

    expect(summary.primaryRecommendation.pathId, 'salah-starter');
    expect(
      summary.primaryRecommendation.reason,
      LearningRecommendationReason.sequencedAfterCompletion,
    );
  });
}

LearningSignals _signals({
  bool isChildProfile = false,
  bool ramadanModeEnabled = false,
  DateTime? now,
  String? activePathId,
  String? activeStepId,
  Set<String> completedPathIds = const <String>{},
  Set<String> startedPathIds = const <String>{},
  Map<String, DateTime> pathLastUpdatedAtById = const <String, DateTime>{},
  Map<String, DateTime> pathCompletedAtById = const <String, DateTime>{},
  List<LearnUnifiedDomain> recentLearnDomains = const <LearnUnifiedDomain>[],
  int quranReadingCountLast7Days = 0,
  int quranReadingSecondsToday = 0,
  bool quranHasPersonalizationSignals = false,
  int dhikrSessionsLast7Days = 0,
  int salahActivityCount = 0,
  int learnStartedCount = 0,
  int learnCompletedCount = 0,
  int learnSavedCount = 0,
  int learnNotesCount = 0,
  DateTime? lastLearnActivityAt,
}) {
  return LearningSignals(
    isChildProfile: isChildProfile,
    ramadanModeEnabled: ramadanModeEnabled,
    now: now ?? DateTime(2026, 3, 31, 9),
    activePathId: activePathId,
    activeStepId: activeStepId,
    completedPathIds: completedPathIds,
    startedPathIds: startedPathIds,
    pathLastUpdatedAtById: pathLastUpdatedAtById,
    pathCompletedAtById: pathCompletedAtById,
    recentLearnDomains: List.unmodifiable(recentLearnDomains),
    quranReadingCountLast7Days: quranReadingCountLast7Days,
    quranReadingSecondsToday: quranReadingSecondsToday,
    quranHasPersonalizationSignals: quranHasPersonalizationSignals,
    dhikrSessionsLast7Days: dhikrSessionsLast7Days,
    salahActivityCount: salahActivityCount,
    learnStartedCount: learnStartedCount,
    learnCompletedCount: learnCompletedCount,
    learnSavedCount: learnSavedCount,
    learnNotesCount: learnNotesCount,
    lastLearnActivityAt: lastLearnActivityAt,
  );
}
