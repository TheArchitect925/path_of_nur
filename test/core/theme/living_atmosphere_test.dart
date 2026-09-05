import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';
import 'package:path_of_nur/core/theme/living_atmosphere.dart';

void main() {
  group('noorSkyPhaseAt with a prayer clock', () {
    final fajr = DateTime(2026, 8, 28, 5, 30);
    final maghrib = DateTime(2026, 8, 28, 20, 0);
    final isha = DateTime(2026, 8, 28, 21, 30);

    NoorSkyPhase at(DateTime now) => noorSkyPhaseAt(
      now: now,
      fajrStart: fajr,
      maghribStart: maghrib,
      ishaStart: isha,
    );

    test('night runs from Isha until Fajr', () {
      expect(at(DateTime(2026, 8, 28, 2, 0)), NoorSkyPhase.night);
      expect(at(DateTime(2026, 8, 28, 21, 30)), NoorSkyPhase.night);
      expect(at(DateTime(2026, 8, 28, 23, 45)), NoorSkyPhase.night);
    });

    test('dawn is the ninety minutes from Fajr', () {
      expect(at(DateTime(2026, 8, 28, 5, 30)), NoorSkyPhase.dawn);
      expect(at(DateTime(2026, 8, 28, 6, 45)), NoorSkyPhase.dawn);
      expect(at(DateTime(2026, 8, 28, 7, 0)), NoorSkyPhase.day);
    });

    test('amber begins shortly before Maghrib and holds until Isha', () {
      expect(at(DateTime(2026, 8, 28, 19, 15)), NoorSkyPhase.maghrib);
      expect(at(DateTime(2026, 8, 28, 20, 30)), NoorSkyPhase.maghrib);
      expect(at(DateTime(2026, 8, 28, 19, 0)), NoorSkyPhase.day);
      expect(at(DateTime(2026, 8, 28, 12, 0)), NoorSkyPhase.day);
    });
  });

  group('noorSkyPhaseAt hour fallback', () {
    NoorSkyPhase at(int hour, [int minute = 0]) =>
        noorSkyPhaseAt(now: DateTime(2026, 8, 28, hour, minute));

    test('buckets the day without a schedule', () {
      expect(at(23), NoorSkyPhase.night);
      expect(at(4), NoorSkyPhase.night);
      expect(at(6), NoorSkyPhase.dawn);
      expect(at(12), NoorSkyPhase.day);
      expect(at(18), NoorSkyPhase.maghrib);
      expect(at(21), NoorSkyPhase.night);
    });
  });

  group('resolveLivingAtmosphereMode', () {
    test('Noor Glass becomes Midnight after dark', () {
      expect(
        resolveLivingAtmosphereMode(
          mode: AppThemeMode.noorGlass,
          livingAtmosphere: true,
          phase: NoorSkyPhase.night,
        ),
        AppThemeMode.midnight,
      );
    });

    test('daytime phases leave Noor Glass alone', () {
      for (final phase in [
        NoorSkyPhase.dawn,
        NoorSkyPhase.day,
        NoorSkyPhase.maghrib,
      ]) {
        expect(
          resolveLivingAtmosphereMode(
            mode: AppThemeMode.noorGlass,
            livingAtmosphere: true,
            phase: phase,
          ),
          AppThemeMode.noorGlass,
        );
      }
    });

    test('the toggle and other themes are respected', () {
      expect(
        resolveLivingAtmosphereMode(
          mode: AppThemeMode.noorGlass,
          livingAtmosphere: false,
          phase: NoorSkyPhase.night,
        ),
        AppThemeMode.noorGlass,
      );
      expect(
        resolveLivingAtmosphereMode(
          mode: AppThemeMode.jummah,
          livingAtmosphere: true,
          phase: NoorSkyPhase.night,
        ),
        AppThemeMode.jummah,
      );
    });
  });
}
