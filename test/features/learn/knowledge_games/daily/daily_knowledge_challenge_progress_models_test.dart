import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';

void main() {
  test('daily challenge hub progress serializes and restores history', () {
    final state = DailyChallengeHubProgressState(
      progressByDateKey: {
        '2026-03-21': const DailyChallengeBundleProgress(
          dateKey: '2026-03-21',
          startedAtIso: '2026-03-21T09:00:00.000',
          completedAtIso: '2026-03-21T09:30:00.000',
          rewardGrantedAtIso: '2026-03-21T09:30:00.000',
        ),
      },
    );

    final restored = DailyChallengeHubProgressState.fromJson(state.toJson());
    expect(restored.progressFor('2026-03-21').isCompleted, isTrue);
    expect(
      restored.progressFor('2026-03-21').rewardGrantedAtIso,
      '2026-03-21T09:30:00.000',
    );
  });

  test('streak summary counts consecutive bundle completions', () {
    final state = DailyChallengeHubProgressState(
      progressByDateKey: {
        '2026-03-19': const DailyChallengeBundleProgress(
          dateKey: '2026-03-19',
          completedAtIso: '2026-03-19T09:00:00.000',
        ),
        '2026-03-20': const DailyChallengeBundleProgress(
          dateKey: '2026-03-20',
          completedAtIso: '2026-03-20T09:00:00.000',
        ),
        '2026-03-21': const DailyChallengeBundleProgress(
          dateKey: '2026-03-21',
          completedAtIso: '2026-03-21T09:00:00.000',
        ),
      },
    );

    final summary = state.streakSummary(DateTime(2026, 3, 21));
    expect(summary.currentStreak, 3);
    expect(summary.longestStreak, 3);
  });
}
