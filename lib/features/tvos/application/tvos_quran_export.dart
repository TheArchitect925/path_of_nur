import 'package:quran/quran.dart' as q;

import '../../learn/quran/data/quran_transliteration_local_data.dart';

/// The surahs the Apple TV reader carries, in the order it lists them.
const tvQuranSurahNumbers = <int>[1, 94, 112, 113, 114];

/// Renders the Qur'an text the Apple TV target compiles
/// (`ios/PathOfNurTV/Data/TVQuranData.swift`).
///
/// The words of the Qur'an are never typed into the television by hand. They
/// are taken from where the phone takes them: the Arabic and the translations
/// from `package:quran`, the transliteration from the phone's bundled table.
/// Every ayah of every listed surah is written, and
/// `tvos_quran_parity_test.dart` keeps the Swift file in step.
String renderTvQuranSwift({List<int> surahNumbers = tvQuranSurahNumbers}) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE — do not edit by hand.')
    ..writeln('// Source: package:quran (Arabic, translations) and')
    ..writeln(
      '// lib/features/learn/quran/data/quran_transliteration_local_data.dart',
    )
    ..writeln(
      '// Regenerate: REGENERATE_TV_QURAN=1 flutter test test/features/tvos/tvos_quran_parity_test.dart',
    )
    ..writeln()
    ..writeln('import Foundation')
    ..writeln()
    ..writeln('struct TVQuranVerse {')
    ..writeln('  let ayahNumber: Int')
    ..writeln('  let arabic: String')
    ..writeln('  let transliteration: String')
    ..writeln('  /// By language code. English is always present.')
    ..writeln('  let translations: [String: String]')
    ..writeln('}')
    ..writeln()
    ..writeln('enum TVQuranData {')
    ..writeln('  static let surahs: [TVQuranSurah] = [');
  for (final number in surahNumbers) {
    buffer
      ..writeln('    TVQuranSurah(')
      ..writeln('      id: $number,')
      ..writeln('      number: $number,')
      ..writeln('      arabicName: ${_swift(q.getSurahNameArabic(number))},')
      ..writeln('      transliteratedName: ${_swift(q.getSurahName(number))},')
      ..writeln('      englishName: ${_swift(q.getSurahNameEnglish(number))},')
      ..writeln('      verseCount: ${q.getVerseCount(number)},')
      ..writeln(
        '      revelationPlace: ${_swift(q.getPlaceOfRevelation(number))}',
      )
      ..writeln('    ),');
  }
  buffer
    ..writeln('  ]')
    ..writeln()
    ..writeln('  static let verses: [Int: [TVQuranVerse]] = [');
  for (final number in surahNumbers) {
    final transliteration = quranTransliterationLocalData[number] ?? const [];
    buffer.writeln('    $number: [');
    for (var ayah = 1; ayah <= q.getVerseCount(number); ayah++) {
      buffer
        ..writeln('      TVQuranVerse(')
        ..writeln('        ayahNumber: $ayah,')
        ..writeln('        arabic: ${_swift(q.getVerse(number, ayah))},')
        ..writeln(
          '        transliteration: ${_swift(ayah <= transliteration.length ? transliteration[ayah - 1] : '')},',
        )
        ..writeln('        translations: [')
        ..writeln(
          '          "en": ${_swift(_translation(number, ayah, q.Translation.enSaheeh))},',
        )
        ..writeln(
          '          "fr": ${_swift(_translation(number, ayah, q.Translation.frHamidullah))},',
        )
        ..writeln(
          '          "ur": ${_swift(_translation(number, ayah, q.Translation.urdu))},',
        )
        ..writeln('        ]')
        ..writeln('      ),');
    }
    buffer.writeln('    ],');
  }
  buffer
    ..writeln('  ]')
    ..writeln('}');
  return buffer.toString();
}

String _translation(int surah, int ayah, q.Translation translation) =>
    q.getVerseTranslation(surah, ayah, translation: translation).trim();

String _swift(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n');
  return '"$escaped"';
}
