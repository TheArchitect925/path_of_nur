// What the phone's prayer library answers, written down for the television.
//
//   TZ=UTC dart run tools/tv_prayer_reference.dart            # print
//   TZ=UTC dart run tools/tv_prayer_reference.dart --write    # the .json
//
// Run it in UTC. The package rounds each time in the clock of the machine it
// runs on, and on the day that clock changes an hour is said twice: a time
// that falls in it comes back an hour out. That is the machine's time zone
// speaking, not the sun, so the reference is taken where no clock changes.
//
// The Apple TV app calculates prayer times with a Swift port of the `adhan`
// package (ios/PathOfNurTV/Data/TVPrayerCalculator.swift). This script asks the
// package itself, for places from the equator to the edge of the polar day,
// through a year and a leap day, under every method and both Asr rules the
// phone offers. tooling/scripts/verify_tv_prayer_times.swift holds the port to
// these answers, to the minute.
import 'dart:convert';
import 'dart:io';

import 'package:adhan/adhan.dart';

const places = <String, List<double>>{
  'Toronto': [43.6532, -79.3832],
  'Dubai': [25.2048, 55.2708],
  'London': [51.5072, -0.1276],
  'Istanbul': [41.0082, 28.9784],
  'Riyadh': [24.7136, 46.6753],
  'Makkah': [21.4225, 39.8262],
  'Jakarta': [-6.2088, 106.8456],
  'Nairobi': [-1.2921, 36.8219],
  'Sydney': [-33.8688, 151.2093],
  'Cape Town': [-33.9249, 18.4241],
  'Los Angeles': [34.0522, -118.2437],
  'Stockholm': [59.3293, 18.0686],
  'Reykjavik': [64.1466, -21.9426],
  'Suva': [-18.1248, 178.4501],
};

const methods = <String, CalculationMethod>{
  'MWL': CalculationMethod.muslim_world_league,
  'EGY': CalculationMethod.egyptian,
  'ISNA': CalculationMethod.north_america,
  'KAR': CalculationMethod.karachi,
  'QUR': CalculationMethod.umm_al_qura,
};

const asrRules = <String, Madhab>{
  'standard': Madhab.shafi,
  'hanafi': Madhab.hanafi,
};

List<List<int>> dates() {
  final result = <List<int>>[];
  for (var month = 1; month <= 12; month++) {
    result.add([2026, month, 1]);
    result.add([2026, month, 15]);
  }
  // The solstices, the equinoxes, a leap day and both ends of a year.
  result.addAll([
    [2026, 3, 20],
    [2026, 6, 21],
    [2026, 9, 23],
    [2026, 12, 21],
    [2026, 12, 31],
    [2027, 1, 1],
    [2028, 2, 29],
  ]);
  return result;
}

/// Minutes since the epoch: every answer is a whole minute.
int minutes(DateTime value) => value.toUtc().millisecondsSinceEpoch ~/ 60000;

void main(List<String> arguments) {
  if (DateTime(2026, 1, 1).timeZoneOffset != Duration.zero ||
      DateTime(2026, 7, 1).timeZoneOffset != Duration.zero) {
    stderr.writeln(
      'Run in UTC: TZ=UTC dart run tools/tv_prayer_reference.dart',
    );
    exit(64);
  }
  final lines = <String>[];
  for (final place in places.entries) {
    final coordinates = Coordinates(place.value[0], place.value[1]);
    for (final date in dates()) {
      for (final method in methods.entries) {
        for (final asr in asrRules.entries) {
          final parameters = method.value.getParameters()..madhab = asr.value;
          List<int>? times;
          try {
            final day = PrayerTimes.utc(
              coordinates,
              DateComponents(date[0], date[1], date[2]),
              parameters,
            );
            times = [
              minutes(day.fajr),
              minutes(day.sunrise),
              minutes(day.dhuhr),
              minutes(day.asr),
              minutes(day.maghrib),
              minutes(day.isha),
            ];
          } on ArgumentError {
            // The sun does not rise or set there that day.
            times = null;
          }
          lines.add(jsonEncode([place.key, date, method.key, asr.key, times]));
        }
      }
    }
  }

  // One case to a line, so a change in the package shows as the lines it moved.
  final text =
      '{\n'
      ' "package": "adhan 2.0.0+1",\n'
      ' "order": ["fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha"],\n'
      ' "places": ${jsonEncode(places)},\n'
      ' "cases": [\n  ${lines.join(',\n  ')}\n ]\n'
      '}\n';
  if (arguments.contains('--write')) {
    File('tools/tv_prayer_reference.json').writeAsStringSync(text);
    stdout.writeln('${lines.length} cases written');
  } else {
    stdout.write(text);
  }
}
