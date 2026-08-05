import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/journey/spiritual_growth/application/spiritual_growth_engine.dart';
import 'package:path_of_nur/features/journey/spiritual_growth/application/spiritual_growth_validation.dart';
import 'package:path_of_nur/features/journey/spiritual_growth/domain/spiritual_growth_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';

void main() {
  group('SpiritualGrowthValidation', () {
    test('seed catalog validates cleanly', () {
      final report = SpiritualGrowthValidation.validateCatalog(
        spiritualGrowthSeedCatalog,
      );
      expect(report.isValid, isTrue);
    });
  });

  group('SpiritualGrowthEngine', () {
    const engine = SpiritualGrowthEngine();

    final snapshot = JourneyActivitySnapshot(
      now: DateTime(2026, 3, 21),
      prayerCompletedToday: 0,
      prayerMissedToday: 0,
      fajrCompletedToday: false,
      prayerProgress: 0.2,
      dhikrSessionsToday: 0,
      dhikrCountToday: 0,
      dhikrProgress: 0.0,
      fastingStatus: FastingStatus.notFasting,
      quranEngagementsToday: 0,
      quranProgress: 0.0,
      reflectionEntriesToday: 0,
      reflectionProgress: 0.0,
      learningStageCompletionsToday: 0,
      streakExemptionActive: false,
    );

    test('suggests stable intention for the same day and signals', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{'worship': 0.3},
        gameTypeStrength: <String, double>{'crossword': 0.6},
        overallSkillLevel: 0.5,
        recentPerformance: <String, int>{},
        difficultyComfort: <String, double>{},
        focusCategory: 'worship',
      );

      final first = engine.suggestedIntention(
        catalog: spiritualGrowthSeedCatalog,
        date: DateTime(2026, 3, 21),
        audience: 'adult',
        adaptiveProfile: profile,
        snapshot: snapshot,
        dailyBundleCompleted: false,
      );
      final second = engine.suggestedIntention(
        catalog: spiritualGrowthSeedCatalog,
        date: DateTime(2026, 3, 21),
        audience: 'adult',
        adaptiveProfile: profile,
        snapshot: snapshot,
        dailyBundleCompleted: false,
      );

      expect(first.id, second.id);
    });

    test('builds theme summaries from state and completed actions', () {
      final profile = engine.buildProfile(
        catalog: spiritualGrowthSeedCatalog,
        state: SpiritualGrowthState(
          selectedIntentionIdByDateKey: const <String, String>{
            '2026-03-21': 'presence_in_prayer',
          },
          manualActionIdsByDateKey: const <String, Set<String>>{
            '2026-03-21': <String>{'kind_help'},
          },
          reflectionEntryByDateKey: const <String, DailyReflectionEntry>{
            '2026-03-21': DailyReflectionEntry(
              dateKey: '2026-03-21',
              reflectionPromptId: 'gratitude_tonight',
              isCompleted: true,
            ),
          },
          reflectionRewardGrantedAtIsoByDateKey: const <String, String>{},
        ),
        todayKey: '2026-03-21',
        todayActions: const <GrowthActionStatus>[
          GrowthActionStatus(
            action: GrowthAction(
              id: 'daily_bundle',
              type: 'daily_bundle',
              titleKey: 'x',
              descriptionKey: 'y',
              theme: 'discipline',
              xpValue: 0,
              dropValue: 0,
            ),
            isCompleted: true,
            isManual: false,
          ),
        ],
      );

      expect(profile.themeAffinity['discipline'], greaterThanOrEqualTo(1));
      expect(profile.completedGrowthActionsToday, contains('daily_bundle'));
    });
  });
}
