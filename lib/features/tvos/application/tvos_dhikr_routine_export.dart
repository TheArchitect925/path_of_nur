import '../../worship/domain/dhikr_routine.dart';

/// Renders the phone's built-in dhikr routines as the Swift data file the
/// Apple TV target compiles (`ios/PathOfNurTV/Data/TVDhikrRoutineData.swift`).
/// The TV has no live link to the phone, so it carries a generated copy;
/// `tvos_dhikr_routines_parity_test.dart` keeps the two in step.
String renderTvDhikrRoutinesSwift(List<DhikrRoutine> routines) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE — do not edit by hand.')
    ..writeln(
      '// Source: lib/features/worship/application/dhikr_routine_catalog.dart',
    )
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
        ..writeln('          translation: ${_swift(step.translation)},')
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
    ..writeln('}');
  return buffer.toString();
}

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

String _swift(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', '');
  return '"$escaped"';
}
