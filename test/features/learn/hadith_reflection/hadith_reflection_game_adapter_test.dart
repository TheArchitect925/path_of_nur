import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/application/hadith_reflection_game_adapter.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/domain/hadith_reflection_models.dart';

void main() {
  test(
    'adapter maps hadith reflection puzzle into shared knowledge game models',
    () {
      const adapter = HadithReflectionGameAdapter();
      const puzzle = HadithReflectionPuzzle(
        id: 'hadith_reflection_test',
        hadithId: 'smiling_is_charity',
        mode: HadithReflectionMode.adult,
        category: 'kindness',
        theme: 'kindness',
        difficulty: 28,
        hadithTitle: 'Smiling is charity',
        hadithTextEnglish: 'Your smile for your brother is charity.',
        hadithTextArabic: 'تبسمك في وجه أخيك صدقة',
        sourceBook: 'Tirmidhi',
        referenceNumber: '1956',
        grading: 'Hasan',
        shortTeachingSummary: 'Kindness can be small and still sincere.',
        reflectionPrompt: 'How do you show gentle kindness?',
        scenarioTitle: 'Welcoming a colleague',
        scenarioDescription: 'A colleague arrives nervous on their first day.',
        choices: [
          HadithReflectionChoice(
            id: 'best',
            label: 'Welcome them warmly.',
            feedbackText: 'This matches the teaching well.',
            isBestChoice: true,
          ),
          HadithReflectionChoice(
            id: 'other',
            label: 'Ignore them.',
            feedbackText: 'This needs reflection.',
          ),
        ],
        tags: ['kindness'],
        levelBandMin: 1,
        levelBandMax: 20,
        packIds: ['pack'],
        isDailyEligible: true,
        dailyThemes: ['kindness'],
      );
      const progress = HadithReflectionPuzzleProgress(
        selectedChoiceId: 'best',
        feedbackViewed: true,
        startedAtIso: '2026-03-21T10:00:00.000',
        completedAtIso: '2026-03-21T10:05:00.000',
        bestChoiceCompletedAtIso: '2026-03-21T10:05:00.000',
      );

      final game = adapter.toGame(puzzle);
      final session = adapter.createSession(game: puzzle, progress: progress);
      final result = adapter.evaluate(
        game: puzzle,
        progress: progress,
        xpEarned: 2,
        dropsEarned: 1,
      );

      expect(game.type, 'hadith_reflection');
      expect(session.isCompleted, isTrue);
      expect(result.perfect, isTrue);
      expect(result.xpEarned, 2);
    },
  );
}
