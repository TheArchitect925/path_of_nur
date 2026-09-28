import 'dart:math' as math;

/// Where the moon stands in the sky, and when it crosses the horizon.
///
/// The position follows Meeus, *Astronomical Algorithms* (2nd ed.),
/// chapter 47, with the full tables of periodic terms: good to about ten
/// arc-seconds, which puts a rise or a set within a minute of the almanac.
class MoonEphemeris {
  const MoonEphemeris();

  /// TT − UT for the years around now. Its drift of a second or two a year
  /// moves the moon by under an arc-second.
  static const double _deltaTSeconds = 69;
  static const Duration _searchStep = Duration(minutes: 10);

  /// The first rise and the first set on the calendar day of [day], in the
  /// device's time zone. Once a month each of them has a day with none.
  MoonHorizonEvents eventsOnDay({
    required DateTime day,
    required double latitude,
    required double longitude,
  }) {
    return eventsBetween(
      from: DateTime(day.year, day.month, day.day),
      to: DateTime(day.year, day.month, day.day + 1),
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// The first rise and the first set in `[from, to)`, as local times
  /// rounded to the minute.
  MoonHorizonEvents eventsBetween({
    required DateTime from,
    required DateTime to,
    required double latitude,
    required double longitude,
  }) {
    final end = to.toUtc();
    double heightAt(DateTime instant) =>
        _heightAboveRiseLine(instant, latitude, longitude);

    DateTime? rise;
    DateTime? set;
    var t0 = from.toUtc();
    var h0 = heightAt(t0);
    while (t0.isBefore(end) && (rise == null || set == null)) {
      final next = t0.add(_searchStep);
      final t1 = next.isAfter(end) ? end : next;
      final h1 = heightAt(t1);
      if (rise == null && h0 < 0 && h1 >= 0) {
        rise = _crossing(t0, t1, heightAt, end);
      } else if (set == null && h0 >= 0 && h1 < 0) {
        set = _crossing(t0, t1, heightAt, end);
      }
      t0 = t1;
      h0 = h1;
    }
    return MoonHorizonEvents(rise: rise?.toLocal(), set: set?.toLocal());
  }

  /// The moon's direction from the observer at [instant].
  MoonSkyPosition positionAt(
    DateTime instant, {
    required double latitude,
    required double longitude,
  }) {
    final place = _horizontal(instant, latitude, longitude);
    // Seen from the ground rather than the earth's centre, the moon sits
    // lower by nearly its parallax: close to a degree at the horizon.
    final altitude =
        place.altitude - place.parallax * math.cos(place.altitude * _rad);
    return MoonSkyPosition(
      azimuthDegrees: place.azimuth,
      altitudeDegrees: altitude,
      isAboveHorizon: place.altitude >= _riseLine(place.parallax),
    );
  }

  /// How far through its month the moon is at [instant], and how much of
  /// its face is lit (Meeus, chapter 48). The same everywhere on earth.
  MoonPhaseReading phaseAt(DateTime instant) {
    final moon = _ecliptic(instant);
    final sun = _sun(instant);
    final apart = _norm(moon.longitude - sun.longitude);
    final elongation = math.acos(
      math.cos(moon.latitude * _rad) * math.cos(apart * _rad),
    );
    final phaseAngle = math.atan2(
      sun.distanceKm * math.sin(elongation),
      moon.distanceKm - sun.distanceKm * math.cos(elongation),
    );
    return MoonPhaseReading(
      cycleFraction: apart / 360,
      illuminatedFraction: (1 + math.cos(phaseAngle)) / 2,
    );
  }

  /// Bisects a horizon crossing inside `[a, b]` to the second, then rounds
  /// it to the minute unless that would push it past [end].
  static DateTime _crossing(
    DateTime a,
    DateTime b,
    double Function(DateTime) heightAt,
    DateTime end,
  ) {
    var lo = a;
    var hi = b;
    final loAbove = heightAt(lo) >= 0;
    while (hi.difference(lo) > const Duration(seconds: 1)) {
      final mid = lo.add(hi.difference(lo) ~/ 2);
      if ((heightAt(mid) >= 0) == loAbove) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final rounded = DateTime.fromMillisecondsSinceEpoch(
      (hi.millisecondsSinceEpoch / Duration.millisecondsPerMinute).round() *
          Duration.millisecondsPerMinute,
      isUtc: true,
    );
    return rounded.isBefore(end) ? rounded : hi;
  }

  /// Degrees the moon's centre stands above the altitude at which its upper
  /// limb touches the horizon, refraction included (Meeus, chapter 15).
  static double _heightAboveRiseLine(
    DateTime instant,
    double latitude,
    double longitude,
  ) {
    final place = _horizontal(instant, latitude, longitude);
    return place.altitude - _riseLine(place.parallax);
  }

  static double _riseLine(double parallax) => 0.7275 * parallax - 0.5667;

  static ({double altitude, double azimuth, double parallax}) _horizontal(
    DateTime instant,
    double latitude,
    double longitude,
  ) {
    final moon = _ecliptic(instant);
    final lambda = moon.longitude * _rad;
    final beta = moon.latitude * _rad;
    final epsilon = moon.obliquity * _rad;
    final rightAscension = math.atan2(
      math.sin(lambda) * math.cos(epsilon) - math.tan(beta) * math.sin(epsilon),
      math.cos(lambda),
    );
    final declination = math.asin(
      math.sin(beta) * math.cos(epsilon) +
          math.cos(beta) * math.sin(epsilon) * math.sin(lambda),
    );

    // Apparent sidereal time at Greenwich (Meeus, chapter 12), then here.
    final jdUt = _julianDay(instant);
    final tUt = (jdUt - 2451545) / 36525;
    final siderealTime = _norm(
      280.46061837 +
          360.98564736629 * (jdUt - 2451545) +
          0.000387933 * tUt * tUt -
          tUt * tUt * tUt / 38710000 +
          moon.nutationLongitude * math.cos(epsilon),
    );
    final hourAngle = (siderealTime + longitude) * _rad - rightAscension;
    final phi = latitude * _rad;
    final altitude = math.asin(
      math.sin(phi) * math.sin(declination) +
          math.cos(phi) * math.cos(declination) * math.cos(hourAngle),
    );
    final azimuthFromSouth = math.atan2(
      math.sin(hourAngle),
      math.cos(hourAngle) * math.sin(phi) -
          math.tan(declination) * math.cos(phi),
    );
    return (
      altitude: altitude / _rad,
      azimuth: _norm(azimuthFromSouth / _rad + 180),
      parallax: math.asin(6378.14 / moon.distanceKm) / _rad,
    );
  }

  /// Centuries of Terrestrial Time since J2000.0.
  static double _centuries(DateTime instant) =>
      (_julianDay(instant) + _deltaTSeconds / 86400 - 2451545) / 36525;

  static double _julianDay(DateTime instant) =>
      instant.toUtc().millisecondsSinceEpoch / Duration.millisecondsPerDay +
      2440587.5;

  /// The moon's apparent ecliptic place and distance (Meeus, chapter 47),
  /// with the nutation and obliquity the conversions after it need.
  static ({
    double longitude,
    double latitude,
    double distanceKm,
    double nutationLongitude,
    double obliquity,
  })
  _ecliptic(DateTime instant) {
    final t = _centuries(instant);
    final t2 = t * t;
    final t3 = t2 * t;
    final t4 = t3 * t;

    final meanLongitude = _norm(
      218.3164477 +
          481267.88123421 * t -
          0.0015786 * t2 +
          t3 / 538841 -
          t4 / 65194000,
    );
    final elongation = _norm(
      297.8501921 +
          445267.1114034 * t -
          0.0018819 * t2 +
          t3 / 545868 -
          t4 / 113065000,
    );
    final sunAnomaly = _norm(
      357.5291092 + 35999.0502909 * t - 0.0001536 * t2 + t3 / 24490000,
    );
    final moonAnomaly = _norm(
      134.9633964 +
          477198.8675055 * t +
          0.0087414 * t2 +
          t3 / 69699 -
          t4 / 14712000,
    );
    final latitudeArgument = _norm(
      93.2720950 +
          483202.0175233 * t -
          0.0036539 * t2 -
          t3 / 3526000 +
          t4 / 863310000,
    );
    final a1 = _norm(119.75 + 131.849 * t);
    final a2 = _norm(53.09 + 479264.290 * t);
    final a3 = _norm(313.45 + 481266.484 * t);
    final eccentricity = 1 - 0.002516 * t - 0.0000074 * t2;

    double argument(List<int> row) =>
        (row[0] * elongation +
            row[1] * sunAnomaly +
            row[2] * moonAnomaly +
            row[3] * latitudeArgument) *
        _rad;
    double eccentricityFactor(int sunMultiple) => switch (sunMultiple.abs()) {
      1 => eccentricity,
      2 => eccentricity * eccentricity,
      _ => 1,
    };

    var sumLongitude = 0.0;
    var sumDistance = 0.0;
    for (final row in _longitudeAndDistanceTerms) {
      final arg = argument(row);
      final factor = eccentricityFactor(row[1]);
      sumLongitude += row[4] * factor * math.sin(arg);
      sumDistance += row[5] * factor * math.cos(arg);
    }
    var sumLatitude = 0.0;
    for (final row in _latitudeTerms) {
      sumLatitude +=
          row[4] * eccentricityFactor(row[1]) * math.sin(argument(row));
    }
    sumLongitude +=
        3958 * math.sin(a1 * _rad) +
        1962 * math.sin((meanLongitude - latitudeArgument) * _rad) +
        318 * math.sin(a2 * _rad);
    sumLatitude +=
        -2235 * math.sin(meanLongitude * _rad) +
        382 * math.sin(a3 * _rad) +
        175 * math.sin((a1 - latitudeArgument) * _rad) +
        175 * math.sin((a1 + latitudeArgument) * _rad) +
        127 * math.sin((meanLongitude - moonAnomaly) * _rad) -
        115 * math.sin((meanLongitude + moonAnomaly) * _rad);

    // Nutation and the obliquity of the ecliptic (Meeus, chapter 22).
    final node = _norm(125.04452 - 1934.136261 * t + 0.0020708 * t2);
    final sunMeanLongitude = _norm(280.4665 + 36000.7698 * t);
    final nutationLongitude =
        (-17.20 * math.sin(node * _rad) -
            1.32 * math.sin(2 * sunMeanLongitude * _rad) -
            0.23 * math.sin(2 * meanLongitude * _rad) +
            0.21 * math.sin(2 * node * _rad)) /
        3600;
    final nutationObliquity =
        (9.20 * math.cos(node * _rad) +
            0.57 * math.cos(2 * sunMeanLongitude * _rad) +
            0.10 * math.cos(2 * meanLongitude * _rad) -
            0.09 * math.cos(2 * node * _rad)) /
        3600;

    return (
      longitude: _norm(
        meanLongitude + sumLongitude / 1000000 + nutationLongitude,
      ),
      latitude: sumLatitude / 1000000,
      distanceKm: 385000.56 + sumDistance / 1000,
      nutationLongitude: nutationLongitude,
      obliquity:
          23.4392911111 -
          (46.8150 * t + 0.00059 * t2 - 0.001813 * t3) / 3600 +
          nutationObliquity,
    );
  }

  /// The sun's apparent longitude and distance (Meeus, chapter 25, to about
  /// a hundredth of a degree), for the moon's phase.
  static ({double longitude, double distanceKm}) _sun(DateTime instant) {
    final t = _centuries(instant);
    final meanLongitude = 280.46646 + 36000.76983 * t + 0.0003032 * t * t;
    final anomaly = (357.52911 + 35999.05029 * t - 0.0001537 * t * t) * _rad;
    final eccentricity = 0.016708634 - 0.000042037 * t - 0.0000001267 * t * t;
    final centre =
        (1.914602 - 0.004817 * t - 0.000014 * t * t) * math.sin(anomaly) +
        (0.019993 - 0.000101 * t) * math.sin(2 * anomaly) +
        0.000289 * math.sin(3 * anomaly);
    final trueAnomaly = anomaly + centre * _rad;
    final node = (125.04 - 1934.136 * t) * _rad;
    final distanceAu =
        1.000001018 *
        (1 - eccentricity * eccentricity) /
        (1 + eccentricity * math.cos(trueAnomaly));
    return (
      longitude: _norm(
        meanLongitude + centre - 0.00569 - 0.00478 * math.sin(node),
      ),
      distanceKm: distanceAu * 149597870.7,
    );
  }

  static const double _rad = math.pi / 180;

  static double _norm(double degrees) {
    final value = degrees % 360;
    return value < 0 ? value + 360 : value;
  }

  /// Meeus table 47.A: multiples of D, M, M′, F, then the longitude term in
  /// millionths of a degree and the distance term in metres.
  static const List<List<int>> _longitudeAndDistanceTerms = [
    [0, 0, 1, 0, 6288774, -20905355],
    [2, 0, -1, 0, 1274027, -3699111],
    [2, 0, 0, 0, 658314, -2955968],
    [0, 0, 2, 0, 213618, -569925],
    [0, 1, 0, 0, -185116, 48888],
    [0, 0, 0, 2, -114332, -3149],
    [2, 0, -2, 0, 58793, 246158],
    [2, -1, -1, 0, 57066, -152138],
    [2, 0, 1, 0, 53322, -170733],
    [2, -1, 0, 0, 45758, -204586],
    [0, 1, -1, 0, -40923, -129620],
    [1, 0, 0, 0, -34720, 108743],
    [0, 1, 1, 0, -30383, 104755],
    [2, 0, 0, -2, 15327, 10321],
    [0, 0, 1, 2, -12528, 0],
    [0, 0, 1, -2, 10980, 79661],
    [4, 0, -1, 0, 10675, -34782],
    [0, 0, 3, 0, 10034, -23210],
    [4, 0, -2, 0, 8548, -21636],
    [2, 1, -1, 0, -7888, 24208],
    [2, 1, 0, 0, -6766, 30824],
    [1, 0, -1, 0, -5163, -8379],
    [1, 1, 0, 0, 4987, -16675],
    [2, -1, 1, 0, 4036, -12831],
    [2, 0, 2, 0, 3994, -10445],
    [4, 0, 0, 0, 3861, -11650],
    [2, 0, -3, 0, 3665, 14403],
    [0, 1, -2, 0, -2689, -7003],
    [2, 0, -1, 2, -2602, 0],
    [2, -1, -2, 0, 2390, 10056],
    [1, 0, 1, 0, -2348, 6322],
    [2, -2, 0, 0, 2236, -9884],
    [0, 1, 2, 0, -2120, 5751],
    [0, 2, 0, 0, -2069, 0],
    [2, -2, -1, 0, 2048, -4950],
    [2, 0, 1, -2, -1773, 4130],
    [2, 0, 0, 2, -1595, 0],
    [4, -1, -1, 0, 1215, -3958],
    [0, 0, 2, 2, -1110, 0],
    [3, 0, -1, 0, -892, 3258],
    [2, 1, 1, 0, -810, 2616],
    [4, -1, -2, 0, 759, -1897],
    [0, 2, -1, 0, -713, -2117],
    [2, 2, -1, 0, -700, 2354],
    [2, 1, -2, 0, 691, 0],
    [2, -1, 0, -2, 596, 0],
    [4, 0, 1, 0, 549, -1423],
    [0, 0, 4, 0, 537, -1117],
    [4, -1, 0, 0, 520, -1571],
    [1, 0, -2, 0, -487, -1739],
    [2, 1, 0, -2, -399, 0],
    [0, 0, 2, -2, -381, -4421],
    [1, 1, 1, 0, 351, 0],
    [3, 0, -2, 0, -340, 0],
    [4, 0, -3, 0, 330, 0],
    [2, -1, 2, 0, 327, 0],
    [0, 2, 1, 0, -323, 1165],
    [1, 1, -1, 0, 299, 0],
    [2, 0, 3, 0, 294, 0],
    [2, 0, -1, -2, 0, 8752],
  ];

  /// Meeus table 47.B: multiples of D, M, M′, F, then the latitude term in
  /// millionths of a degree.
  static const List<List<int>> _latitudeTerms = [
    [0, 0, 0, 1, 5128122],
    [0, 0, 1, 1, 280602],
    [0, 0, 1, -1, 277693],
    [2, 0, 0, -1, 173237],
    [2, 0, -1, 1, 55413],
    [2, 0, -1, -1, 46271],
    [2, 0, 0, 1, 32573],
    [0, 0, 2, 1, 17198],
    [2, 0, 1, -1, 9266],
    [0, 0, 2, -1, 8822],
    [2, -1, 0, -1, 8216],
    [2, 0, -2, -1, 4324],
    [2, 0, 1, 1, 4200],
    [2, 1, 0, -1, -3359],
    [2, -1, -1, 1, 2463],
    [2, -1, 0, 1, 2211],
    [2, -1, -1, -1, 2065],
    [0, 1, -1, -1, -1870],
    [4, 0, -1, -1, 1828],
    [0, 1, 0, 1, -1794],
    [0, 0, 0, 3, -1749],
    [0, 1, -1, 1, -1565],
    [1, 0, 0, 1, -1491],
    [0, 1, 1, 1, -1475],
    [0, 1, 1, -1, -1410],
    [0, 1, 0, -1, -1344],
    [1, 0, 0, -1, -1335],
    [0, 0, 3, 1, 1107],
    [4, 0, 0, -1, 1021],
    [4, 0, -1, 1, 833],
    [0, 0, 1, -3, 777],
    [4, 0, -2, 1, 671],
    [2, 0, 0, -3, 607],
    [2, 0, 2, -1, 596],
    [2, -1, 1, -1, 491],
    [2, 0, -2, 1, -451],
    [0, 0, 3, -1, 439],
    [2, 0, 2, 1, 422],
    [2, 0, -3, -1, 421],
    [2, 1, -1, 1, -366],
    [2, 1, 0, 1, -351],
    [4, 0, 0, 1, 331],
    [2, -1, 1, 1, 315],
    [2, -2, 0, -1, 302],
    [0, 0, 1, 3, -283],
    [2, 1, 1, -1, -229],
    [1, 1, 0, -1, 223],
    [1, 1, 0, 1, 223],
    [0, 1, -2, -1, -220],
    [2, 1, -1, -1, -220],
    [1, 0, 1, 1, -185],
    [2, -1, -2, -1, 181],
    [0, 1, 2, 1, -177],
    [4, 0, -2, -1, 176],
    [4, -1, -1, -1, 166],
    [1, 0, 1, -1, -164],
    [4, 0, 1, -1, 132],
    [1, 0, -1, -1, -119],
    [4, -1, 0, -1, 115],
    [2, -2, 0, 1, 107],
  ];
}

class MoonHorizonEvents {
  const MoonHorizonEvents({required this.rise, required this.set});

  final DateTime? rise;
  final DateTime? set;
}

class MoonSkyPosition {
  const MoonSkyPosition({
    required this.azimuthDegrees,
    required this.altitudeDegrees,
    required this.isAboveHorizon,
  });

  /// Degrees clockwise from true north.
  final double azimuthDegrees;

  /// Degrees above the horizon as seen from the ground; negative below it.
  final double altitudeDegrees;

  /// True from moonrise to moonset, on the same line the rise and set use.
  final bool isAboveHorizon;
}

/// The eight phases, with a day or so either side of new, the quarters and
/// full named for them, as the Signs in the sky card has always shown.
enum MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent;

  static MoonPhase forAge(double ageDays) {
    if (ageDays < 1.5) return MoonPhase.newMoon;
    if (ageDays < 6.5) return MoonPhase.waxingCrescent;
    if (ageDays < 8.5) return MoonPhase.firstQuarter;
    if (ageDays < 13.5) return MoonPhase.waxingGibbous;
    if (ageDays < 16.5) return MoonPhase.fullMoon;
    if (ageDays < 21.5) return MoonPhase.waningGibbous;
    if (ageDays < 23.5) return MoonPhase.lastQuarter;
    if (ageDays < 28.5) return MoonPhase.waningCrescent;
    return MoonPhase.newMoon;
  }
}

class MoonPhaseReading {
  const MoonPhaseReading({
    required this.cycleFraction,
    required this.illuminatedFraction,
  });

  /// Mean length of the lunar month, in days.
  static const double synodicMonthDays = 29.53058867;

  /// 0 at new moon, 0.5 at full, from the moon's angle east of the sun.
  final double cycleFraction;

  /// Share of the moon's face in sunlight, 0 to 1.
  final double illuminatedFraction;

  double get ageDays => cycleFraction * synodicMonthDays;
  int get illuminationPercent => (illuminatedFraction * 100).round();
  MoonPhase get phase => MoonPhase.forAge(ageDays);
}
