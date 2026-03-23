import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_mastery_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('mastery provider maps initial frontier as practicing', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final statuses = container.read(kidsArabicMasteryStatusesProvider);
    final recommendation = container.read(
      kidsArabicMasteryRecommendationProvider,
    );

    expect(statuses.first.letter.id, 'alif');
    expect(statuses.first.state, KidsArabicMasteryState.practicing);
    expect(statuses[1].state, KidsArabicMasteryState.notStarted);
    expect(
      recommendation?.type,
      KidsArabicMasteryRecommendationType.continueSequence,
    );
    expect(recommendation?.letter.id, 'alif');
  });

  test(
    'mastery recommendation prefers review before the next sequence letter',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final notifier = container.read(kidsArabicProgressProvider.notifier);
      final alif = kidsArabicLetters.firstWhere((item) => item.id == 'alif');

      notifier.completeLesson(
        letter: alif,
        traceResult: KidsArabicTraceResult.completed,
      );

      final recommendation = container.read(
        kidsArabicMasteryRecommendationProvider,
      );
      final reviewCandidates = container.read(
        kidsArabicReviewCandidatesProvider,
      );

      expect(
        recommendation?.type,
        KidsArabicMasteryRecommendationType.reviewLetter,
      );
      expect(recommendation?.letter.id, 'alif');
      expect(reviewCandidates.map((item) => item.id), contains('alif'));
    },
  );

  test(
    'clearing review moves recommendation to the next unlocked letter',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final notifier = container.read(kidsArabicProgressProvider.notifier);
      final alif = kidsArabicLetters.firstWhere((item) => item.id == 'alif');

      notifier.completeLesson(
        letter: alif,
        traceResult: KidsArabicTraceResult.completed,
      );
      notifier.recordReviewAnswer(letterId: 'alif', correct: true);

      final statuses = container.read(kidsArabicMasteryStatusesProvider);
      final recommendation = container.read(
        kidsArabicMasteryRecommendationProvider,
      );

      expect(
        statuses.firstWhere((item) => item.letter.id == 'ba').state,
        KidsArabicMasteryState.practicing,
      );
      expect(
        recommendation?.type,
        KidsArabicMasteryRecommendationType.continueSequence,
      );
      expect(recommendation?.letter.id, 'ba');
    },
  );
}
