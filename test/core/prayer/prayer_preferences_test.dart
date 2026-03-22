import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/prayer/prayer_preferences.dart';

void main() {
  const settings = PrayerPreferences(
    location: 'Toronto',
    madhab: PrayerMadhab.shafii,
    calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
  );

  test('Friday Dhuhr slot presents Jumu‘ah at 1:30 PM', () {
    final schedule = buildPrayerScheduleForDate(
      date: DateTime(2026, 3, 20),
      latitude: 43.6532,
      longitude: -79.3832,
      settings: settings,
    );

    final dhuhr = schedule.firstWhere((item) => item.id == 'dhuhr');

    expect(dhuhr.offerDateTime.weekday, DateTime.friday);
    expect(dhuhr.offerDateTime.hour, 13);
    expect(dhuhr.offerDateTime.minute, 30);
    expect(dhuhr.totalRakats, 2);
  });

  test('non-Friday Dhuhr timing remains schedule-driven', () {
    final schedule = buildPrayerScheduleForDate(
      date: DateTime(2026, 3, 21),
      latitude: 43.6532,
      longitude: -79.3832,
      settings: settings,
    );

    final dhuhr = schedule.firstWhere((item) => item.id == 'dhuhr');

    expect(dhuhr.offerDateTime.weekday, isNot(DateTime.friday));
    expect(
      dhuhr.offerDateTime.hour == 13 && dhuhr.offerDateTime.minute == 30,
      isFalse,
    );
    expect(dhuhr.totalRakats, 4);
  });
}
