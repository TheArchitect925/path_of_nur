import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('story progress saves viewed scene count and completion', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 20)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(kidsDuaLearningProvider.notifier);

    notifier.openStory('story_before_sleep');
    notifier.viewStoryScene(storyId: 'story_before_sleep', viewedSceneCount: 3);
    notifier.completeStory('story_before_sleep');

    final state = container.read(kidsDuaLearningProvider);
    final progress = state.storyProgressById['story_before_sleep'];

    expect(progress, isNotNull);
    expect(progress!.viewedSceneCount, 3);
    expect(progress.completed, isTrue);
    expect(state.completedStoryIds, contains('story_before_sleep'));
    expect(state.recentStoryIds.first, 'story_before_sleep');
  });
}
