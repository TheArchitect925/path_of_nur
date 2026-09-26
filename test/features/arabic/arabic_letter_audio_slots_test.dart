import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/arabic/data/arabic_audio_manifest.dart';

/// The letters' audio slots (L6). Every letter resolves to one mp3 under
/// assets/audio/quran_teacher/letters/; the folder is bundled; and nothing
/// lives in that folder that no letter would ever play. Until a slot is
/// recorded (tools/import_kids_letter_audio.py) the app reads the letter's
/// name with the device voice, so an empty folder is a valid state.
void main() {
  const folder = 'assets/audio/quran_teacher/letters/';

  test('every letter has one slot in the letters folder', () {
    final slots = <String, String>{};
    for (final letter in arabicAlphabetCatalog) {
      final path = letter.quranTeachingAudioAssetPath;
      expect(path, startsWith(folder), reason: letter.id);
      expect(path, endsWith('.mp3'), reason: letter.id);
      final owner = slots[path];
      expect(
        owner,
        isNull,
        reason: '${letter.id} and $owner share the slot $path',
      );
      slots[path] = letter.id;
    }
    expect(slots, hasLength(28));
  });

  test('the alternate for ha is the only cross-letter fallback', () {
    for (final letter in arabicAlphabetCatalog) {
      final entry = arabicLetterAudioByCanonicalId(letter.id)!;
      for (final alternate in entry.alternateAssetPaths) {
        expect(alternate, startsWith(folder));
        expect(letter.id, 'ha', reason: 'only ح borrows another slot');
      }
    }
  });

  test('pubspec bundles the letters folder', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('    - $folder\n'));
    expect(Directory(folder).existsSync(), isTrue);
  });

  test('the letters folder holds only letter slots', () {
    final dir = Directory(folder);
    final slots = arabicAlphabetCatalog
        .expand(
          (letter) => [
            letter.quranTeachingAudioAssetPath,
            ...arabicLetterAudioByCanonicalId(letter.id)!.alternateAssetPaths,
          ],
        )
        .toSet();
    for (final file in dir.listSync()) {
      final name = file.uri.pathSegments.last;
      if (name.startsWith('.')) continue;
      expect(
        slots,
        contains('$folder$name'),
        reason:
            '$name matches no letter; see tools/import_kids_letter_audio.py --check',
      );
    }
  });
}
