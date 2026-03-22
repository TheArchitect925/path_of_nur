import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/ayah_completion/application/ayah_completion_game_adapter.dart';
import 'package:path_of_nur/features/learn/ayah_completion/domain/ayah_completion_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';

void main() {
  test(
    'adapter maps puzzle and progress into shared knowledge game models',
    () {
      const adapter = AyahCompletionGameAdapter();
      const puzzle = AyahCompletionPuzzle(
        id: 'ayah_test',
        ref: QuranQuoteRef(surah: 112, ayah: 2),
        mode: AyahCompletionMode.kids,
        category: 'memorization',
        difficulty: 10,
        arabicWords: ['اللَّهُ', 'الصَّمَدُ'],
        fullArabicText: 'اللَّهُ الصَّمَدُ',
        translation: 'Allah, the Eternal Refuge.',
        blanks: [
          AyahCompletionBlank(
            blankIndex: 0,
            wordIndex: 1,
            correctWord: 'الصَّمَدُ',
            options: ['الصَّمَدُ', 'الْحَمْدُ', 'رَحِيمٌ'],
          ),
        ],
        tags: ['memorization'],
        levelBandMin: 1,
        levelBandMax: 10,
        isDailyEligible: true,
        dailyThemes: ['memorization'],
        packIds: ['pack'],
      );
      const progress = AyahCompletionPuzzleProgress(
        filledWordsByBlankIndex: {'0': 'الصَّمَدُ'},
        startedAtIso: '2026-03-21T10:00:00.000',
        completedAtIso: '2026-03-21T10:05:00.000',
        perfectCompletedAtIso: '2026-03-21T10:05:00.000',
      );

      final game = adapter.toGame(puzzle);
      final session = adapter.createSession(game: puzzle, progress: progress);
      final result = adapter.evaluate(
        game: puzzle,
        progress: progress,
        xpEarned: 2,
        dropsEarned: 1,
      );

      expect(game.type, 'ayah_completion');
      expect(session.isCompleted, isTrue);
      expect(result.perfect, isTrue);
      expect(result.xpEarned, 2);
    },
  );
}
