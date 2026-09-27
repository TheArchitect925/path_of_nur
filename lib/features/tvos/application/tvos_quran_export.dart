import 'dart:convert';

import 'package:quran/quran.dart' as q;

import '../../learn/quran/data/quran_transliteration_local_data.dart';

/// Where the Apple TV target keeps the Qur'an it shows.
const tvQuranIndexPath = 'ios/PathOfNurTV/Data/TVQuranData.swift';
const tvQuranResourceDirectory = 'ios/PathOfNurTV/Data/Quran';

const tvQuranArabicFile = 'TVQuranArabic.json';
const tvQuranTransliterationFile = 'TVQuranTransliteration.json';

/// The translations the Apple TV carries, by language code, and the source
/// each is taken from. English is what a language without one falls back to.
const tvQuranTranslations = <String, q.Translation>{
  'en': q.Translation.enSaheeh,
  'fr': q.Translation.frHamidullah,
  'ur': q.Translation.urdu,
};

String tvQuranTranslationFile(String language) =>
    'TVQuranTranslation_$language.json';

/// Every resource file the Apple TV target bundles, in a fixed order.
List<String> get tvQuranResourceFiles => [
  tvQuranArabicFile,
  tvQuranTransliterationFile,
  for (final language in tvQuranTranslations.keys)
    tvQuranTranslationFile(language),
];

/// Renders the list of surahs the Apple TV target compiles
/// (`ios/PathOfNurTV/Data/TVQuranData.swift`): all 114, by name and length.
///
/// The words of the Qur'an are never typed into the television by hand. They
/// are taken from where the phone takes them, and
/// `tvos_quran_parity_test.dart` keeps every generated file in step.
String renderTvQuranSwift() {
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE — do not edit by hand.')
    ..writeln('// Source: package:quran (surah names, lengths, places).')
    ..writeln(
      '// The verses are in Data/Quran/*.json, from the same generator.',
    )
    ..writeln(
      '// Regenerate: REGENERATE_TV_QURAN=1 flutter test test/features/tvos/tvos_quran_parity_test.dart',
    )
    ..writeln()
    ..writeln('import Foundation')
    ..writeln()
    ..writeln('enum TVQuranData {')
    ..writeln('  static let surahs: [TVQuranSurah] = [');
  for (var number = 1; number <= q.totalSurahCount; number++) {
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
    ..writeln('}');
  return buffer.toString();
}

/// Renders the verses the Apple TV target bundles, by file name: the Arabic,
/// the transliteration, and one file for each translation.
///
/// Each file is a JSON array of 114 arrays, a surah to a line, in order. A
/// JSON string cannot hold a raw line break, so a line is always one whole
/// surah, and the television reads the surah it is asked for and no other.
Map<String, String> renderTvQuranResources() => {
  tvQuranArabicFile: _document(tvQuranArabic),
  tvQuranTransliterationFile: _document(tvQuranTransliteration),
  for (final entry in tvQuranTranslations.entries)
    tvQuranTranslationFile(entry.key): _document(
      (surah, ayah) => tvQuranTranslation(surah, ayah, entry.value),
    ),
};

/// The Arabic as the phone's reader shows it.
String tvQuranArabic(int surah, int ayah) => q.getVerse(surah, ayah);

/// The transliteration from the phone's bundled table.
String tvQuranTransliteration(int surah, int ayah) {
  final rows = quranTransliterationLocalData[surah] ?? const <String>[];
  return ayah <= rows.length ? rows[ayah - 1] : '';
}

/// The translation as the phone's reader shows it, without the stray spaces
/// some verses carry at their ends.
String tvQuranTranslation(int surah, int ayah, q.Translation translation) =>
    q.getVerseTranslation(surah, ayah, translation: translation).trim();

String _document(String Function(int surah, int ayah) verse) {
  final buffer = StringBuffer('[\n');
  for (var surah = 1; surah <= q.totalSurahCount; surah++) {
    final verses = [
      for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah++)
        verse(surah, ayah),
    ];
    buffer
      ..write(jsonEncode(verses))
      ..write(surah < q.totalSurahCount ? ',\n' : '\n');
  }
  buffer.write(']\n');
  return buffer.toString();
}

String _swift(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n');
  return '"$escaped"';
}
