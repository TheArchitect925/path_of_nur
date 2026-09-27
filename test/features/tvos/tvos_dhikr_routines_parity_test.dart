import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/dua/data/dua_seed_data.dart';
import 'package:path_of_nur/features/tvos/application/tvos_dhikr_routine_export.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_preset.dart';

/// The Apple TV carries a generated copy of the built-in routines and of the
/// counter's phrases. This test fails when the phone's catalog and the Swift
/// file drift apart; run with `REGENERATE_TV_DHIKR_ROUTINES=1` to rewrite the
/// Swift file.
void main() {
  const path = 'ios/PathOfNurTV/Data/TVDhikrRoutineData.swift';

  String render() => renderTvDhikrRoutinesSwift(
    buildDhikrRoutines(duaSeedDataset),
    phrases: DhikrPreset.defaults,
    phraseTarget: DhikrSessionState.initial().target,
  );

  test('generated TV routine data matches the phone catalog', () {
    final rendered = render();
    final file = File(path);
    if (Platform.environment['REGENERATE_TV_DHIKR_ROUTINES'] == '1') {
      file.writeAsStringSync(rendered);
    }
    expect(file.existsSync(), isTrue, reason: '$path is missing');
    expect(
      file.readAsStringSync(),
      rendered,
      reason:
          'TV routine data is stale. Run REGENERATE_TV_DHIKR_ROUTINES=1 '
          'flutter test ${Platform.script.pathSegments.last}',
    );
  });

  test('rendered Swift carries the four built-in routines and escapes', () {
    final rendered = render();
    expect(rendered, contains('id: "after-salah"'));
    expect(rendered, contains('id: "morning"'));
    expect(rendered, contains('id: "evening"'));
    expect(rendered, contains('id: "sleep"'));
    expect(rendered, contains('kind: "afterSalah"'));
    expect(rendered, contains('count: 33'));
    expect(rendered, isNot(contains('\n"')));
    expect('"'.allMatches(rendered).length.isEven, isTrue);
  });

  test('rendered Swift carries every phrase of the phone\'s counter', () {
    final rendered = render();
    final phrases = rendered.substring(rendered.indexOf('static let phrases'));
    expect(DhikrPreset.defaults, isNotEmpty);
    for (final phrase in DhikrPreset.defaults) {
      expect(phrases, contains('id: "${tvDhikrPhraseRoutineId(phrase)}"'));
      expect(phrases, contains('arabic: "${phrase.phrase}"'));
      expect(
        phrases,
        contains('translation: tvLocalized("${tvDhikrPhraseMeaning(phrase)}")'),
      );
    }
    expect(
      'kind: "phrase"'.allMatches(phrases).length,
      DhikrPreset.defaults.length,
    );
    // Said to the count the phone's counter begins at.
    expect(
      'count: ${DhikrSessionState.initial().target}'.allMatches(phrases).length,
      DhikrPreset.defaults.length,
    );
    // In the television's voice.
    expect(phrases, isNot(contains('الله"),')));
    expect(phrases, isNot(contains("'")));
    expect(phrases, contains('Muhammad ﷺ'));
  });

  test('every phrase has its meaning in the television\'s other languages', () {
    for (final locale in const ['de', 'ar', 'ur', 'fr']) {
      final table = File(
        'ios/PathOfNurTV/$locale.lproj/Localizable.strings',
      ).readAsStringSync();
      for (final phrase in DhikrPreset.defaults) {
        final key = tvDhikrPhraseMeaning(phrase);
        final entry = RegExp(
          '^"${RegExp.escape(key)}" = "(.+)";\$',
          multiLine: true,
        ).firstMatch(table);
        expect(entry, isNotNull, reason: '$locale has no line for "$key"');
        expect(
          entry!.group(1),
          isNot(key),
          reason: '$locale says "$key" in English',
        );
      }
    }
  });
}
