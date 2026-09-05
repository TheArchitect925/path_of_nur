import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/dua/data/dua_seed_data.dart';
import 'package:path_of_nur/features/tvos/application/tvos_dhikr_routine_export.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';

/// The Apple TV carries a generated copy of the built-in routines. This test
/// fails when the phone's catalog and the Swift file drift apart; run with
/// `REGENERATE_TV_DHIKR_ROUTINES=1` to rewrite the Swift file.
void main() {
  const path = 'ios/PathOfNurTV/Data/TVDhikrRoutineData.swift';

  test('generated TV routine data matches the phone catalog', () {
    final rendered = renderTvDhikrRoutinesSwift(
      buildDhikrRoutines(duaSeedDataset),
    );
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
    final rendered = renderTvDhikrRoutinesSwift(
      buildDhikrRoutines(duaSeedDataset),
    );
    expect(rendered, contains('id: "after-salah"'));
    expect(rendered, contains('id: "morning"'));
    expect(rendered, contains('id: "evening"'));
    expect(rendered, contains('id: "sleep"'));
    expect(rendered, contains('kind: "afterSalah"'));
    expect(rendered, contains('count: 33'));
    expect(rendered, isNot(contains('\n"')));
    expect('"'.allMatches(rendered).length.isEven, isTrue);
  });
}
