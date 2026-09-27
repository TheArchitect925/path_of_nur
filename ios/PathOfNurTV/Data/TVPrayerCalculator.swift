import Foundation

// Prayer times by calculation.
//
// This is a port of the `adhan` Dart package (2.0.0+1, MIT, © 2020 Riajul
// Islam), which is itself a port of Batoul Apps' Adhan. It is the library the
// phone calculates with (lib/core/prayer/prayer_preferences.dart), ported
// rather than replaced so that the television and the phone in the same room
// show the same minute: the same equations (Meeus, Astronomical Algorithms),
// the same method table, the same high-latitude rule, the same rounding.
//
// Foundation only, no app types, so tooling/scripts/verify_tv_prayer_times.swift
// can compile this file on its own and check it against the Dart package.
// tools/tv_prayer_reference.json holds what the Dart package answers.

/// The authorities the phone offers, under the phone's own keys.
enum TVPrayerMethod: String, CaseIterable, Identifiable {
  case muslimWorldLeague = "MWL"
  case egyptian = "EGY"
  case isna = "ISNA"
  case karachi = "KAR"
  case ummAlQura = "QUR"

  var id: String { rawValue }

  /// The sun's angle below the horizon at Fajr, in degrees.
  var fajrAngle: Double {
    switch self {
    case .muslimWorldLeague: return 18.0
    case .egyptian: return 19.5
    case .isna: return 15.0
    case .karachi: return 18.0
    case .ummAlQura: return 18.5
    }
  }

  /// The sun's angle below the horizon at Isha, where Isha is set by angle.
  var ishaAngle: Double? {
    switch self {
    case .muslimWorldLeague: return 17.0
    case .egyptian: return 17.5
    case .isna: return 15.0
    case .karachi: return 18.0
    case .ummAlQura: return nil
    }
  }

  /// Minutes after Maghrib, where Isha is set by interval.
  var ishaIntervalMinutes: Int {
    self == .ummAlQura ? 90 : 0
  }

  /// Minutes each authority adds to Dhuhr, so it begins after the zenith.
  var dhuhrAdjustmentMinutes: Int {
    self == .ummAlQura ? 0 : 1
  }
}

/// How long the shadow is when Asr begins.
enum TVAsrRule: String, CaseIterable, Identifiable {
  /// Shafi’i, Maliki and Hanbali: the shadow equals the object.
  case standard
  /// Hanafi: the shadow is twice the object.
  case hanafi

  var id: String { rawValue }

  var shadowLength: Double {
    self == .hanafi ? 2.0 : 1.0
  }
}

struct TVPrayerDay: Equatable {
  let fajr: Date
  let sunrise: Date
  let dhuhr: Date
  let asr: Date
  let maghrib: Date
  let isha: Date
}

enum TVPrayerCalculator {
  /// The day's times for a place, or nil where the sun does not rise or set
  /// that day and the calculation has nothing to stand on.
  static func day(
    year: Int,
    month: Int,
    day: Int,
    latitude: Double,
    longitude: Double,
    method: TVPrayerMethod,
    asr: TVAsrRule
  ) -> TVPrayerDay? {
    guard let date = utcCalendar.date(
      from: DateComponents(year: year, month: month, day: day)
    ), let tomorrow = utcCalendar.date(byAdding: .day, value: 1, to: date) else {
      return nil
    }

    let solar = SolarTime(date: date, latitude: latitude, longitude: longitude)
    let tomorrowSolar = SolarTime(date: tomorrow, latitude: latitude, longitude: longitude)
    guard
      let transit = instant(on: date, hours: solar.transit),
      let sunrise = instant(on: date, hours: solar.sunrise),
      let sunset = instant(on: date, hours: solar.sunset),
      let tomorrowSunrise = instant(on: tomorrow, hours: tomorrowSolar.sunrise),
      let asrTime = instant(on: date, hours: solar.afternoon(shadowLength: asr.shadowLength))
    else {
      return nil
    }

    let nightMilliseconds = (tomorrowSunrise.timeIntervalSince1970
      - sunset.timeIntervalSince1970) * 1000

    // Where twilight never ends, Fajr is held to the middle of the night.
    let nightPortion = 0.5
    let safeSeconds = TimeInterval(Int((nightPortion * nightMilliseconds) / 1000))

    var fajr = instant(on: date, hours: solar.hourAngle(-method.fajrAngle, afterTransit: false))
    let safeFajr = sunrise.addingTimeInterval(-safeSeconds)
    if fajr == nil || fajr! < safeFajr {
      fajr = safeFajr
    }

    var isha: Date?
    if method.ishaIntervalMinutes > 0 {
      isha = sunset.addingTimeInterval(TimeInterval(method.ishaIntervalMinutes * 60))
    } else {
      if let angle = method.ishaAngle {
        isha = instant(on: date, hours: solar.hourAngle(-angle, afterTransit: true))
      }
      let safeIsha = sunset.addingTimeInterval(safeSeconds)
      if isha == nil || isha! > safeIsha {
        isha = safeIsha
      }
    }

    guard let fajr, let isha else { return nil }
    return TVPrayerDay(
      fajr: roundedMinute(fajr),
      sunrise: roundedMinute(sunrise),
      dhuhr: roundedMinute(
        transit.addingTimeInterval(TimeInterval(method.dhuhrAdjustmentMinutes * 60))
      ),
      asr: roundedMinute(asrTime),
      maghrib: roundedMinute(sunset),
      isha: roundedMinute(isha)
    )
  }

  static let utcCalendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
  }()

  /// A time given as hours of the UTC day, cut to whole seconds the way the
  /// package cuts it: hours, then minutes, then seconds, each floored.
  private static func instant(on date: Date, hours value: Double) -> Date? {
    guard value.isFinite else { return nil }
    let hours = value.rounded(.down)
    let minutes = ((value - hours) * 60).rounded(.down)
    let seconds = ((value - (hours + minutes / 60)) * 3600).rounded(.down)
    return date.addingTimeInterval(hours * 3600 + minutes * 60 + seconds)
  }

  /// To the minute, thirty seconds and over going up.
  private static func roundedMinute(_ date: Date) -> Date {
    let seconds = date.timeIntervalSince1970.rounded(.down)
    let intoMinute = seconds.truncatingRemainder(dividingBy: 60)
    let floor = seconds - intoMinute
    return Date(timeIntervalSince1970: intoMinute >= 30 ? floor + 60 : floor)
  }
}

// MARK: - The sun

private struct SolarCoordinates {
  /// Degrees between the sun's rays and the plane of the equator.
  let declination: Double
  /// Degrees along the celestial equator from the vernal equinox.
  let rightAscension: Double
  /// The hour angle of the vernal equinox, in degrees.
  let apparentSiderealTime: Double

  init(julianDay: Double) {
    let century = Astronomical.julianCentury(julianDay)
    let meanSolar = Astronomical.meanSolarLongitude(century)
    let meanLunar = Astronomical.meanLunarLongitude(century)
    let node = Astronomical.ascendingLunarNodeLongitude(century)
    let lambda = Astronomical.apparentSolarLongitude(century, meanLongitude: meanSolar).radians

    let theta0 = Astronomical.meanSiderealTime(century)
    let deltaPsi = Astronomical.nutationInLongitude(
      solarLongitude: meanSolar, lunarLongitude: meanLunar, ascendingNode: node
    )
    let deltaEpsilon = Astronomical.nutationInObliquity(
      solarLongitude: meanSolar, lunarLongitude: meanLunar, ascendingNode: node
    )

    let epsilon0 = Astronomical.meanObliquityOfTheEcliptic(century)
    let epsilonApparent = Astronomical.apparentObliquityOfTheEcliptic(
      century, meanObliquity: epsilon0
    ).radians

    declination = asin(sin(epsilonApparent) * sin(lambda)).degrees
    rightAscension = atan2(cos(epsilonApparent) * sin(lambda), cos(lambda))
      .degrees.unwoundAngle
    apparentSiderealTime = theta0
      + (((deltaPsi * 3600) * cos((epsilon0 + deltaEpsilon).radians)) / 3600)
  }
}

private struct SolarTime {
  let transit: Double
  let sunrise: Double
  let sunset: Double

  private let latitude: Double
  private let longitude: Double
  private let solar: SolarCoordinates
  private let previous: SolarCoordinates
  private let next: SolarCoordinates
  private let approximateTransit: Double

  init(date: Date, latitude: Double, longitude: Double) {
    let calendar = TVPrayerCalculator.utcCalendar
    let yesterday = calendar.date(byAdding: .day, value: -1, to: date) ?? date
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) ?? date

    self.latitude = latitude
    self.longitude = longitude
    previous = SolarCoordinates(julianDay: Astronomical.julianDay(of: yesterday))
    solar = SolarCoordinates(julianDay: Astronomical.julianDay(of: date))
    next = SolarCoordinates(julianDay: Astronomical.julianDay(of: tomorrow))

    approximateTransit = Astronomical.approximateTransit(
      longitude: longitude,
      siderealTime: solar.apparentSiderealTime,
      rightAscension: solar.rightAscension
    )
    transit = Astronomical.correctedTransit(
      approximateTransit: approximateTransit,
      longitude: longitude,
      siderealTime: solar.apparentSiderealTime,
      rightAscension: solar.rightAscension,
      previousRightAscension: previous.rightAscension,
      nextRightAscension: next.rightAscension
    )

    // The sun's centre is fifty minutes of arc below the horizon when its
    // upper edge meets it, refraction included.
    let horizon = -50.0 / 60.0
    sunrise = Astronomical.correctedHourAngle(
      approximateTransit: approximateTransit, angle: horizon,
      latitude: latitude, longitude: longitude, afterTransit: false,
      solar: solar, previous: previous, next: next
    )
    sunset = Astronomical.correctedHourAngle(
      approximateTransit: approximateTransit, angle: horizon,
      latitude: latitude, longitude: longitude, afterTransit: true,
      solar: solar, previous: previous, next: next
    )
  }

  func hourAngle(_ angle: Double, afterTransit: Bool) -> Double {
    Astronomical.correctedHourAngle(
      approximateTransit: approximateTransit, angle: angle,
      latitude: latitude, longitude: longitude, afterTransit: afterTransit,
      solar: solar, previous: previous, next: next
    )
  }

  func afternoon(shadowLength: Double) -> Double {
    let tangent = abs(latitude - solar.declination)
    let inverse = shadowLength + tan(tangent.radians)
    let angle = atan(1.0 / inverse).degrees
    return hourAngle(angle, afterTransit: true)
  }
}

// MARK: - Astronomical Algorithms (Jean Meeus), by page

private enum Astronomical {
  /// Page 60. The date is a UTC midnight, so the day has no fraction.
  static func julianDay(of date: Date) -> Double {
    let parts = TVPrayerCalculator.utcCalendar.dateComponents(
      [.year, .month, .day], from: date
    )
    let year = parts.year ?? 2000
    let month = parts.month ?? 1
    let day = parts.day ?? 1

    let y = month > 2 ? year : year - 1
    let m = month > 2 ? month : month + 12
    let a = y / 100
    let b = Int(2.0 - Double(a) + (Double(a) / 4.0))
    let i0 = Int(365.25 * Double(y + 4716))
    let i1 = Int(30.6001 * Double(m + 1))
    return Double(i0) + Double(i1) + Double(day) + Double(b) - 1524.5
  }

  /// Page 163.
  static func julianCentury(_ julianDay: Double) -> Double {
    (julianDay - 2451545.0) / 36525
  }

  /// Page 163.
  static func meanSolarLongitude(_ t: Double) -> Double {
    (280.4664567 + (36000.76983 * t) + (0.0003032 * pow(t, 2))).unwoundAngle
  }

  /// Page 144.
  static func meanLunarLongitude(_ t: Double) -> Double {
    (218.3165 + (481267.8813 * t)).unwoundAngle
  }

  /// Page 144.
  static func ascendingLunarNodeLongitude(_ t: Double) -> Double {
    (125.04452 - (1934.136261 * t) + (0.0020708 * pow(t, 2)) + (pow(t, 3) / 450000))
      .unwoundAngle
  }

  /// Page 163.
  static func meanSolarAnomaly(_ t: Double) -> Double {
    (357.52911 + (35999.05029 * t) - (0.0001537 * pow(t, 2))).unwoundAngle
  }

  /// Page 164.
  static func solarEquationOfTheCenter(_ t: Double, meanAnomaly: Double) -> Double {
    let m = meanAnomaly.radians
    let term1 = (1.914602 - (0.004817 * t) - (0.000014 * pow(t, 2))) * sin(m)
    let term2 = (0.019993 - (0.000101 * t)) * sin(2 * m)
    let term3 = 0.000289 * sin(3 * m)
    return term1 + term2 + term3
  }

  /// Page 164.
  static func apparentSolarLongitude(_ t: Double, meanLongitude: Double) -> Double {
    let longitude = meanLongitude
      + solarEquationOfTheCenter(t, meanAnomaly: meanSolarAnomaly(t))
    let omega = 125.04 - (1934.136 * t)
    return (longitude - 0.00569 - (0.00478 * sin(omega.radians))).unwoundAngle
  }

  /// Page 147.
  static func meanObliquityOfTheEcliptic(_ t: Double) -> Double {
    23.439291 - (0.013004167 * t) - (0.0000001639 * pow(t, 2)) + (0.0000005036 * pow(t, 3))
  }

  /// Page 165.
  static func apparentObliquityOfTheEcliptic(_ t: Double, meanObliquity: Double) -> Double {
    let o = 125.04 - (1934.136 * t)
    return meanObliquity + (0.00256 * cos(o.radians))
  }

  /// Page 165.
  static func meanSiderealTime(_ t: Double) -> Double {
    let julianDay = (t * 36525) + 2451545.0
    let term1 = 280.46061837
    let term2 = 360.98564736629 * (julianDay - 2451545)
    let term3 = 0.000387933 * pow(t, 2)
    let term4 = pow(t, 3) / 38710000
    return (term1 + term2 + term3 - term4).unwoundAngle
  }

  /// Page 144.
  static func nutationInLongitude(
    solarLongitude: Double, lunarLongitude: Double, ascendingNode: Double
  ) -> Double {
    let term1 = (-17.2 / 3600) * sin(ascendingNode.radians)
    let term2 = (1.32 / 3600) * sin(2 * solarLongitude.radians)
    let term3 = (0.23 / 3600) * sin(2 * lunarLongitude.radians)
    let term4 = (0.21 / 3600) * sin(2 * ascendingNode.radians)
    return term1 - term2 - term3 + term4
  }

  /// Page 144.
  static func nutationInObliquity(
    solarLongitude: Double, lunarLongitude: Double, ascendingNode: Double
  ) -> Double {
    let term1 = (9.2 / 3600) * cos(ascendingNode.radians)
    let term2 = (0.57 / 3600) * cos(2 * solarLongitude.radians)
    let term3 = (0.10 / 3600) * cos(2 * lunarLongitude.radians)
    let term4 = (0.09 / 3600) * cos(2 * ascendingNode.radians)
    return term1 + term2 + term3 - term4
  }

  /// Page 93.
  static func altitudeOfCelestialBody(
    latitude: Double, declination: Double, hourAngle: Double
  ) -> Double {
    let term1 = sin(latitude.radians) * sin(declination.radians)
    let term2 = cos(latitude.radians) * cos(declination.radians) * cos(hourAngle.radians)
    return asin(term1 + term2).degrees
  }

  /// Page 102.
  static func approximateTransit(
    longitude: Double, siderealTime: Double, rightAscension: Double
  ) -> Double {
    let west = longitude * -1
    return ((rightAscension + west - siderealTime) / 360).normalized(within: 1)
  }

  /// Page 102. Hours of the UTC day at which the sun is highest.
  static func correctedTransit(
    approximateTransit m0: Double,
    longitude: Double,
    siderealTime: Double,
    rightAscension: Double,
    previousRightAscension: Double,
    nextRightAscension: Double
  ) -> Double {
    let west = longitude * -1
    let theta = (siderealTime + (360.985647 * m0)).unwoundAngle
    let alpha = interpolateAngles(
      rightAscension, previous: previousRightAscension, next: nextRightAscension, factor: m0
    ).unwoundAngle
    let hourAngle = (theta - west - alpha).closestAngle
    let deltaM = hourAngle / -360
    return (m0 + deltaM) * 24
  }

  /// Page 102. Hours of the UTC day at which the sun stands at `angle`, or
  /// not a number where it never does.
  static func correctedHourAngle(
    approximateTransit m0: Double,
    angle h0: Double,
    latitude: Double,
    longitude: Double,
    afterTransit: Bool,
    solar: SolarCoordinates,
    previous: SolarCoordinates,
    next: SolarCoordinates
  ) -> Double {
    let west = longitude * -1
    let term1 = sin(h0.radians) - (sin(latitude.radians) * sin(solar.declination.radians))
    let term2 = cos(latitude.radians) * cos(solar.declination.radians)
    let h0Angle = acos(term1 / term2).degrees
    let m = afterTransit ? m0 + (h0Angle / 360) : m0 - (h0Angle / 360)
    let theta = (solar.apparentSiderealTime + (360.985647 * m)).unwoundAngle
    let alpha = interpolateAngles(
      solar.rightAscension,
      previous: previous.rightAscension,
      next: next.rightAscension,
      factor: m
    ).unwoundAngle
    let delta = interpolate(
      solar.declination,
      previous: previous.declination,
      next: next.declination,
      factor: m
    )
    let hourAngle = theta - west - alpha
    let altitude = altitudeOfCelestialBody(
      latitude: latitude, declination: delta, hourAngle: hourAngle
    )
    let term3 = altitude - h0
    let term4 = 360 * cos(delta.radians) * cos(latitude.radians) * sin(hourAngle.radians)
    let deltaM = term3 / term4
    return (m + deltaM) * 24
  }

  /// Page 24.
  static func interpolate(
    _ value: Double, previous: Double, next: Double, factor: Double
  ) -> Double {
    let a = value - previous
    let b = next - value
    let c = b - a
    return value + ((factor / 2) * (a + b + (factor * c)))
  }

  /// Page 24, for angles that pass through 360.
  static func interpolateAngles(
    _ value: Double, previous: Double, next: Double, factor: Double
  ) -> Double {
    let a = (value - previous).unwoundAngle
    let b = (next - value).unwoundAngle
    let c = b - a
    return value + ((factor / 2) * (a + b + (factor * c)))
  }
}

private extension Double {
  var radians: Double { self * .pi / 180.0 }
  var degrees: Double { self * 180.0 / .pi }

  func normalized(within bound: Double) -> Double {
    self - (bound * (self / bound).rounded(.down))
  }

  var unwoundAngle: Double { normalized(within: 360) }

  var closestAngle: Double {
    if self >= -180 && self <= 180 {
      return self
    }
    return self - (360 * (self / 360).rounded())
  }
}

/// A date of the Hijri year.
struct TVHijriDate: Equatable {
  let year: Int
  let month: Int
  let day: Int
}

/// The Hijri calendar as the phone reckons it
/// (`lib/shared/utils/hijri_date_utils.dart`): the arithmetic calendar of
/// thirty-year cycles, counted from the civil epoch. It is ported, and not
/// asked of the system, because the system's calendars are counted from
/// epochs a day apart and the phone and the television must name one day.
///
/// It is used to choose the look of the season with the phone, and not to
/// tell the viewer the date. An arithmetic calendar stands apart from the
/// calendar people keep: from 2020 to 2040 this one names the day Umm
/// al-Qura names on 4,326 days of 7,671, is a day behind it on 2,868 and two
/// on 87, and is a day ahead on 390.
enum TVHijriCalendar {
  static func date(year: Int, month: Int, day: Int) -> TVHijriDate {
    func floored(_ numerator: Int, _ denominator: Int) -> Int {
      Int((Double(numerator) / Double(denominator)).rounded(.down))
    }

    let a = floored(14 - month, 12)
    let y2 = year + 4800 - a
    let m2 = month + 12 * a - 3
    let julianDay = day
      + floored(153 * m2 + 2, 5)
      + 365 * y2
      + floored(y2, 4)
      - floored(y2, 100)
      + floored(y2, 400)
      - 32045

    var l = julianDay - 1_948_440 + 10632
    let n = floored(l - 1, 10631)
    l = l - 10631 * n + 354
    let j = floored(10985 - l, 5316) * floored(50 * l, 17719)
      + floored(l, 5670) * floored(43 * l, 15238)
    l = l
      - floored(30 - j, 15) * floored(17719 * j, 50)
      - floored(j, 16) * floored(15238 * j, 43)
      + 29
    let hijriMonth = floored(24 * l, 709)
    let hijriDay = l - floored(709 * hijriMonth, 24)
    let hijriYear = 30 * n + j - 30
    return TVHijriDate(year: hijriYear, month: hijriMonth, day: hijriDay)
  }

  /// The Hijri date of the day it is at `date` in the calendar given,
  /// which carries the time zone of the place.
  static func date(of date: Date, in calendar: Calendar) -> TVHijriDate {
    let day = calendar.dateComponents([.year, .month, .day], from: date)
    return self.date(year: day.year ?? 1, month: day.month ?? 1, day: day.day ?? 1)
  }
}

/// One prayer of the day and the time it may be offered in.
struct TVPrayerWindow: Equatable {
  /// fajr, dhuhr, asr, maghrib, isha or tahajjud.
  let id: String
  let start: Date
  let end: Date
}

/// The day laid out as the phone lays it out
/// (`lib/core/prayer/prayer_preferences.dart`), so that the phone and the
/// television in one room name the same prayer as the one it is time for.
enum TVPrayerSchedule {
  /// When the phone shows Jumu'ah, by the clock of the place, until a
  /// viewer has given it their mosque's own time. 13:30.
  static let jumuahDisplayMinutes = 13 * 60 + 30

  /// How far into the night Tahajjud begins: Isha has the first 66 parts in
  /// a hundred of the time from Isha to the Fajr after it.
  static let tahajjudShareOfNight = 0.66

  /// The day's five prayers and the night prayer after them
  /// (`buildCalculatedPrayerScheduleForDate`).
  static func windows(day: TVPrayerDay, following: TVPrayerDay) -> [TVPrayerWindow] {
    let night = following.fajr.timeIntervalSince(day.isha)
    let tahajjud = day.isha.addingTimeInterval(
      (Double(Int(night)) * tahajjudShareOfNight).rounded()
    )
    return [
      TVPrayerWindow(id: "fajr", start: day.fajr, end: day.sunrise),
      TVPrayerWindow(id: "dhuhr", start: day.dhuhr, end: day.asr),
      TVPrayerWindow(id: "asr", start: day.asr, end: day.maghrib),
      TVPrayerWindow(id: "maghrib", start: day.maghrib, end: day.isha),
      TVPrayerWindow(id: "isha", start: day.isha, end: tahajjud),
      TVPrayerWindow(id: "tahajjud", start: tahajjud, end: following.fajr),
    ]
  }

  /// On a Friday, Dhuhr is shown as Jumu'ah at the hour Jumu'ah is held
  /// (`_applyFridayJumuahDisplayOverride`). Its end is Dhuhr's.
  static func showingJumuah(_ windows: [TVPrayerWindow], at jumuah: Date) -> [TVPrayerWindow] {
    windows.map { window in
      window.id == "dhuhr"
        ? TVPrayerWindow(id: window.id, start: jumuah, end: window.end)
        : window
    }
  }

  struct Context: Equatable {
    /// The prayer it is time for, if it is time for one.
    let current: String?
    let next: String
    let nextStart: Date
  }

  /// Which prayer it is time for and which is next
  /// (`derivePrayerScheduleContext`). After the last of the day's windows
  /// the next is the first again, a day on.
  static func context(_ windows: [TVPrayerWindow], at now: Date) -> Context? {
    guard let first = windows.first, let last = windows.last else {
      return nil
    }
    var current: TVPrayerWindow?
    var next: TVPrayerWindow?
    for (index, window) in windows.enumerated() {
      if now >= window.start && now < window.end {
        current = window
        next = index + 1 < windows.count ? windows[index + 1] : nil
        break
      }
      if now < window.start {
        next = window
        break
      }
    }
    let following = next ?? first
    if current == nil && now > last.end {
      current = last
    }
    var nextStart = following.start
    if nextStart <= now {
      nextStart = nextStart.addingTimeInterval(86_400)
    }
    return Context(current: current?.id, next: following.id, nextStart: nextStart)
  }
}

/// The sky at an hour of the day, as the phone has it (`noorSkyPhaseAt`,
/// `lib/core/theme/living_atmosphere.dart`): it turns with the prayers.
/// Night is from Isha to Fajr, dawn the hour and a half after Fajr, and the
/// sky is Maghrib's from three quarters of an hour before it.
enum TVSkyPhase: String {
  case dawn, day, maghrib, night

  struct Times: Equatable {
    let fajr: Date
    let maghrib: Date
    let isha: Date
  }

  static func at(
    _ now: Date,
    times: Times?,
    calendar: Calendar = .current
  ) -> TVSkyPhase {
    if let times {
      if now < times.fajr || now >= times.isha {
        return .night
      }
      if now < times.fajr.addingTimeInterval(90 * 60) {
        return .dawn
      }
      if now >= times.maghrib.addingTimeInterval(-45 * 60) {
        return .maghrib
      }
      return .day
    }
    // Where there are no prayer times yet, by the hour.
    let components = calendar.dateComponents([.hour, .minute], from: now)
    let hour = Double(components.hour ?? 12) + Double(components.minute ?? 0) / 60
    if hour >= 21 || hour < 5 { return .night }
    if hour < 8 { return .dawn }
    if hour >= 17.5 { return .maghrib }
    return .day
  }
}
