import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/knowledge_games/adaptive/application/adaptive_learning_engine.dart';
import 'package:path_of_nur/features/learn/knowledge_games/adaptive/domain/user_learning_profile_models.dart';

void main() {
  group('AdaptiveLearningEngine', () {
    const engine = AdaptiveLearningEngine();

    test('raises target difficulty for stronger game types', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{'quran': 0.8},
        gameTypeStrength: <String, double>{'crossword': 0.82},
        overallSkillLevel: 0.7,
        recentPerformance: <String, int>{},
        difficultyComfort: <String, double>{'crossword': 0.62},
      );

      final target = engine.personalizedTargetDifficulty(
        profile: profile,
        gameType: 'crossword',
        baseTarget: 30,
      );

      expect(target, greaterThan(30));
    });

    test('lowers target difficulty for support-needed game types', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{'hadith': 0.32},
        gameTypeStrength: <String, double>{'hadith_reflection': 0.34},
        overallSkillLevel: 0.44,
        recentPerformance: <String, int>{},
        difficultyComfort: <String, double>{'hadith_reflection': 0.18},
      );

      final target = engine.personalizedTargetDifficulty(
        profile: profile,
        gameType: 'hadith_reflection',
        baseTarget: 32,
      );

      expect(target, lessThan(32));
    });

    test('prefers weaker categories during daily selection', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{'quran': 0.38, 'hadith': 0.82},
        gameTypeStrength: <String, double>{'matching': 0.58},
        overallSkillLevel: 0.58,
        recentPerformance: <String, int>{
          'category:quran': 2,
          'category:hadith': 1,
        },
        difficultyComfort: <String, double>{'matching': 0.42},
      );

      final quranPriority = engine.selectionPriority(
        profile: profile,
        gameType: 'matching',
        category: 'quran',
        difficulty: 30,
        targetDifficulty: 32,
      );
      final hadithPriority = engine.selectionPriority(
        profile: profile,
        gameType: 'matching',
        category: 'hadith',
        difficulty: 30,
        targetDifficulty: 32,
      );

      expect(quranPriority, lessThan(hadithPriority));
    });

    test('insight stays quiet on a flat profile', () {
      // The stored default is 0.3 for every game. Lowest and highest key both
      // resolve to the first entry on a tie, which used to surface the same
      // game as "extra support" and "slight stretch" on the daily hub.
      const flat = UserLearningProfile(
        categoryStrength: <String, double>{'quran': 0.3, 'hadith': 0.3},
        gameTypeStrength: <String, double>{
          'crossword': 0.3,
          'matching': 0.3,
          'ayah_completion': 0.3,
        },
        overallSkillLevel: 0.3,
        recentPerformance: <String, int>{},
        difficultyComfort: <String, double>{},
      );

      final insight = engine.buildInsight(flat);

      expect(insight.hasAdaptiveData, isFalse);
      expect(insight.supportGameType, isNull);
      expect(insight.challengeGameType, isNull);
    });

    test('insight names different games for support and stretch', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{},
        gameTypeStrength: <String, double>{
          'crossword': 0.35,
          'matching': 0.8,
          'ayah_completion': 0.6,
        },
        overallSkillLevel: 0.6,
        recentPerformance: <String, int>{'game:matching': 3},
        difficultyComfort: <String, double>{},
      );

      final insight = engine.buildInsight(profile);

      expect(insight.hasAdaptiveData, isTrue);
      expect(insight.supportGameType, 'crossword');
      expect(insight.challengeGameType, 'matching');
    });

    test('insight ignores a gap too small to act on', () {
      const profile = UserLearningProfile(
        categoryStrength: <String, double>{},
        gameTypeStrength: <String, double>{'crossword': 0.50, 'matching': 0.56},
        overallSkillLevel: 0.53,
        recentPerformance: <String, int>{'game:matching': 1},
        difficultyComfort: <String, double>{},
      );

      expect(engine.buildInsight(profile).hasAdaptiveData, isFalse);
    });
  });
}
