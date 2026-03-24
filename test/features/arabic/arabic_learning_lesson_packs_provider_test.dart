import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_lesson_packs_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_lesson_pack_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids lesson packs stay reachable through existing Arabic routes', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final packs = container.read(
      arabicLearningLessonPacksProvider(ArabicLearningAudience.kids),
    );

    expect(
      packs.map((pack) => pack.id),
      orderedEquals(<String>[
        'kids_beginner_letters_pack',
        'kids_first_words_pack',
        'kids_mini_phrases_pack',
        'kids_daily_words_theme_pack',
        'kids_prayer_words_theme_pack',
        'kids_quran_linked_words_theme_pack',
        'kids_review_pack',
        'kids_quran_readiness_pack',
      ]),
    );
    expect(packs.first.primaryTarget.routeName, 'kidsArabicLesson');
    expect(
      packs.firstWhere((pack) => pack.id == 'kids_daily_words_theme_pack').type,
      ArabicLearningLessonPackType.theme,
    );
    expect(
      packs
          .firstWhere((pack) => pack.id == 'kids_quran_linked_words_theme_pack')
          .itemIds,
      contains('bridge:bismillah_bridge'),
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'kids_review_pack').primaryTarget.routeName,
      'kidsArabicReview',
    );
    expect(packs.any((pack) => pack.isRecommended), isTrue);
  });

  test('adult lesson packs point to existing adult modules and bridge owners', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final packs = container.read(
      arabicLearningLessonPacksProvider(ArabicLearningAudience.adult),
    );

    expect(
      packs.map((pack) => pack.id),
      containsAll(<String>[
        'adult_beginner_letters_pack',
        'adult_first_words_pack',
        'adult_phrase_reading_pack',
        'adult_daily_words_theme_pack',
        'adult_prayer_words_theme_pack',
        'adult_quran_linked_words_theme_pack',
        'adult_review_pack',
        'adult_quran_readiness_pack',
        'adult_tajweed_support_pack',
      ]),
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_beginner_letters_pack').primaryTarget.kind,
      ArabicLearningRouteTargetKind.adultModule,
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_review_pack').primaryTarget.kind,
      ArabicLearningRouteTargetKind.adultDailyReview,
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_quran_readiness_pack').type,
      ArabicLearningLessonPackType.bridge,
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_prayer_words_theme_pack').type,
      ArabicLearningLessonPackType.theme,
    );
    expect(
      packs
          .firstWhere((pack) => pack.id == 'adult_quran_linked_words_theme_pack')
          .itemIds,
      containsAll(<String>['word:rabb', 'phrase:rabbil-alamin']),
    );
  });
}
