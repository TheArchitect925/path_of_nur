import '../../worship/domain/dhikr_preset.dart';
import '../../worship/domain/dhikr_routine.dart';

/// Renders the phone's built-in dhikr routines, and the phrases of its
/// counter, as the Swift data file the Apple TV target compiles
/// (`ios/PathOfNurTV/Data/TVDhikrRoutineData.swift`).
/// The TV has no live link to the phone, so it carries a generated copy;
/// `tvos_dhikr_routines_parity_test.dart` keeps the two in step.
///
/// A phrase is written as a routine of one step, said to [phraseTarget], the
/// count the phone's counter begins at, so that the television's one player
/// counts both.
String renderTvDhikrRoutinesSwift(
  List<DhikrRoutine> routines, {
  List<DhikrPreset> phrases = const <DhikrPreset>[],
  int phraseTarget = 33,
}) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE — do not edit by hand.')
    ..writeln(
      '// Source: lib/features/worship/application/dhikr_routine_catalog.dart',
    )
    ..writeln('//         lib/features/worship/domain/dhikr_preset.dart')
    ..writeln(
      '// Regenerate: REGENERATE_TV_DHIKR_ROUTINES=1 flutter test test/features/tvos/tvos_dhikr_routines_parity_test.dart',
    )
    ..writeln()
    ..writeln('import Foundation')
    ..writeln()
    ..writeln('enum TVDhikrRoutineData {')
    ..writeln('  static let routines: [TVDhikrRoutine] = [');
  for (final routine in routines) {
    if (routine.isCustom) continue;
    buffer
      ..writeln('    TVDhikrRoutine(')
      ..writeln('      id: ${_swift(routine.id)},')
      ..writeln('      kind: ${_swift(routine.kind.name)},')
      ..writeln('      title: tvLocalized(${_swift(_title(routine.kind))}),')
      ..writeln('      subtitle: tvLocalized(${_swift(_subtitle(routine))}),')
      ..writeln('      sourceRef: ${_swift(routine.sourceRef ?? '')},')
      ..writeln('      steps: [');
    for (final step in routine.steps) {
      buffer
        ..writeln('        TVDhikrRoutineStep(')
        ..writeln('          id: ${_swift(step.id)},')
        ..writeln('          title: ${_swift(step.title)},')
        ..writeln('          arabic: ${_swift(step.arabic)},')
        ..writeln('          transliteration: ${_swift(step.transliteration)},')
        ..writeln(
          '          translation: ${_meaning(step.translation, phrases)},',
        )
        ..writeln('          count: ${step.count},')
        ..writeln('          sourceRef: ${_swift(step.sourceRef)}')
        ..writeln('        ),');
    }
    buffer
      ..writeln('      ]')
      ..writeln('    ),');
  }
  buffer
    ..writeln('  ]')
    ..writeln()
    ..writeln('  static let phrases: [TVDhikrRoutine] = [');
  for (final phrase in phrases) {
    buffer
      ..writeln('    TVDhikrRoutine(')
      ..writeln('      id: ${_swift(tvDhikrPhraseRoutineId(phrase))},')
      ..writeln('      kind: "phrase",')
      ..writeln('      title: ${_swift(_voice(phrase.label))},')
      ..writeln('      subtitle: "",')
      ..writeln('      sourceRef: "",')
      ..writeln('      steps: [')
      ..writeln('        TVDhikrRoutineStep(')
      ..writeln('          id: ${_swift(phrase.id)},')
      ..writeln('          title: ${_swift(_voice(phrase.label))},')
      ..writeln('          arabic: ${_swift(phrase.phrase)},')
      ..writeln(
        '          transliteration: ${_swift(_voice(phrase.transliteration))},',
      )
      ..writeln(
        '          translation: tvLocalized(${_swift(tvDhikrPhraseMeaning(phrase))}),',
      )
      ..writeln('          count: $phraseTarget,')
      ..writeln('          sourceRef: ""')
      ..writeln('        ),')
      ..writeln('      ]')
      ..writeln('    ),');
  }
  buffer
    ..writeln('  ]')
    ..writeln('}');
  return buffer.toString();
}

/// What a step of a routine means. Where it is one of the counter's phrases
/// and means the same, it is said as the phrase is, in the language of the
/// television; the rest of the catalog is in English only.
String _meaning(String translation, List<DhikrPreset> phrases) {
  final english = _english(translation);
  for (final phrase in phrases) {
    if (tvDhikrPhraseMeaning(phrase) == english) {
      return 'tvLocalized(${_swift(english)})';
    }
  }
  return _swift(english);
}

/// A phrase's id among the routines: no built-in routine begins `phrase.`.
String tvDhikrPhraseRoutineId(DhikrPreset phrase) => 'phrase.${phrase.id}';

/// What the phrase means, as the television says it: the key of its line in
/// the television's string tables, which carry it in the other languages.
String tvDhikrPhraseMeaning(DhikrPreset phrase) => _voice(phrase.translation);

String _title(DhikrRoutineKind kind) {
  switch (kind) {
    case DhikrRoutineKind.afterSalah:
      return 'After salah';
    case DhikrRoutineKind.morning:
      return 'Morning adhkar';
    case DhikrRoutineKind.evening:
      return 'Evening adhkar';
    case DhikrRoutineKind.sleep:
      return 'Before sleep';
    case DhikrRoutineKind.custom:
      return 'Custom routine';
  }
}

String _subtitle(DhikrRoutine routine) {
  switch (routine.kind) {
    case DhikrRoutineKind.afterSalah:
      return '33 · 33 · 33, then one closing';
    case DhikrRoutineKind.morning:
      return 'After Fajr · ${routine.steps.length} adhkar';
    case DhikrRoutineKind.evening:
      return 'After Asr until Isha · ${routine.steps.length} adhkar';
    case DhikrRoutineKind.sleep:
      return 'After Isha · ${routine.steps.length} adhkar';
    case DhikrRoutineKind.custom:
      return '${routine.steps.length} steps';
  }
}

/// The phone's catalog writes the Name in Arabic script inside its English
/// translations. The television sets English in a face that has no Arabic, so
/// the system substitutes one and the word arrives as a single small glyph.
/// The voice guide's English word is Allah, and that is what the TV shows.
String _english(String value) => value.replaceAll('الله', 'Allah');

/// The phone's words in the television's voice (docs/voice_and_copy_guide.md):
/// Allah in Latin script, the one apostrophe, and ﷺ after the Prophet's name.
String _voice(String value) => _english(value)
    .replaceAll("'", '’')
    .replaceAllMapped(RegExp(r'Muhammad(?! ﷺ)'), (_) => 'Muhammad ﷺ');

String _swift(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', '');
  return '"$escaped"';
}
