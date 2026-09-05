import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/prayer/prayer_preferences.dart';

void main() {
  final friday = DateTime(2026, 8, 28);

  group('jumuahLeaveTimeFor', () {
    test('returns null when the reminder is off', () {
      expect(
        jumuahLeaveTimeFor(
          day: friday,
          preferences: const PrayerPreferences(
            location: 'Toronto',
            madhab: PrayerMadhab.hanafi,
            calculationMethod: PrayerCalculationMethod.isna,
            useDeviceLocation: false,
          ),
        ),
        isNull,
      );
    });

    test('uses fixed travel minutes against the default khutbah time', () {
      final leave = jumuahLeaveTimeFor(
        day: friday,
        preferences: const PrayerPreferences(
          location: 'Toronto',
          madhab: PrayerMadhab.hanafi,
          calculationMethod: PrayerCalculationMethod.isna,
          useDeviceLocation: false,
          jumuahLeaveReminderMode: JumuahLeaveReminderMode.fixedTravelTime,
          jumuahTravelMinutes: 20,
        ),
      );
      // 13:30 khutbah - 20 travel - 5 buffer = 13:05.
      expect(leave, DateTime(2026, 8, 28, 13, 5));
    });

    test('honors the custom masjid time', () {
      final leave = jumuahLeaveTimeFor(
        day: friday,
        preferences: const PrayerPreferences(
          location: 'Toronto',
          madhab: PrayerMadhab.hanafi,
          calculationMethod: PrayerCalculationMethod.isna,
          useDeviceLocation: false,
          jumuahOverrideEnabled: true,
          jumuahTimeMinutes: 14 * 60, // 2:00 PM khutbah
          jumuahLeaveReminderMode: JumuahLeaveReminderMode.fixedTravelTime,
          jumuahTravelMinutes: 10,
        ),
      );
      expect(leave, DateTime(2026, 8, 28, 13, 45));
    });

    test('prefers the location estimate and falls back to fixed', () {
      const preferences = PrayerPreferences(
        location: 'Toronto',
        madhab: PrayerMadhab.hanafi,
        calculationMethod: PrayerCalculationMethod.isna,
        useDeviceLocation: false,
        jumuahLeaveReminderMode: JumuahLeaveReminderMode.locationEstimate,
        jumuahTravelMinutes: 20,
      );
      expect(
        jumuahLeaveTimeFor(
          day: friday,
          preferences: preferences,
          estimatedTravelMinutes: 42,
        ),
        DateTime(2026, 8, 28, 12, 43),
      );
      expect(
        jumuahLeaveTimeFor(day: friday, preferences: preferences),
        DateTime(2026, 8, 28, 13, 5),
      );
    });
  });
}
