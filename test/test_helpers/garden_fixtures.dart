import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/garden/data/garden_stage_catalog.dart';
import 'package:path_of_nur/features/garden/domain/garden_models.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lean container for garden scene tests: mocked prefs + in-memory database,
/// WITHOUT the full app harness (which transitively compiles the router and
/// every page). Keeps these tests isolated from unrelated in-flight work.
Future<ProviderContainer> makeGardenTestContainer({
  List<Override> overrides = const <Override>[],
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'app.onboardingCompleted': true,
  });
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(AppDatabase.inMemory()),
      ...overrides,
    ],
  );
  return container;
}

/// Minimal hand-built GardenState for scene/vista tests: dimension scores and
/// drops are set directly; the visual stage is resolved from maturity via the
/// real catalog.
GardenState makeGardenState({
  String learnerId = 'learner_1',
  double prayer = 0,
  double learning = 0,
  double remembrance = 0,
  double consistency = 0,
  double wisdom = 0,
  int drops = 0,
  int maturity = 0,
  GardenAmbientState ambient = GardenAmbientState.quietDawn,
}) {
  final stage = gardenVisualStages.lastWhere(
    (item) => maturity >= item.minMaturityPercent,
    orElse: () => gardenVisualStages.first,
  );
  return GardenState(
    learnerId: learnerId,
    isFallbackLearner: true,
    currentGardenLevel: 1,
    currentVisualStage: stage,
    nextVisualStage: null,
    totalXp: 0,
    totalOceanDrops: drops,
    prayerFoundationScore: prayer,
    learningGrowthScore: learning,
    remembranceLightScore: remembrance,
    consistencyScore: consistency,
    wisdomFruitScore: wisdom,
    lastUpdatedIso: null,
    lastVisualRefreshAtIso: null,
    unlockedVisualIds: const [],
    ambientState: ambient,
    progressToNextStage: 0,
    maturityPercent: maturity,
    xpSummary: XpSummary(
      totalXp: 0,
      todayXp: 0,
      currentLevel: 1,
      currentLevelTitle: 'Niyyah',
      currentLevelStartXp: 0,
      nextLevel: 2,
      nextLevelTitle: 'Next',
      nextLevelTotalXp: 100,
      xpIntoLevel: 0,
      xpRequiredInLevel: 100,
      xpRemainingToNextLevel: 100,
      progressPercent: 0,
      updatedAt: DateTime(2026, 8, 29),
    ),
    metrics: const LearnerProgressionMetrics(
      totalXp: 0,
      totalDrops: 0,
      kidsArabicLessonCompletions: 0,
      kidsArabicDailyMissionCompletions: 0,
      storyCompletions: 0,
      quizCompletions: 0,
      memoryCompletions: 0,
      duaLessonCompletions: 0,
      duaPracticeSessions: 0,
      duaMyDayCompletions: 0,
      bedtimeRoutineCompletions: 0,
      seerahNodeCompletions: 0,
      seerahStageCompletions: 0,
      seerahJourneyCompletions: 0,
      currentLearningStreakDays: 0,
      longestLearningStreakDays: 0,
      lastActivityAtIso: null,
      activeDayKeys: [],
    ),
    dimensions: const [],
    insights: const [],
    recentGrowth: const [],
    milestones: const [],
  );
}
