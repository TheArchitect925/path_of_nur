import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_short_surah_readiness_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_short_surah_readiness_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('short surah readiness resolves curated beginner surah set', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final surahs = container.read(quranShortSurahReadinessSurahsProvider);
    final ikhlas = surahs.firstWhere((item) => item.surahNumber == 112);
    final kawthar = surahs.firstWhere((item) => item.surahNumber == 108);

    expect(
      surahs.map((item) => item.surahNumber),
      orderedEquals([112, 108, 113, 114]),
    );
    expect(ikhlas.ayahCount, 4);
    expect(ikhlas.ayahs.first.arabic, contains('قُلْ هُوَ اللَّهُ أَحَدٌ'));
    expect(
      ikhlas.familiarSnippets.map((item) => item.id),
      containsAll(<String>[
        'qul_huwa_allahu_ahad_bridge',
        'allahu_samad_bridge',
      ]),
    );
    expect(kawthar.ayahCount, 3);
    expect(kawthar.stage, QuranShortSurahReadinessStage.gentleExpansion);
  });

  test('kids short surah summary starts from al-ikhlas', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(
      quranShortSurahReadinessSummaryProvider(ArabicLearningAudience.kids),
    );

    expect(summary.intent, ArabicLearningContinuationIntent.start);
    expect(summary.surah.surahNumber, 112);
    expect(
      summary.currentStage,
      QuranShortSurahReadinessStage.firstCompleteSurah,
    );
    expect(summary.routeName, 'kidsArabicShortSurahs');
  });

  test(
    'adult short surah summary continues to the next curated surah',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(
            quranShortSurahReadinessProgressProvider(
              ArabicLearningAudience.adult,
            ).notifier,
          )
          .markSurahOpened(112);

      final summary = container.read(
        quranShortSurahReadinessSummaryProvider(ArabicLearningAudience.adult),
      );

      expect(summary.intent, ArabicLearningContinuationIntent.continueForward);
      expect(summary.surah.surahNumber, 108);
      expect(summary.routeName, 'quranArabicShortSurahs');
    },
  );
}
