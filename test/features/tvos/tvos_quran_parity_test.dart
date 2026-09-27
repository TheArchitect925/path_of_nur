import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_quran_export.dart';
import 'package:quran/quran.dart' as q;

/// The Apple TV carries a generated copy of the Qur'an text it shows. This
/// test fails when the Swift file is not exactly what the phone's sources
/// give; run with `REGENERATE_TV_QURAN=1` to rewrite it.
void main() {
  const path = 'ios/PathOfNurTV/Data/TVQuranData.swift';

  test('generated TV Qur’an text matches the phone’s sources', () {
    final rendered = renderTvQuranSwift();
    final file = File(path);
    if (Platform.environment['REGENERATE_TV_QURAN'] == '1') {
      file.writeAsStringSync(rendered);
    }
    expect(file.existsSync(), isTrue, reason: '$path is missing');
    expect(
      file.readAsStringSync(),
      rendered,
      reason:
          'TV Qur’an text is stale. Run REGENERATE_TV_QURAN=1 '
          'flutter test test/features/tvos/tvos_quran_parity_test.dart',
    );
  });

  test('every listed surah is whole, in every language it carries', () {
    final rendered = renderTvQuranSwift();
    var verses = 0;
    for (final number in tvQuranSurahNumbers) {
      verses += q.getVerseCount(number);
      expect(rendered, contains('number: $number,'));
    }
    expect('TVQuranVerse('.allMatches(rendered).length, verses);
    expect('"en": "'.allMatches(rendered).length, verses);
    expect('"fr": "'.allMatches(rendered).length, verses);
    expect('"ur": "'.allMatches(rendered).length, verses);
    // No verse is left without its Arabic, its reading or its meaning.
    expect(rendered, isNot(contains('arabic: "",')));
    expect(rendered, isNot(contains('transliteration: "",')));
    expect(rendered, isNot(contains('": "",')));
  });
}
