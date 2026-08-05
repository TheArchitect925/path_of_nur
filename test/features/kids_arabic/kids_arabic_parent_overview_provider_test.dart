import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_parent_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_phrases_provider.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('parent overview starts calm for first-time learners', () async {
    final container = await makeTestContainer(
      overrides: [
        kidsArabicNowProvider.overrideWithValue(() => DateTime(2026, 3, 24, 9)),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(kidsArabicParentOverviewSummaryProvider);

    expect(summary.hasStarted, isFalse);
    expect(summary.lettersLearned, 0);
    expect(summary.wordsPracticed, 0);
    expect(summary.phrasesHeard, 0);
    expect(summary.practicedToday, isFalse);
  });

  test(
    'parent overview reflects recent progress, milestone, and practiced today',
    () async {
      final container = await makeTestContainer(
        overrides: [
          kidsArabicNowProvider.overrideWithValue(
            () => DateTime(2026, 3, 24, 9),
          ),
        ],
      );
      addTearDown(container.dispose);

      final progressNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      final letter = container
          .read(kidsArabicLettersProvider)
          .firstWhere((item) => item.id == 'alif');
      progressNotifier.completeLesson(
        letter: letter,
        traceResult: KidsArabicTraceResult.good,
      );
      container
          .read(kidsArabicWordProgressProvider.notifier)
          .completeWord('bab');
      container
          .read(kidsArabicMiniPhraseProgressProvider.notifier)
          .markPhraseHeard('bismillah');

      final summary = container.read(kidsArabicParentOverviewSummaryProvider);

      expect(summary.hasStarted, isTrue);
      expect(summary.lettersLearned, 1);
      expect(summary.wordsPracticed, 1);
      expect(summary.phrasesHeard, 1);
      expect(summary.practicedToday, isTrue);
      expect(summary.latestAchievementId, isNotNull);
      expect(summary.recentActivity, isNotNull);
      expect(summary.continuation.primaryTarget.routeName, isNotNull);
    },
  );
}
