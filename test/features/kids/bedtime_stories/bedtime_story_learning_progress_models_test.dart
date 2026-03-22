import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_learning_models.dart';

void main() {
  test('bedtime story learning progress serializes quiz and memory state', () {
    final state = BedtimeStoryLearningProgressState(
      progressByActivityId: <String, BedtimeStoryLearningActivityProgress>{
        'quiz_story_prophet_adam_bedtime_v1':
            const BedtimeStoryLearningActivityProgress(
              storyId: 'story_prophet_adam_bedtime_v1',
              mode: BedtimeStoryLearningMode.quiz,
              currentStepIndex: 2,
              totalSteps: 3,
              correctCount: 2,
              completedStepIds: <String>['adam_q1', 'adam_q2'],
              startedAtIso: '2026-03-21T20:00:00.000',
              lastAccessedAtIso: '2026-03-21T20:03:00.000',
            ),
        'memory_story_prophet_nuh_bedtime_v1':
            const BedtimeStoryLearningActivityProgress(
              storyId: 'story_prophet_nuh_bedtime_v1',
              mode: BedtimeStoryLearningMode.memoryCards,
              currentStepIndex: 4,
              totalSteps: 4,
              completedStepIds: <String>[
                'nuh_pair_1',
                'nuh_pair_2',
                'nuh_pair_3',
                'nuh_pair_4',
              ],
              startedAtIso: '2026-03-21T20:10:00.000',
              firstCompletedAtIso: '2026-03-21T20:15:00.000',
              rewardGrantedAtIso: '2026-03-21T20:15:00.000',
            ),
      },
      recentActivityIds: const <String>[
        'memory_story_prophet_nuh_bedtime_v1',
        'quiz_story_prophet_adam_bedtime_v1',
      ],
    );

    final restored = BedtimeStoryLearningProgressState.fromJson(state.toJson());
    expect(
      restored
          .progressByActivityId['quiz_story_prophet_adam_bedtime_v1']
          ?.completionState,
      BedtimeStoryLearningCompletionState.inProgress,
    );
    expect(
      restored
          .progressByActivityId['memory_story_prophet_nuh_bedtime_v1']
          ?.isCompleted,
      isTrue,
    );
    expect(
      restored.recentActivityIds.first,
      'memory_story_prophet_nuh_bedtime_v1',
    );
  });
}
