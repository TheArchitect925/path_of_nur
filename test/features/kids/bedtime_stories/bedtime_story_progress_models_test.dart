import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';

void main() {
  test('bedtime story library progress serializes and restores state', () {
    final state = BedtimeStoryLibraryProgress(
      storyProgressById: {
        'story_prophet_adam_bedtime_v1': const BedtimeStoryProgress(
          currentPositionMs: 42000,
          totalDurationMs: 95000,
          totalListenedMs: 62000,
          startedAtIso: '2026-03-21T20:00:00.000',
          lastAccessedAtIso: '2026-03-21T20:05:00.000',
          lastPlayedAtIso: '2026-03-21T20:05:00.000',
          lastPlaybackSource: BedtimeStoryPlaybackSource.asset,
        ),
        'story_prophet_muhammad_part1_bedtime_v1': const BedtimeStoryProgress(
          currentPositionMs: 120000,
          totalDurationMs: 120000,
          totalListenedMs: 120000,
          startedAtIso: '2026-03-21T20:30:00.000',
          completedAtIso: '2026-03-21T20:32:00.000',
          completionRewardGrantedAtIso: '2026-03-21T20:32:00.000',
          lastPlaybackSource: BedtimeStoryPlaybackSource.asset,
        ),
      },
      recentStoryIds: const [
        'story_prophet_muhammad_part1_bedtime_v1',
        'story_prophet_adam_bedtime_v1',
      ],
      completedSeriesProphetIds: const {'muhammad'},
    );

    final restored = BedtimeStoryLibraryProgress.fromJson(state.toJson());
    expect(
      restored
          .storyProgressById['story_prophet_adam_bedtime_v1']
          ?.completionState,
      BedtimeStoryCompletionState.inProgress,
    );
    expect(
      restored
          .storyProgressById['story_prophet_muhammad_part1_bedtime_v1']
          ?.isCompleted,
      isTrue,
    );
    expect(
      restored.recentStoryIds.first,
      'story_prophet_muhammad_part1_bedtime_v1',
    );
    expect(restored.completedSeriesProphetIds, contains('muhammad'));
  });
}
