import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/living_atmosphere.dart';

/// The Apple TV turns its sky with a Swift port of the phone's
/// `noorSkyPhaseAt` (`TVSkyPhase.at`), and
/// `scripts/verify_tv_prayer_times.sh` holds that port to
/// `tools/tv_sky_phase_reference.json`: the sky at every five minutes of a
/// day, for a summer day and a winter one.
///
/// This test holds the reference itself to the phone. Run with
/// `REGENERATE_TV_SKY_PHASE=1` to rewrite it. Every time in it is a moment
/// and not a clock time, so it reads the same in any time zone.
void main() {
  const path = 'tools/tv_sky_phase_reference.json';

  test('the Apple TV sky reference is what the phone answers', () {
    final rendered = renderTvSkyPhaseReference();
    final file = File(path);
    if (Platform.environment['REGENERATE_TV_SKY_PHASE'] == '1') {
      file.writeAsStringSync(rendered);
    }
    expect(file.existsSync(), isTrue, reason: '$path is missing');
    expect(
      file.readAsStringSync() == rendered,
      isTrue,
      reason:
          '$path is stale. Run REGENERATE_TV_SKY_PHASE=1 flutter test '
          'test/features/tvos/tvos_sky_phase_reference_test.dart, then '
          'bash scripts/verify_tv_prayer_times.sh',
    );
  });
}

int _seconds(DateTime moment) => moment.millisecondsSinceEpoch ~/ 1000;

String renderTvSkyPhaseReference() {
  // Fajr, Maghrib and Isha of a long day and of a short one.
  final days = <List<DateTime>>[
    [
      DateTime.utc(2026, 6, 21, 7, 35),
      DateTime.utc(2026, 6, 22, 1, 3),
      DateTime.utc(2026, 6, 22, 3, 5),
    ],
    [
      DateTime.utc(2026, 12, 21, 11, 10),
      DateTime.utc(2026, 12, 21, 21, 44),
      DateTime.utc(2026, 12, 21, 23, 21),
    ],
  ];
  final cases = <String>[];
  for (final day in days) {
    final from = day[0].subtract(const Duration(hours: 3));
    final moments = <String>[];
    for (var minutes = 0; minutes <= 26 * 60; minutes += 5) {
      final now = from.add(Duration(minutes: minutes));
      final phase = noorSkyPhaseAt(
        now: now,
        fajrStart: day[0],
        maghribStart: day[1],
        ishaStart: day[2],
      );
      moments.add('[${_seconds(now)}, "${phase.name}"]');
    }
    cases.add(
      '    {\n'
      '      "fajr": ${_seconds(day[0])},\n'
      '      "maghrib": ${_seconds(day[1])},\n'
      '      "isha": ${_seconds(day[2])},\n'
      '      "moments": [${moments.join(', ')}]\n'
      '    }',
    );
  }
  return '{\n'
      '  "source": "noorSkyPhaseAt, lib/core/theme/living_atmosphere.dart",\n'
      '  "cases": [\n'
      '${cases.join(',\n')}\n'
      '  ]\n'
      '}\n';
}
