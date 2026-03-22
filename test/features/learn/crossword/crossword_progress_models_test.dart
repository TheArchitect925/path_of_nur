import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/crossword/domain/crossword_models.dart';

void main() {
  group('CrosswordProgressState', () {
    test('restores saved cell entries, hint usage, and daily progress', () {
      final state = CrosswordProgressState.fromJson({
        'progressByPuzzleId': {
          'adult_quran_sabr_rahmah': {
            'puzzleId': 'adult_quran_sabr_rahmah',
            'solvedClueIds': ['adult_quran_sabr_rahmah:quran_sabr'],
            'enteredLettersByCell': {'0:0': 'S', '0:1': 'A'},
            'revealedCellKeys': ['0:2'],
            'revealedClueIds': ['adult_quran_sabr_rahmah:quran_sabr'],
            'extraHintViewedClueIds': ['adult_quran_sabr_rahmah:quran_sabr'],
            'selectedCellKey': '0:1',
            'selectedDirection': 'down',
            'revealLetterUses': 1,
            'revealWordUses': 1,
            'extraHintUses': 1,
            'usedAnyHint': true,
            'hadMistake': true,
          },
        },
        'dailyProgressByDateKey': {
          '2026-03-27': {
            'dateKey': '2026-03-27',
            'puzzleId': 'adult_jummah_khutbah',
            'weekdayTheme': 'jummah',
            'startedAtIso': '2026-03-27T09:00:00.000',
            'completedAtIso': '2026-03-27T09:10:00.000',
            'bonusCompletedObjectiveIds': ['perfect', 'hint_free'],
            'timeTakenSeconds': 600,
            'dailyRewardGrantedAtIso': '2026-03-27T09:10:01.000',
            'dailyBonusRewardGrantedAtIso': '2026-03-27T09:10:02.000',
          },
        },
      });

      final progress = state.progressFor('adult_quran_sabr_rahmah');
      final daily = state.dailyProgressFor('2026-03-27');

      expect(progress.enteredLettersByCell['0:0'], 'S');
      expect(progress.revealedCellKeys.contains('0:2'), isTrue);
      expect(progress.usedAnyHint, isTrue);
      expect(progress.hadMistake, isTrue);
      expect(progress.selectedCellKey, '0:1');
      expect(progress.selectedDirection, 'down');
      expect(daily, isNotNull);
      expect(daily?.isCompleted, isTrue);
      expect(daily?.weekdayTheme, 'jummah');
      expect(daily?.bonusCompletedObjectiveIds.contains('perfect'), isTrue);
      expect(daily?.timeTakenSeconds, 600);
    });

    test('computes the current and best daily streak from completed dates', () {
      const state = CrosswordProgressState(
        progressByPuzzleId: {},
        dailyProgressByDateKey: {
          '2026-03-25': CrosswordDailyProgress(
            dateKey: '2026-03-25',
            puzzleId: 'p1',
            completedAtIso: '2026-03-25T10:00:00.000',
          ),
          '2026-03-26': CrosswordDailyProgress(
            dateKey: '2026-03-26',
            puzzleId: 'p2',
            completedAtIso: '2026-03-26T10:00:00.000',
          ),
          '2026-03-27': CrosswordDailyProgress(
            dateKey: '2026-03-27',
            puzzleId: 'p3',
            completedAtIso: '2026-03-27T10:00:00.000',
          ),
        },
      );

      final summary = state.dailyStreakSummary(DateTime(2026, 3, 27, 12));

      expect(summary.currentStreak, 3);
      expect(summary.bestStreak, 3);
      expect(summary.totalCompletedDays, 3);
    });
  });
}
