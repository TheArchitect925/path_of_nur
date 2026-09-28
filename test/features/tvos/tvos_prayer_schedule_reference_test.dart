import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/prayer/prayer_preferences.dart';

/// The Apple TV lays the day's prayers out with a Swift port of the phone's
/// schedule (`TVPrayerSchedule`), and `scripts/verify_tv_prayer_times.sh`
/// holds that port to `tools/tv_prayer_schedule_reference.json`: the six
/// windows of a day, and which prayer it is time for at moments through it.
///
/// This test holds the reference itself to the phone. Run with
/// `REGENERATE_TV_PRAYER_SCHEDULE=1` to rewrite it.
///
/// Every time in it is a moment and not a clock time, so it reads the same
/// whatever time zone the machine keeps. The days chosen are days on which no
/// clock changes: the prayer library rounds in the machine's own clock.
void main() {
  const path = 'tools/tv_prayer_schedule_reference.json';

  test('the Apple TV prayer schedule reference is what the phone answers', () {
    final rendered = renderTvPrayerScheduleReference();
    final file = File(path);
    if (Platform.environment['REGENERATE_TV_PRAYER_SCHEDULE'] == '1') {
      file.writeAsStringSync(rendered);
    }
    expect(file.existsSync(), isTrue, reason: '$path is missing');
    expect(
      file.readAsStringSync() == rendered,
      isTrue,
      reason:
          '$path is stale. Run REGENERATE_TV_PRAYER_SCHEDULE=1 flutter test '
          'test/features/tvos/tvos_prayer_schedule_reference_test.dart, then '
          'bash scripts/verify_tv_prayer_times.sh',
    );
  });
}

const _places = <String, List<double>>{
  'Toronto': [43.6532, -79.3832],
  'Makkah': [21.4225, 39.8262],
  'Jakarta': [-6.2088, 106.8456],
  'Stockholm': [59.3293, 18.0686],
  'Cape Town': [-33.9249, 18.4241],
};

const _dates = <List<int>>[
  [2026, 1, 14],
  [2026, 4, 22],
  [2026, 6, 17],
  [2026, 9, 23],
  [2026, 12, 16],
];

int _seconds(DateTime moment) => moment.millisecondsSinceEpoch ~/ 1000;

String renderTvPrayerScheduleReference() {
  const settings = PrayerPreferences(
    location: 'reference',
    madhab: PrayerMadhab.shafii,
    calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
  );
  final buffer = StringBuffer('{\n')
    ..writeln(
      '  "source": "buildCalculatedPrayerScheduleForDate and derivePrayerScheduleContext, lib/core/prayer/prayer_preferences.dart",',
    )
    ..writeln('  "method": "MWL",')
    ..writeln('  "asr": "standard",')
    ..writeln('  "cases": [');
  final cases = <String>[];
  for (final place in _places.entries) {
    for (final date in _dates) {
      final schedule = buildCalculatedPrayerScheduleForDate(
        date: DateTime(date[0], date[1], date[2]),
        latitude: place.value[0],
        longitude: place.value[1],
        settings: settings,
      );
      final windows = [
        for (final item in schedule)
          '["${item.id}", ${_seconds(item.windowStartDateTime)}, ${_seconds(item.windowEndDateTime)}]',
      ];
      // Before the day's first prayer, at the edges of each window and in
      // its middle, and after the last.
      final moments = <DateTime>[
        schedule.first.windowStartDateTime.subtract(const Duration(hours: 2)),
        for (final item in schedule) ...[
          item.windowStartDateTime.subtract(const Duration(minutes: 1)),
          item.windowStartDateTime,
          item.windowStartDateTime.add(
            Duration(
              seconds:
                  item.windowEndDateTime
                      .difference(item.windowStartDateTime)
                      .inSeconds ~/
                  2,
            ),
          ),
          item.windowEndDateTime,
        ],
        schedule.last.windowEndDateTime.add(const Duration(minutes: 30)),
      ];
      final contexts = [
        for (final moment in moments)
          () {
            final context = derivePrayerScheduleContext(
              schedule: schedule,
              now: moment,
            );
            final current = context.currentPrayerId == null
                ? 'null'
                : '"${context.currentPrayerId}"';
            final nextStart = moment.add(context.remainingToNext);
            return '[${_seconds(moment)}, $current, "${context.nextPrayerId}", ${_seconds(nextStart)}]';
          }(),
      ];
      cases.add(
        '    {\n'
        '      "place": "${place.key}",\n'
        '      "coordinates": [${place.value[0]}, ${place.value[1]}],\n'
        '      "date": [${date[0]}, ${date[1]}, ${date[2]}],\n'
        '      "windows": [${windows.join(', ')}],\n'
        '      "moments": [${contexts.join(', ')}]\n'
        '    }',
      );
    }
  }
  buffer
    ..writeln(cases.join(',\n'))
    ..writeln('  ]')
    ..writeln('}');
  return buffer.toString();
}
