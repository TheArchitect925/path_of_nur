import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';
import 'package:path_of_nur/core/theme/occasion_theme.dart';

void main() {
  group('resolveOccasionThemeMode', () {
    final friday = DateTime(2026, 8, 28); // a Friday
    final saturday = DateTime(2026, 8, 29);

    test('wears Jummah on Fridays when dress-up is enabled', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.midnight,
          dressUpFridays: true,
          now: friday,
        ),
        AppThemeMode.jummah,
      );
    });

    test('keeps the base theme on other days', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.midnight,
          dressUpFridays: true,
          now: saturday,
        ),
        AppThemeMode.midnight,
      );
    });

    test('never overrides when dress-up is off', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: false,
          now: friday,
        ),
        AppThemeMode.noorGlass,
      );
    });

    test('manual Jummah selection passes through untouched', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.jummah,
          dressUpFridays: false,
          now: saturday,
        ),
        AppThemeMode.jummah,
      );
    });

    test('wears Layali through Ramadan when dress-up is enabled', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: false,
          dressUpRamadan: true,
          isRamadan: true,
          now: saturday,
        ),
        AppThemeMode.ramadan,
      );
    });

    test('Ramadan outranks Jummah on a Friday in Ramadan', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: true,
          dressUpRamadan: true,
          isRamadan: true,
          now: friday,
        ),
        AppThemeMode.ramadan,
      );
    });

    test('Ramadan dress-up stays quiet outside the month', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: false,
          dressUpRamadan: true,
          isRamadan: false,
          now: saturday,
        ),
        AppThemeMode.noorGlass,
      );
    });

    test('Ramadan window without dress-up keeps the base theme', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.midnight,
          dressUpFridays: false,
          dressUpRamadan: false,
          isRamadan: true,
          now: saturday,
        ),
        AppThemeMode.midnight,
      );
    });

    test('the full ladder: Qadr > Eid > Ramadan > Jummah', () {
      AppThemeMode resolve({
        bool qadr = false,
        bool eid = false,
        bool ramadan = false,
      }) => resolveOccasionThemeMode(
        baseMode: AppThemeMode.noorGlass,
        dressUpFridays: true,
        dressUpRamadan: true,
        isRamadan: ramadan,
        dressUpQadrNights: true,
        isQadrNight: qadr,
        dressUpEid: true,
        isEid: eid,
        now: friday,
      );
      expect(
        resolve(qadr: true, eid: true, ramadan: true),
        AppThemeMode.laylatAlQadr,
      );
      expect(resolve(eid: true, ramadan: true), AppThemeMode.eid);
      expect(resolve(ramadan: true), AppThemeMode.ramadan);
      expect(resolve(), AppThemeMode.jummah);
    });

    test('Qadr and Eid rungs stay quiet without their consent', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: false,
          isQadrNight: true,
          isEid: true,
          now: saturday,
        ),
        AppThemeMode.noorGlass,
      );
    });
  });

  group('Ramadan nights and Qadr windows', () {
    // A 30-day Ramadan: day 1 = March 1, day 30 = March 30.
    const start = '2026-03-01';
    const end = '2026-03-30';

    int? nightAt(DateTime now) =>
        ramadanNightAt(ramadanStartIso: start, ramadanEndIso: end, now: now);

    test('the evening belongs to the coming night', () {
      // Evening of day 26 (March 26) is night 27.
      expect(nightAt(DateTime(2026, 3, 26, 21)), 27);
      // Pre-dawn of day 27 (March 27) is still night 27.
      expect(nightAt(DateTime(2026, 3, 27, 4)), 27);
      // Daytime has no night.
      expect(nightAt(DateTime(2026, 3, 26, 12)), isNull);
      // Outside the month there is no night.
      expect(nightAt(DateTime(2026, 4, 2, 22)), isNull);
    });

    bool qadrAt(DateTime now) => isLaylatAlQadrNightAt(
      ramadanStartIso: start,
      ramadanEndIso: end,
      now: now,
    );

    test('only the odd last-ten nights light up, night hours only', () {
      expect(qadrAt(DateTime(2026, 3, 26, 21)), isTrue); // night 27
      expect(qadrAt(DateTime(2026, 3, 27, 4)), isTrue); // night 27, pre-dawn
      expect(qadrAt(DateTime(2026, 3, 25, 21)), isFalse); // night 26, even
      expect(qadrAt(DateTime(2026, 3, 26, 12)), isFalse); // daytime
      expect(qadrAt(DateTime(2026, 3, 10, 21)), isFalse); // night 11, early
    });
  });

  group('Eid windows', () {
    test('Eid al-Fitr is the three days after the saved Ramadan end', () {
      const end = '2026-03-30';
      expect(
        isEidAlFitrAt(ramadanEndIso: end, now: DateTime(2026, 3, 31, 9)),
        isTrue,
      );
      expect(
        isEidAlFitrAt(ramadanEndIso: end, now: DateTime(2026, 4, 2, 20)),
        isTrue,
      );
      expect(
        isEidAlFitrAt(ramadanEndIso: end, now: DateTime(2026, 3, 30, 9)),
        isFalse,
      );
      expect(
        isEidAlFitrAt(ramadanEndIso: end, now: DateTime(2026, 4, 4, 9)),
        isFalse,
      );
    });

    test('Eid al-Adha lands as a three-day window in late May 2026', () {
      // The tabular hijri calendar puts 10 Dhul-Hijjah 1447 in late May
      // 2026 (sighting can shift it a day). Scan the year: exactly three
      // consecutive days should light up, between May 20 and June 7.
      final days = <DateTime>[];
      for (
        var day = DateTime(2026, 1, 1);
        day.year == 2026;
        day = day.add(const Duration(days: 1))
      ) {
        if (isEidAlAdhaAt(day)) days.add(day);
      }
      expect(days, hasLength(3));
      expect(days.first.isAfter(DateTime(2026, 5, 20)), isTrue);
      expect(days.last.isBefore(DateTime(2026, 6, 7)), isTrue);
      expect(days.last.difference(days.first).inDays, 2);
    });
  });
}
