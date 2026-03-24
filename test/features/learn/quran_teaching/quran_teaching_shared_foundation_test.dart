import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/arabic/data/arabic_beginner_content_catalog.dart';
import 'package:path_of_nur/features/arabic/application/arabic_learning_lesson_packs_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';
import 'package:path_of_nur/features/learn/quran_teaching/data/quran_teacher_master_content.dart';
import 'package:path_of_nur/features/learn/quran_teaching/data/quran_teaching_seed_data.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'adult Arabic foundations module still exposes full alphabet coverage',
    () {
      final foundations = quranTeachingCatalog.moduleById('foundations');
      expect(foundations, isNotNull);

      final shapeLesson = quranTeachingCatalog.lessonById('letter_shapes_core');
      expect(shapeLesson, isNotNull);
      expect(shapeLesson!.steps, hasLength(arabicAlphabetCatalog.length));
      expect(
        shapeLesson.steps.map((step) => step.id),
        orderedEquals(
          arabicAlphabetCatalog.map((letter) => 'shape_${letter.id}'),
        ),
      );
    },
  );

  test(
    'adult alphabet lessons still read shared letter ids in canonical order',
    () {
      final introLessons = quranTeachingCatalog.lessons
          .where((lesson) => lesson.id.startsWith('alphabet_letters_'))
          .toList(growable: false);
      final introducedIds = introLessons
          .expand((lesson) => lesson.steps)
          .map((step) => arabicAlphabetLetterByQuranTeachingSeedId(step.id)?.id)
          .whereType<String>()
          .toList(growable: false);

      expect(introducedIds, orderedEquals(arabicAlphabetLetterIds));
    },
  );

  test(
    'recommended adult Arabic lesson advances in module order after completion',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      expect(
        container.read(quranTeachingRecommendedLessonProvider)?.id,
        'alphabet_letters_1',
      );

      container
          .read(quranTeachingProgressProvider.notifier)
          .completeLesson('alphabet_letters_1');

      expect(
        container.read(quranTeachingRecommendedLessonProvider)?.id,
        'alphabet_letters_2',
      );
    },
  );

  test(
    'adult shared beginner words and phrases stay aligned with shared Arabic content',
    () {
      final adultNoor = quranTeacherFirst100Words.firstWhere(
        (item) => item.id == 'word_nur',
      );
      final sharedNoor = arabicSharedBeginnerWordById('noor');
      expect(sharedNoor, isNotNull);
      expect(adultNoor.word, sharedNoor!.arabicText);
      expect(
        adultNoor.transliteration.toLowerCase(),
        sharedNoor.transliteration,
      );
      expect(adultNoor.meaning, sharedNoor.simpleMeaning);

      final adultKitab = quranTeacherFirst100Words.firstWhere(
        (item) => item.id == 'word_kitab',
      );
      final sharedKitab = arabicSharedBeginnerWordById('kitab');
      expect(sharedKitab, isNotNull);
      expect(adultKitab.word, sharedKitab!.arabicText);
      expect(
        adultKitab.transliteration.toLowerCase(),
        sharedKitab.transliteration,
      );
      expect(adultKitab.meaning, sharedKitab.simpleMeaning);

      final adultBismillah = quranTeacherPhraseSeeds.firstWhere(
        (item) => item.id == 'phrase_bismillah',
      );
      final sharedBismillah = arabicSharedMiniPhraseById('bismillah');
      expect(sharedBismillah, isNotNull);
      expect(adultBismillah.arabic, sharedBismillah!.arabicText);
      expect(
        adultBismillah.transliteration.toLowerCase(),
        sharedBismillah.transliteration,
      );
      expect(adultBismillah.meaning, sharedBismillah.simpleMeaning);

      final adultRabbilAlamin = quranTeacherPhraseSeeds.firstWhere(
        (item) => item.id == 'phrase_rabb_alamin',
      );
      final sharedRabbilAlamin = arabicSharedMiniPhraseById('rabbil-alamin');
      expect(sharedRabbilAlamin, isNotNull);
      expect(adultRabbilAlamin.arabic, sharedRabbilAlamin!.arabicText);
      expect(
        adultRabbilAlamin.transliteration.toLowerCase(),
        sharedRabbilAlamin.transliteration,
      );
      expect(adultRabbilAlamin.meaning, sharedRabbilAlamin.simpleMeaning);
    },
  );

  test(
    'adult beginner words provider follows shared beginner order with linked letters',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final words = container.read(quranTeachingBeginnerWordsProvider);

      expect(
        words.map((word) => word.sharedBeginnerWordId),
        orderedEquals(arabicSharedBeginnerWordOrderIds),
      );
      expect(words.every((word) => word.letterIds.isNotEmpty), isTrue);
      expect(
        words.firstWhere((word) => word.sharedBeginnerWordId == 'bab').audio,
        isNotNull,
      );
      expect(
        words.firstWhere((word) => word.sharedBeginnerWordId == 'noor').audio,
        isNotNull,
      );
      expect(
        words.firstWhere((word) => word.sharedBeginnerWordId == 'bab').audio!.fallbackTextLabel,
        'باب',
      );
    },
  );

  test('adult lesson packs stay linked to existing module owners', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final packs = container.read(
      arabicLearningLessonPacksProvider(ArabicLearningAudience.adult),
    );

    expect(
      packs.firstWhere((pack) => pack.id == 'adult_beginner_letters_pack').primaryTarget.moduleId,
      'foundations',
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_phrase_reading_pack').primaryTarget.moduleId,
      'phrase_reading',
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_tajweed_support_pack').primaryTarget.moduleId,
      'tajweed_basics',
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_daily_words_theme_pack').primaryTarget.kind,
      ArabicLearningRouteTargetKind.goNamed,
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_daily_words_theme_pack').primaryTarget.routeName,
      'quranArabicReadiness',
    );
    expect(
      packs.firstWhere((pack) => pack.id == 'adult_quran_linked_words_theme_pack').itemIds,
      contains('phrase:bismillah'),
    );
  });
}
