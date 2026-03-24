import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_beginner_words_data.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/learn/quran_teaching/data/quran_teacher_master_content.dart';

void main() {
  test('shared Arabic alphabet catalog covers the full 28-letter sequence', () {
    expect(arabicAlphabetCatalog, hasLength(28));
    expect(
      arabicAlphabetCatalog.map((letter) => letter.order),
      orderedEquals(List<int>.generate(28, (index) => index + 1)),
    );
    expect(
      arabicAlphabetCatalog.map((letter) => letter.id).toSet(),
      hasLength(28),
    );
    expect(
      arabicAlphabetCatalog.map((letter) => letter.quranTeachingSeedId).toSet(),
      hasLength(28),
    );
  });

  test('Kids Arabic letters read from the shared canonical ids', () {
    expect(
      kidsArabicLetters.map((letter) => letter.id),
      orderedEquals(arabicAlphabetLetterIds),
    );
    for (final letter in kidsArabicLetters) {
      final shared = arabicAlphabetLetterById(letter.id);
      expect(shared, isNotNull);
      expect(letter.glyph, shared!.glyph);
      expect(letter.nameAr, shared.nameAr);
      expect(letter.transliteration, shared.kidsTransliteration);
    }
  });

  test(
    'shared Arabic positional forms cover all 28 letters with explicit joinability',
    () {
      for (final letter in arabicAlphabetCatalog) {
        expect(letter.positionalForms.isolated, isNotEmpty);
        expect(letter.positionalForms.finalForm, isNotNull);
        expect(letter.positionalForms.finalForm, isNotEmpty);
        if (letter.joiningBehavior.joinsToNext) {
          expect(letter.positionalForms.initial, isNotNull);
          expect(letter.positionalForms.initial, isNotEmpty);
          expect(letter.positionalForms.medial, isNotNull);
          expect(letter.positionalForms.medial, isNotEmpty);
        } else {
          expect(letter.positionalForms.initial, isNull);
          expect(letter.positionalForms.medial, isNull);
        }
      }

      final nonJoiningForwardIds = arabicAlphabetCatalog
          .where((letter) => !letter.joiningBehavior.joinsToNext)
          .map((letter) => letter.id);
      expect(
        nonJoiningForwardIds,
        orderedEquals(const ['alif', 'dal', 'dhal', 'ra', 'zay', 'waw']),
      );
    },
  );

  test(
    'adult Qur’anic Arabic alphabet seeds map back to the shared catalog',
    () {
      expect(
        quranTeacherAlphabetSeeds,
        hasLength(arabicAlphabetCatalog.length),
      );
      for (var index = 0; index < quranTeacherAlphabetSeeds.length; index++) {
        final seed = quranTeacherAlphabetSeeds[index];
        final shared = arabicAlphabetCatalog[index];
        expect(seed.id, shared.quranTeachingSeedId);
        expect(seed.letter, shared.glyph);
        expect(seed.name, shared.adultNameEn);
        expect(seed.transliteration, shared.adultTransliteration);
        expect(seed.audioAsset, shared.quranTeachingAudioAssetPath);
        expect(
          arabicAlphabetLetterByQuranTeachingSeedId(seed.id)?.id,
          shared.id,
        );
      }
    },
  );

  test('adult letter shape seeds now read the full shared form catalog', () {
    expect(
      quranTeacherLetterShapeSeeds,
      hasLength(arabicAlphabetCatalog.length),
    );
    for (var index = 0; index < quranTeacherLetterShapeSeeds.length; index++) {
      final seed = quranTeacherLetterShapeSeeds[index];
      final shared = arabicAlphabetCatalog[index];
      expect(seed.canonicalLetterId, shared.id);
      expect(seed.letter, shared.glyph);
      expect(seed.isolated, shared.positionalForms.isolated);
      expect(seed.initial, shared.positionalForms.initial);
      expect(seed.medial, shared.positionalForms.medial);
      expect(seed.finalForm, shared.positionalForms.finalForm);
    }
  });

  test(
    'Kids beginner words derive joined letter visuals from the shared forms',
    () {
    final bab = kidsArabicBeginnerWordById('bab');
    expect(bab, isNotNull);
    expect(
      bab!.joiningExamples.map((item) => item.joinedGlyph),
      orderedEquals(const ['بـ', 'ـا', 'ب']),
    );

      final noor = kidsArabicBeginnerWordById('noor');
      expect(noor, isNotNull);
      expect(
        noor!.joiningExamples.map((item) => item.joinedGlyph),
        orderedEquals(const ['نـ', 'ـو', 'ر']),
      );

      final qalam = kidsArabicBeginnerWordById('qalam');
      expect(qalam, isNotNull);
      expect(
        qalam!.joiningExamples.map((item) => item.joinedGlyph),
        orderedEquals(const ['قـ', 'ـلـ', 'ـم']),
      );

      final resolved = resolveArabicLetterSequenceForms(const [
        'qaf',
        'lam',
        'meem',
      ]);
      expect(
        resolved.map((item) => item.displayGlyph),
        orderedEquals(const ['قـ', 'ـلـ', 'ـم']),
      );
    },
  );

  test(
    'all tracing-supported shared letters still resolve in Kids tracing',
    () {
      for (final letter in arabicAlphabetCatalog.where(
        (letter) => letter.supportsTracing,
      )) {
        expect(kidsArabicSupportsVectorTracing(letter.id), isTrue);
      }
    },
  );
}
