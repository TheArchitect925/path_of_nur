import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/arabic/data/arabic_letter_pictures.dart';
import 'package:path_of_nur/features/learn/quran_teaching/data/quran_teacher_visual_manifest.dart';

/// K3b: every letter of the alphabet has one picture, the file is real, and
/// the Qur'an teacher's visual manifest names the same file, so the kids
/// Letters lesson and the teacher's visual mode never disagree.
void main() {
  test('every letter in the catalog has a picture', () {
    for (final letter in arabicAlphabetCatalog) {
      expect(
        arabicLetterPictureFor(letter.id),
        isNotNull,
        reason: '${letter.id} (${letter.glyph}) has no picture',
      );
    }
    expect(arabicLetterPictures.length, arabicAlphabetCatalog.length);
  });

  test('every picture is a real file and used once', () {
    final paths = arabicLetterPictures.map((p) => p.assetPath).toList();
    expect(paths.toSet().length, paths.length);
    for (final picture in arabicLetterPictures) {
      expect(
        File(picture.assetPath).existsSync(),
        isTrue,
        reason: '${picture.letterId} points at ${picture.assetPath}',
      );
    }
  });

  test('the teacher manifest names the same files', () {
    final letterEntries = quranTeacherVisualManifest.values.where(
      (entry) => entry.category == 'letters',
    );
    expect(letterEntries.length, arabicLetterPictures.length);
    for (final picture in arabicLetterPictures) {
      final entry = quranTeacherVisualManifest[picture.manifestId];
      expect(entry, isNotNull, reason: '${picture.manifestId} not in manifest');
      expect(entry!.assetPath, picture.assetPath);
      expect(entry.label, picture.label);
    }
  });

  test('a word a child says is spelled out for Arabic words', () {
    expect(arabicLetterPictureFor('ba')!.spokenWord, 'ball');
    expect(arabicLetterPictureFor('kha')!.spokenWord, 'khayma (tent)');
  });
}
