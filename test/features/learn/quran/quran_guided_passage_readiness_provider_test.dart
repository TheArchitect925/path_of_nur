import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_guided_passage_readiness_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_guided_passage_readiness_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'guided passage readiness resolves curated Al-Fatihah passage set',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final passages = container.read(
        quranGuidedPassageReadinessPassagesProvider,
      );
      final opening = passages.firstWhere(
        (item) => item.id == 'fatihah_opening_passage',
      );
      final response = passages.firstWhere(
        (item) => item.id == 'fatihah_response_passage',
      );
      final full = passages.firstWhere(
        (item) => item.id == 'fatihah_full_passage',
      );

      expect(
        passages.map((item) => item.id),
        orderedEquals(<String>[
          'fatihah_opening_passage',
          'fatihah_response_passage',
          'fatihah_full_passage',
        ]),
      );
      expect(opening.ayahCount, 4);
      expect(response.ayahCount, 3);
      expect(full.ayahCount, 7);
      expect(opening.ayahs.first.arabic, contains('بِسْمِ اللَّهِ'));
      expect(response.ayahs.first.arabic, contains('إِيَّاكَ'));
      expect(
        full.familiarSnippets.map((item) => item.id),
        containsAll(<String>[
          'bismillah_bridge',
          'alhamdulillah_bridge',
          'rabbil_alamin_bridge',
          'maliki_yawm_id_deen_bridge',
          'iyyaka_nabudu_bridge',
          'ihdina_sirat_bridge',
        ]),
      );
    },
  );

  test(
    'kids guided passage summary starts from the opening Al-Fatihah passage',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        quranGuidedPassageReadinessSummaryProvider(ArabicLearningAudience.kids),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.start);
      expect(summary.passage.id, 'fatihah_opening_passage');
      expect(
        summary.currentStage,
        QuranGuidedPassageReadinessStage.familiarOpening,
      );
      expect(summary.routeName, 'kidsArabicGuidedPassages');
    },
  );

  test(
    'adult guided passage summary continues to next passage after one opening',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(
            quranGuidedPassageReadinessProgressProvider(
              ArabicLearningAudience.adult,
            ).notifier,
          )
          .markPassageOpened('fatihah_opening_passage');

      final summary = container.read(
        quranGuidedPassageReadinessSummaryProvider(
          ArabicLearningAudience.adult,
        ),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.continueForward);
      expect(summary.passage.id, 'fatihah_response_passage');
      expect(
        summary.currentStage,
        QuranGuidedPassageReadinessStage.completingFatihah,
      );
      expect(summary.routeName, 'quranArabicGuidedPassages');
    },
  );
}
