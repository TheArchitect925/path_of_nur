import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_queue_models.dart';

void main() {
  test('queue state serializes and restores current item', () {
    final state = BedtimeStoryQueueState(
      storyIds: const [
        'story_prophet_muhammad_part2_bedtime_v1',
        'story_prophet_muhammad_part3_bedtime_v1',
      ],
      currentIndex: 1,
      queueType: BedtimeStoryQueueType.continueSeries,
      autoplayEnabled: false,
      lastUpdatedAtIso: '2026-03-21T21:30:00.000',
    );

    final restored = BedtimeStoryQueueState.fromJson(state.toJson());
    expect(restored.currentStoryId, 'story_prophet_muhammad_part3_bedtime_v1');
    expect(restored.hasPrevious, isTrue);
    expect(restored.hasNext, isFalse);
    expect(restored.autoplayEnabled, isFalse);
    expect(restored.queueType, BedtimeStoryQueueType.continueSeries);
  });
}
