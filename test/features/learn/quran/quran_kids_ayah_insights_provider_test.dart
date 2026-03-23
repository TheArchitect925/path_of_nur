import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_kids_ayah_insights_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah_enrichment_models.dart';

void main() {
  test('kids ayah insights only expose the curated safe entry set', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final items = container.read(quranKidsAyahInsightsProvider);

    expect(items.map((item) => item.id).toSet(), {
      'signs_sun_moon_10_5',
      'signs_animals_24_45',
      'worship_salah_20_14',
      'worship_dhikr_2_152',
      'worship_gratitude_31_12',
      'worship_reliance_33_3',
      'character_parents_17_23_24',
      'character_good_conduct_41_34',
      'prophets_reliance_26_62',
      'prophets_trials_21_83_84',
    });
  });

  test(
    'kids ayah insights exclude caution-heavy and warning-oriented entries',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final items = container.read(quranKidsAyahInsightsProvider);

      for (final item in items) {
        expect(item.entry.cautionLevel, QuranAyahCautionLevel.none);
        expect(
          item.entry.lessonType == QuranAyahEnrichmentLessonType.warning,
          isFalse,
        );
        expect(
          item.entry.domain == QuranAyahEnrichmentDomain.akhirahAccountability,
          isFalse,
        );
        expect(
          item.entry.displayType ==
              QuranAyahDisplayItemType.scientificReflection,
          isFalse,
        );
      }
    },
  );

  test('kids ayah insight sections expose the intended V1 categories', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sections = container.read(quranKidsAyahInsightSectionsProvider);

    expect(
      sections.map((section) => section.category).toList(growable: false),
      [
        KidsQuranAyahInsightCategory.signsInCreation,
        KidsQuranAyahInsightCategory.prayerAndRemembrance,
        KidsQuranAyahInsightCategory.gratitudeAndTrust,
        KidsQuranAyahInsightCategory.kindnessAndGoodManners,
        KidsQuranAyahInsightCategory.prophetLessons,
      ],
    );
    expect(sections.every((section) => section.items.isNotEmpty), isTrue);
  });
}
