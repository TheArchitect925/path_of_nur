import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_readiness_bridge_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_readiness_bridge_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'quran readiness bridge resolves curated snippet text from real ayahs',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final snippets = container.read(quranReadinessBridgeSnippetsProvider);
      final bismillah = snippets.firstWhere(
        (item) => item.id == 'bismillah_bridge',
      );
      final rabbilAlamin = snippets.firstWhere(
        (item) => item.id == 'rabbil_alamin_bridge',
      );
      final qulhuwa = snippets.firstWhere(
        (item) => item.id == 'qul_huwa_allahu_ahad_bridge',
      );

      expect(snippets, hasLength(8));
      expect(bismillah.snippetArabic, 'بِسْمِ اللَّهِ');
      expect(bismillah.ref.locationLabel, 'Qur’an 1:1');
      expect(rabbilAlamin.snippetArabic, 'رَبِّ الْعَالَمِينَ');
      expect(rabbilAlamin.ayahArabic, contains('الْحَمْدُ'));
      expect(qulhuwa.snippetArabic, 'قُلْ هُوَ اللَّهُ أَحَدٌ');
      expect(qulhuwa.ref.locationLabel, 'Qur’an 112:1');
      expect(qulhuwa.hints, isNotEmpty);
      expect(
        qulhuwa.hints.first.type,
        QuranReadinessPronunciationHintType.bounce,
      );
      expect(qulhuwa.hints.first.adultTarget?.lessonId, 'qalqalah_intro');
    },
  );

  test('kids quran readiness summary starts from the first snippet', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(
      quranReadinessBridgeSummaryProvider(ArabicLearningAudience.kids),
    );

    expect(summary.intent, ArabicLearningContinuationIntent.start);
    expect(summary.snippet.id, 'bismillah_bridge');
    expect(summary.currentLevel, QuranReadinessBridgeLevel.firstRecognition);
    expect(summary.routeName, 'kidsArabicQuranReadiness');
  });

  test(
    'adult quran readiness summary continues forward after one snippet',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(
            quranReadinessBridgeProgressProvider(
              ArabicLearningAudience.adult,
            ).notifier,
          )
          .markSnippetOpened('bismillah_bridge');

      final summary = container.read(
        quranReadinessBridgeSummaryProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.continueForward);
      expect(summary.snippet.id, 'alhamdulillah_bridge');
      expect(summary.routeName, 'quranArabicReadiness');
    },
  );

  test(
    'bridge progression advances into the next level after first level snippets',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        quranReadinessBridgeProgressProvider(
          ArabicLearningAudience.adult,
        ).notifier,
      );
      notifier.markSnippetOpened('bismillah_bridge');
      notifier.markSnippetOpened('alhamdulillah_bridge');
      notifier.markSnippetOpened('rabbil_alamin_bridge');

      final summary = container.read(
        quranReadinessBridgeSummaryProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.continueForward);
      expect(summary.snippet.id, 'maliki_yawm_id_deen_bridge');
      expect(summary.currentLevel, QuranReadinessBridgeLevel.familiarPhrases);
    },
  );
}
