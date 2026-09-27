import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_transliteration_local_data.dart';
import 'package:path_of_nur/features/tvos/application/tvos_quran_export.dart';
import 'package:quran/quran.dart' as q;

/// The Apple TV carries a generated copy of the Qur'an it shows: the list of
/// surahs as Swift, the verses as JSON resources. These tests fail when a
/// file is not exactly what the phone's sources give, or is not bundled; run
/// with `REGENERATE_TV_QURAN=1` to rewrite the files.
void main() {
  const regenerate =
      'Run REGENERATE_TV_QURAN=1 '
      'flutter test test/features/tvos/tvos_quran_parity_test.dart';

  final generated = <String, String>{
    tvQuranIndexPath: renderTvQuranSwift(),
    for (final entry in renderTvQuranResources().entries)
      '$tvQuranResourceDirectory/${entry.key}': entry.value,
  };

  List<List<String>> decode(String file) {
    final document =
        jsonDecode(File('$tvQuranResourceDirectory/$file').readAsStringSync())
            as List<dynamic>;
    return [
      for (final surah in document) (surah as List<dynamic>).cast<String>(),
    ];
  }

  test('generated TV Qur’an files match the phone’s sources', () {
    if (Platform.environment['REGENERATE_TV_QURAN'] == '1') {
      Directory(tvQuranResourceDirectory).createSync(recursive: true);
      for (final entry in generated.entries) {
        File(entry.key).writeAsStringSync(entry.value);
      }
    }
    for (final entry in generated.entries) {
      final file = File(entry.key);
      expect(file.existsSync(), isTrue, reason: '${entry.key} is missing');
      expect(
        file.readAsStringSync() == entry.value,
        isTrue,
        reason: '${entry.key} is stale. $regenerate',
      );
    }
  });

  test('nothing is left in the resource folder that is not generated', () {
    final onDisk = Directory(tvQuranResourceDirectory)
        .listSync()
        .map((entity) => entity.uri.pathSegments.last)
        .where((name) => !name.startsWith('.'))
        .toSet();
    expect(onDisk, tvQuranResourceFiles.toSet());
  });

  test('the list holds all 114 surahs, as the phone names them', () {
    final index = File(tvQuranIndexPath).readAsStringSync();
    expect('TVQuranSurah('.allMatches(index).length, q.totalSurahCount);
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      expect(
        index,
        contains(
          '      number: $surah,\n'
          '      arabicName: "${q.getSurahNameArabic(surah)}",\n'
          '      transliteratedName: "${q.getSurahName(surah)}",\n'
          '      englishName: "${q.getSurahNameEnglish(surah)}",\n'
          '      verseCount: ${q.getVerseCount(surah)},\n'
          '      revelationPlace: "${q.getPlaceOfRevelation(surah)}"\n',
        ),
      );
    }
  });

  // Read back from the files as the television reads them, and held against
  // the phone's sources verse by verse, not against the renderer.
  test('every verse of the Arabic is the verse the phone shows', () {
    final arabic = decode(tvQuranArabicFile);
    expect(arabic, hasLength(q.totalSurahCount));
    var verses = 0;
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      expect(arabic[surah - 1], hasLength(q.getVerseCount(surah)));
      for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah++) {
        final verse = arabic[surah - 1][ayah - 1];
        expect(verse, q.getVerse(surah, ayah), reason: '$surah:$ayah');
        expect(verse.trim(), isNotEmpty, reason: '$surah:$ayah');
        verses++;
      }
    }
    expect(verses, q.totalVerseCount);
  });

  test('every verse has the reading the phone shows', () {
    final transliteration = decode(tvQuranTransliterationFile);
    expect(transliteration, hasLength(q.totalSurahCount));
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      final rows = quranTransliterationLocalData[surah]!;
      expect(rows, hasLength(q.getVerseCount(surah)), reason: 'surah $surah');
      expect(transliteration[surah - 1], rows, reason: 'surah $surah');
      expect(
        rows.where((row) => row.trim().isEmpty),
        isEmpty,
        reason: 'surah $surah',
      );
    }
  });

  for (final entry in tvQuranTranslations.entries) {
    test('every verse has the ${entry.key} meaning the phone shows', () {
      final translation = decode(tvQuranTranslationFile(entry.key));
      expect(translation, hasLength(q.totalSurahCount));
      for (var surah = 1; surah <= q.totalSurahCount; surah++) {
        expect(translation[surah - 1], hasLength(q.getVerseCount(surah)));
        for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah++) {
          final verse = translation[surah - 1][ayah - 1];
          expect(
            verse,
            q.getVerseTranslation(surah, ayah, translation: entry.value).trim(),
            reason: '$surah:$ayah',
          );
          expect(verse, isNotEmpty, reason: '$surah:$ayah');
        }
      }
    });
  }

  // The television finds a surah by its line, so the shape is part of the
  // contract: an opening line, a line for each surah, a closing line.
  test('every resource is written a surah to a line', () {
    for (final name in tvQuranResourceFiles) {
      final lines = const LineSplitter().convert(
        File('$tvQuranResourceDirectory/$name').readAsStringSync(),
      );
      expect(lines, hasLength(q.totalSurahCount + 2), reason: name);
      expect(lines.first, '[', reason: name);
      expect(lines.last, ']', reason: name);
      for (var surah = 1; surah <= q.totalSurahCount; surah++) {
        final line = lines[surah];
        final isLast = surah == q.totalSurahCount;
        expect(line.endsWith(isLast ? ']' : '],'), isTrue, reason: name);
        final verses =
            jsonDecode(isLast ? line : line.substring(0, line.length - 1))
                as List<dynamic>;
        expect(verses, hasLength(q.getVerseCount(surah)), reason: name);
      }
    }
  });

  test('every resource is bundled with the Apple TV target', () {
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    final target = RegExp(
      r'/\* PathOfNurTV \*/ = \{\s+isa = PBXNativeTarget;[\s\S]*?buildPhases = \(([\s\S]*?)\);',
    ).firstMatch(project);
    expect(target, isNotNull, reason: 'PathOfNurTV target not found');
    final phaseId = RegExp(
      r'(\w+) /\* Resources \*/',
    ).firstMatch(target!.group(1)!)!.group(1)!;
    final phase = RegExp(
      '$phaseId /\\* Resources \\*/ = \\{[\\s\\S]*?files = \\(([\\s\\S]*?)\\);',
    ).firstMatch(project)!.group(1)!;
    for (final name in tvQuranResourceFiles) {
      expect(
        phase,
        contains('/* $name in Resources */'),
        reason: '$name is not in the PathOfNurTV Resources phase',
      );
    }
  });
}
