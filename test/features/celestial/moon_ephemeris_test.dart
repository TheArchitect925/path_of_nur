import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/celestial/application/celestial_services.dart';
import 'package:path_of_nur/features/celestial/data/celestial_verse_catalog.dart';
import 'package:path_of_nur/features/celestial/domain/celestial_models.dart';
import 'package:path_of_nur/features/celestial/domain/moon_ephemeris.dart';

// Reference times come from PyEphem 4.2 (upper limb on the horizon, with
// refraction). The windows are given in UTC so the checks hold in any
// time zone the tests run in.
void main() {
  const moon = MoonEphemeris();
  const toronto = (latitude: 43.6532, longitude: -79.3832);
  const tromso = (latitude: 69.6492, longitude: 18.9553);

  Matcher within2Minutes(String isoUtc) {
    final expected = DateTime.parse(isoUtc);
    return predicate<DateTime?>(
      (actual) =>
          actual != null && actual.difference(expected).inSeconds.abs() <= 120,
      'within two minutes of $isoUtc',
    );
  }

  MoonHorizonEvents eventsIn(
    ({double latitude, double longitude}) place,
    String fromUtc,
    String toUtc,
  ) {
    return moon.eventsBetween(
      from: DateTime.parse(fromUtc),
      to: DateTime.parse(toUtc),
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }

  test('Toronto, 27 September 2026: the day after the Harvest Moon', () {
    final events = eventsIn(
      toronto,
      '2026-09-27T04:00:00Z',
      '2026-09-28T04:00:00Z',
    );
    // 7:15 pm and 8:15 am EDT. The old estimate put the rise at about 8 pm.
    expect(events.rise, within2Minutes('2026-09-27T23:15:50Z'));
    expect(events.set, within2Minutes('2026-09-27T12:15:39Z'));
  });

  test('a day with no moonrise has a null rise and still sets', () {
    final events = eventsIn(
      toronto,
      '2026-10-03T04:00:00Z',
      '2026-10-04T04:00:00Z',
    );
    expect(events.rise, isNull);
    expect(events.set, within2Minutes('2026-10-03T19:21:37Z'));
  });

  test('southern and tropical skies', () {
    final sydney = eventsIn(
      (latitude: -33.8688, longitude: 151.2093),
      '2026-03-14T13:00:00Z',
      '2026-03-15T13:00:00Z',
    );
    expect(sydney.rise, within2Minutes('2026-03-14T15:31:29Z'));
    expect(sydney.set, within2Minutes('2026-03-15T06:06:47Z'));

    final makkah = eventsIn(
      (latitude: 21.4225, longitude: 39.8262),
      '2026-02-17T21:00:00Z',
      '2026-02-18T21:00:00Z',
    );
    expect(makkah.rise, within2Minutes('2026-02-18T04:20:25Z'));
    expect(makkah.set, within2Minutes('2026-02-18T16:19:09Z'));
  });

  test('above the Arctic Circle the moon can stay up, or stay down', () {
    final alwaysUp = eventsIn(
      tromso,
      '2026-01-01T00:00:00Z',
      '2026-01-02T00:00:00Z',
    );
    expect(alwaysUp.rise, isNull);
    expect(alwaysUp.set, isNull);
    expect(
      moon
          .positionAt(
            DateTime.utc(2026, 1, 1, 12),
            latitude: tromso.latitude,
            longitude: tromso.longitude,
          )
          .isAboveHorizon,
      isTrue,
    );

    final neverUp = eventsIn(
      tromso,
      '2026-01-13T00:00:00Z',
      '2026-01-14T00:00:00Z',
    );
    expect(neverUp.rise, isNull);
    expect(neverUp.set, isNull);
    expect(
      moon
          .positionAt(
            DateTime.utc(2026, 1, 13, 12),
            latitude: tromso.latitude,
            longitude: tromso.longitude,
          )
          .isAboveHorizon,
      isFalse,
    );
  });

  test('position matches the ephemeris to a few arc-minutes', () {
    final position = moon.positionAt(
      DateTime.utc(2026, 9, 28, 3),
      latitude: toronto.latitude,
      longitude: toronto.longitude,
    );
    expect(position.azimuthDegrees, closeTo(112.317, 0.05));
    expect(position.altitudeDegrees, closeTo(38.423, 0.05));
    expect(position.isAboveHorizon, isTrue);
  });

  test('the phase follows the real moon, not a mean month', () {
    // Full at 16:49 UTC on 26 September 2026, last quarter at 13:25 on
    // 3 October, new at 15:50 on 10 October.
    final full = moon.phaseAt(DateTime.utc(2026, 9, 26, 16, 49));
    expect(full.cycleFraction, closeTo(0.5, 0.001));
    expect(full.illuminationPercent, 100);
    expect(full.phase, MoonPhase.fullMoon);

    final tonight = moon.phaseAt(DateTime.utc(2026, 9, 27, 23, 16));
    expect(tonight.illuminatedFraction, closeTo(0.9791, 0.005));
    expect(tonight.phase, MoonPhase.fullMoon);

    final lastQuarter = moon.phaseAt(DateTime.utc(2026, 10, 3, 13, 25));
    expect(lastQuarter.cycleFraction, closeTo(0.75, 0.001));
    expect(lastQuarter.illuminationPercent, closeTo(50, 1));
    expect(lastQuarter.phase, MoonPhase.lastQuarter);

    final newMoon = moon.phaseAt(DateTime.utc(2026, 10, 10, 15, 50));
    expect(newMoon.illuminationPercent, 0);
    expect(newMoon.phase, MoonPhase.newMoon);

    final crescent = moon.phaseAt(DateTime.utc(2026, 10, 14, 12));
    expect(crescent.illuminatedFraction, closeTo(0.1457, 0.005));
    expect(crescent.phase, MoonPhase.waxingCrescent);
  });

  test('the snapshot tells of the real moonrise, not an estimate', () {
    final snapshot = const CelestialCalculationService().buildSnapshot(
      // 7:10 pm EDT: after sunset, five minutes before the moon comes up.
      timestamp: DateTime.utc(2026, 9, 27, 23, 10).toLocal(),
      latitude: toronto.latitude,
      longitude: toronto.longitude,
      locationLabel: 'Toronto',
      timezoneLabel: 'EDT',
      verseSelector: const CelestialVerseSelector(celestialVerseCatalog),
    );
    expect(snapshot.lunarData.riseSetApproximate, isFalse);
    expect(snapshot.lunarData.isAboveHorizon, isFalse);
    expect(snapshot.nextEvent.type, CelestialEventType.moonrise);
    expect(snapshot.nextEvent.time, within2Minutes('2026-09-27T23:15:50Z'));
  });
}
