import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/arabic/data/arabic_audio_manifest.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_asset_resolver.dart';
import 'package:path_of_nur/features/learn/quran_teaching/data/quran_teacher_audio_manifest.dart';

void main() {
  test('shared Arabic audio manifest resolves all 28 canonical letters', () {
    expect(
      arabicLetterAudioManifestByCanonicalId.keys,
      orderedEquals(arabicAlphabetLetterIds),
    );

    for (final letter in arabicAlphabetCatalog) {
      final entry = arabicLetterAudioByCanonicalId(letter.id);
      expect(entry, isNotNull);
      expect(entry!.legacyQuranTeachingSeedId, letter.quranTeachingSeedId);
      expect(entry.assetPath, letter.quranTeachingAudioAssetPath);
      expect(entry.spokenTextAr, letter.nameAr);
    }
  });

  test('shared Arabic audio manifest preserves legacy adult seed lookup', () {
    for (final letter in arabicAlphabetCatalog) {
      final entry = arabicLetterAudioByAnyId(letter.quranTeachingSeedId);
      expect(entry, isNotNull);
      expect(entry!.canonicalLetterId, letter.id);
      expect(
        arabicLetterAudioPrimaryAssetPath(letter.quranTeachingSeedId),
        letter.quranTeachingAudioAssetPath,
      );
    }
  });

  test(
    'adult Arabic audio manifest derives letter entries from shared audio',
    () {
      for (final letter in arabicAlphabetCatalog) {
        final sharedEntry = arabicLetterAudioByCanonicalId(letter.id)!;
        final adultEntry =
            quranTeacherAudioManifest[letter.quranTeachingSeedId];
        expect(adultEntry, isNotNull);
        expect(adultEntry!.assetPath, sharedEntry.assetPath);
        expect(adultEntry.alternatePaths, sharedEntry.alternateAssetPaths);
        expect(
          QuranTeachingAssetResolver.fallbackAudioPathForId(
            letter.quranTeachingSeedId,
          ),
          sharedEntry.assetPath,
        );
      }
    },
  );

  test('Kids Arabic letter ids resolve through the shared audio manifest', () {
    for (final letter in kidsArabicLetters) {
      final entry = arabicLetterAudioByCanonicalId(letter.id);
      expect(entry, isNotNull);
      expect(entry!.spokenTextAr, letter.nameAr);
    }
  });

  test('unknown shared Arabic audio ids fail safely', () {
    expect(arabicLetterAudioByAnyId('missing_letter'), isNull);
    expect(
      QuranTeachingAssetResolver.fallbackAudioPathForId('missing_letter'),
      isNull,
    );
  });
}
