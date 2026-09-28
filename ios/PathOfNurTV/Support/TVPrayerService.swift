import CoreLocation
import Foundation

/// Where the prayer times are calculated for.
struct TVPrayerPlace: Equatable {
  enum Source: String {
    case device
    case city
  }

  let source: Source
  let cityId: String?
  let name: String
  let latitude: Double
  let longitude: Double
  let timeZoneIdentifier: String

  var timeZone: TimeZone {
    TimeZone(identifier: timeZoneIdentifier) ?? .current
  }
}

enum TVPrayerLocationStatus: Equatable {
  /// Nothing chosen and nothing asked yet.
  case unset
  case locating
  case ready
  /// Location is switched off for this app in tvOS Settings.
  case denied
  case failed
}

struct TVPrayerSnapshot {
  let summaryLine: String
  let detailLine: String
  let placeLine: String
  let methodLine: String
  let prayerTimes: [TVPrayerTime]

  var hasTimes: Bool { !prayerTimes.isEmpty }
}

/// Today's prayer times for one place, under one authority.
///
/// The place is the Apple TV's own location, asked for once, or a city chosen
/// in Settings. Nothing is shown until there is a place: a time that is wrong
/// for where the viewer stands is worse than no time.
final class TVPrayerService: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published private(set) var place: TVPrayerPlace?
  @Published private(set) var status: TVPrayerLocationStatus
  @Published private(set) var method: TVPrayerMethod
  @Published private(set) var asr: TVAsrRule
  /// Minutes each prayer is moved by, to match a local mosque's timetable,
  /// within half an hour either way as on the phone.
  @Published private(set) var offsets: [String: Int]
  /// When Jumu'ah is prayed, in minutes after midnight.
  @Published private(set) var jumuahMinutes: Int

  static let adjustablePrayers = ["fajr", "dhuhr", "asr", "maghrib", "isha"]
  static let offsetLimit = 30

  private let userDefaults: UserDefaults
  private let locationManager = CLLocationManager()
  private let geocoder = CLGeocoder()

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    method = TVPrayerMethod(
      rawValue: userDefaults.string(forKey: Self.methodKey) ?? ""
    ) ?? .muslimWorldLeague
    asr = TVAsrRule(
      rawValue: userDefaults.string(forKey: Self.asrKey) ?? ""
    ) ?? .standard
    offsets = (userDefaults.dictionary(forKey: Self.offsetsKey) as? [String: Int] ?? [:])
      .filter { Self.adjustablePrayers.contains($0.key) && $0.value != 0 }
    jumuahMinutes = (userDefaults.object(forKey: Self.jumuahKey) as? Int)
      ?? TVPrayerSchedule.jumuahDisplayMinutes
    let stored = Self.storedPlace(in: userDefaults)
    place = stored
    status = stored == nil ? .unset : .ready
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

    #if targetEnvironment(simulator)
    // Simulator-only, like TV_SAMPLE_ROUTE: stand in a city without the
    // location prompt, so a screen can be screenshotted with real times.
    if let forced = ProcessInfo.processInfo.environment["TV_SAMPLE_CITY"] {
      if let city = TVPrayerCities.city(id: forced) {
        place = Self.place(for: city)
        status = .ready
      } else if forced == "none" {
        // An Apple TV that has been refused its location and has chosen
        // no city.
        place = nil
        status = .denied
      }
    }
    #endif
  }

  /// Asks for the Apple TV's location the first time, and only then.
  func startIfNeeded() {
    guard place == nil, status == .unset else { return }
    useDeviceLocation()
  }

  func useDeviceLocation() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      status = .locating
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      status = .locating
      locationManager.requestLocation()
    default:
      status = .denied
    }
  }

  func selectCity(_ city: TVPrayerCity) {
    geocoder.cancelGeocode()
    store(Self.place(for: city))
  }

  func selectMethod(_ method: TVPrayerMethod) {
    self.method = method
    userDefaults.set(method.rawValue, forKey: Self.methodKey)
  }

  func selectAsr(_ asr: TVAsrRule) {
    self.asr = asr
    userDefaults.set(asr.rawValue, forKey: Self.asrKey)
  }

  func offset(for prayer: String) -> Int {
    offsets[prayer] ?? 0
  }

  /// Moves one prayer by `delta` minutes, never more than half an hour from
  /// the time calculated.
  func adjust(_ prayer: String, by delta: Int) {
    guard Self.adjustablePrayers.contains(prayer) else { return }
    let value = min(max(offset(for: prayer) + delta, -Self.offsetLimit), Self.offsetLimit)
    offsets[prayer] = value == 0 ? nil : value
    userDefaults.set(offsets, forKey: Self.offsetsKey)
  }

  func resetOffsets() {
    offsets = [:]
    userDefaults.removeObject(forKey: Self.offsetsKey)
  }

  /// Moves Jumu'ah by `delta` minutes, between 11:30 and 15:30.
  func adjustJumuah(by delta: Int) {
    jumuahMinutes = min(max(jumuahMinutes + delta, 11 * 60 + 30), 15 * 60 + 30)
    userDefaults.set(jumuahMinutes, forKey: Self.jumuahKey)
  }

  /// "13:30", or as the viewer's clock writes it.
  func jumuahLabel() -> String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = place?.timeZone ?? .current
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.timeZone = calendar.timeZone
    formatter.setLocalizedDateFormatFromTemplate("jm")
    let date = calendar.date(
      bySettingHour: jumuahMinutes / 60, minute: jumuahMinutes % 60, second: 0, of: Date()
    ) ?? Date()
    return formatter.string(from: date)
  }

  /// Today's time of one prayer as it is shown, the offset included.
  func timeLabel(for prayer: String, at now: Date = Date()) -> String {
    snapshot(at: now).prayerTimes.first { $0.id == prayer }?.timeLabel ?? ""
  }

  // MARK: - Today

  func snapshot(at now: Date = Date()) -> TVPrayerSnapshot {
    guard let place else {
      return TVPrayerSnapshot(
        summaryLine: status == .locating
          ? tvLocalized("Finding this Apple TV")
          : tvLocalized("Choose a location"),
        detailLine: status == .locating
          ? ""
          : tvLocalized("Prayer times need a place. Choose one in Settings."),
        placeLine: "",
        methodLine: "",
        prayerTimes: []
      )
    }

    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = place.timeZone
    let today = calendar.dateComponents([.year, .month, .day], from: now)
    let nextDay = calendar.date(byAdding: .day, value: 1, to: now) ?? now
    let tomorrow = calendar.dateComponents([.year, .month, .day], from: nextDay)

    guard
      let day = prayerDay(today, at: place),
      let following = prayerDay(tomorrow, at: place)
    else {
      return TVPrayerSnapshot(
        summaryLine: tvLocalized("No prayer times for today"),
        detailLine: tvLocalized("The sun does not rise or set here today."),
        placeLine: place.name,
        methodLine: tvLocalized(method.nameKey),
        prayerTimes: []
      )
    }

    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.timeZone = place.timeZone
    formatter.setLocalizedDateFormatFromTemplate("jm")

    // The day is laid out as the phone lays it out: five prayers and the
    // night prayer after them, and on a Friday Jumu'ah in Dhuhr's place.
    var windows = TVPrayerSchedule.windows(day: day, following: following)
    let isFriday = calendar.component(.weekday, from: now) == 6
    if isFriday, let jumuah = calendar.date(
      bySettingHour: jumuahMinutes / 60,
      minute: jumuahMinutes % 60,
      second: 0,
      of: now
    ) {
      windows = TVPrayerSchedule.showingJumuah(windows, at: jumuah)
    }
    let context = TVPrayerSchedule.context(windows, at: now)

    func name(_ id: String) -> (title: String, arabic: String) {
      switch id {
      case "fajr": return (tvLocalized("Fajr"), "الفجر")
      case "dhuhr":
        return isFriday ? (tvLocalized("Jumu’ah"), "الجمعة") : (tvLocalized("Dhuhr"), "الظهر")
      case "asr": return (tvLocalized("Asr"), "العصر")
      case "maghrib": return (tvLocalized("Maghrib"), "المغرب")
      case "isha": return (tvLocalized("Isha"), "العشاء")
      default: return (tvLocalized("Tahajjud"), "التهجد")
      }
    }

    let cards = windows.map { window -> TVPrayerTime in
      let isCurrent = context?.current == window.id
      // The next prayer is the next on this list. After the last of them
      // it is tomorrow's first, which is not on it.
      let isNext = context?.next == window.id && window.start > now
      let statusLine: String
      if isCurrent {
        statusLine = tvLocalized("Ends in %@", duration(from: now, to: window.end))
      } else if isNext {
        statusLine = tvLocalized("Starts in %@", duration(from: now, to: window.start))
      } else if window.start <= now {
        statusLine = tvLocalized("Earlier today")
      } else {
        statusLine = tvLocalized("Later today")
      }
      return TVPrayerTime(
        id: window.id,
        title: name(window.id).title,
        arabicTitle: name(window.id).arabic,
        timeLabel: formatter.string(from: window.start),
        statusLine: statusLine,
        isCurrent: isCurrent,
        isNext: isNext
      )
    }

    let nextName = name(context?.next ?? "fajr").title
    let nextStart = context?.nextStart ?? following.fajr

    let summaryLine: String
    let detailLine: String
    if let current = context?.current {
      summaryLine = tvLocalized("Current prayer: %@", name(current).title)
      detailLine = tvLocalized(
        "%@ begins at %@", nextName, formatter.string(from: nextStart)
      )
    } else {
      summaryLine = tvLocalized("Next prayer: %@", nextName)
      detailLine = tvLocalized("Starts in %@", duration(from: now, to: nextStart))
    }

    return TVPrayerSnapshot(
      summaryLine: summaryLine,
      detailLine: detailLine,
      placeLine: place.name,
      methodLine: tvLocalized(method.nameKey),
      prayerTimes: cards
    )
  }

  /// The day at the place: in the calendar the prayer times are reckoned
  /// by, and then in the Hijri year.
  ///
  /// The first calendar is named. Left to the language, Arabic as it is
  /// written in Saudi Arabia would name the day in the Hijri year, and the
  /// heading would give that date twice and the date the times are for not
  /// at all.
  func todayLabel(at now: Date = Date()) -> String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = place?.timeZone ?? .current
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.calendar = calendar
    formatter.timeZone = calendar.timeZone
    formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
    return "\(formatter.string(from: now)) · \(hijriLabel(at: now))"
  }

  /// The day at the place in the Hijri year, as the phone names it: by the
  /// Umm al-Qura calendar (`TVHijriCalendar`), the day begun at midnight.
  func hijriLabel(at now: Date = Date()) -> String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = place?.timeZone ?? .current
    let hijri = TVHijriCalendar.date(of: now, in: calendar)
    // A year is not a quantity: 1448, and not 1,448.
    let numbers = NumberFormatter()
    numbers.locale = .current
    numbers.usesGroupingSeparator = false
    let day = numbers.string(from: NSNumber(value: hijri.day)) ?? "\(hijri.day)"
    let year = numbers.string(from: NSNumber(value: hijri.year)) ?? "\(hijri.year)"
    return tvLocalized("%@ %@ %@ AH", day, Self.hijriMonthName(hijri.month), year)
  }

  /// The months of the Hijri year, as the phone writes them.
  static func hijriMonthName(_ month: Int) -> String {
    switch month {
    case 1: return tvLocalized("Muharram")
    case 2: return tvLocalized("Safar")
    case 3: return tvLocalized("Rabi al-Awwal")
    case 4: return tvLocalized("Rabi al-Thani")
    case 5: return tvLocalized("Jumada al-Awwal")
    case 6: return tvLocalized("Jumada al-Thani")
    case 7: return tvLocalized("Rajab")
    case 8: return tvLocalized("Sha’ban")
    case 9: return tvLocalized("Ramadan")
    case 10: return tvLocalized("Shawwal")
    case 11: return tvLocalized("Dhu al-Qi’dah")
    default: return tvLocalized("Dhu al-Hijjah")
    }
  }

  /// The same for the place that is kept, for what is made before the
  /// service is: the look is chosen before the first screen is drawn.
  static func keptSkyTimes(in userDefaults: UserDefaults, at now: Date) -> TVSkyPhase.Times? {
    TVPrayerService(userDefaults: userDefaults).skyTimes(at: now)
  }

  /// The day's Fajr, Maghrib and Isha at the place, for the sky to turn by.
  func skyTimes(at now: Date = Date()) -> TVSkyPhase.Times? {
    guard let place else { return nil }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = place.timeZone
    let today = calendar.dateComponents([.year, .month, .day], from: now)
    guard let day = prayerDay(today, at: place) else { return nil }
    return TVSkyPhase.Times(fajr: day.fajr, maghrib: day.maghrib, isha: day.isha)
  }

  private func prayerDay(_ date: DateComponents, at place: TVPrayerPlace) -> TVPrayerDay? {
    guard let year = date.year, let month = date.month, let day = date.day else {
      return nil
    }
    guard let calculated = TVPrayerCalculator.day(
      year: year, month: month, day: day,
      latitude: place.latitude, longitude: place.longitude,
      method: method, asr: asr
    ) else {
      return nil
    }
    guard !offsets.isEmpty else { return calculated }
    func moved(_ date: Date, _ prayer: String) -> Date {
      date.addingTimeInterval(TimeInterval(offset(for: prayer) * 60))
    }
    return TVPrayerDay(
      fajr: moved(calculated.fajr, "fajr"),
      sunrise: calculated.sunrise,
      dhuhr: moved(calculated.dhuhr, "dhuhr"),
      asr: moved(calculated.asr, "asr"),
      maghrib: moved(calculated.maghrib, "maghrib"),
      isha: moved(calculated.isha, "isha")
    )
  }

  private func duration(from start: Date, to end: Date) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .dropLeading
    return formatter.string(from: max(end.timeIntervalSince(start), 60)) ?? ""
  }

  // MARK: - Location

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard status == .locating else { return }
    switch manager.authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.requestLocation()
    case .notDetermined:
      break
    default:
      status = .denied
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let coordinate = location.coordinate
    geocoder.cancelGeocode()
    geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
      guard let self else { return }
      let placemark = placemarks?.first
      let name = placemark?.locality
        ?? placemark?.administrativeArea
        ?? tvLocalized("This Apple TV’s location")
      self.store(
        TVPrayerPlace(
          source: .device,
          cityId: nil,
          name: name,
          latitude: coordinate.latitude,
          longitude: coordinate.longitude,
          timeZoneIdentifier: (placemark?.timeZone ?? .current).identifier
        )
      )
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // A place already in hand stays in hand: a failed refresh is not a loss.
    status = place == nil ? .failed : .ready
    TVTelemetry.recordError(
      "tvos_prayer_location_failed",
      message: error.localizedDescription,
      userDefaults: userDefaults
    )
  }

  // MARK: - Keeping

  private func store(_ place: TVPrayerPlace) {
    self.place = place
    status = .ready
    userDefaults.set(
      [
        "source": place.source.rawValue,
        "cityId": place.cityId ?? "",
        "name": place.name,
        "latitude": place.latitude,
        "longitude": place.longitude,
        "timeZone": place.timeZoneIdentifier,
      ] as [String: Any],
      forKey: Self.placeKey
    )
  }

  private static func storedPlace(in userDefaults: UserDefaults) -> TVPrayerPlace? {
    guard
      let stored = userDefaults.dictionary(forKey: placeKey),
      let source = TVPrayerPlace.Source(rawValue: stored["source"] as? String ?? ""),
      let latitude = stored["latitude"] as? Double,
      let longitude = stored["longitude"] as? Double,
      let timeZone = stored["timeZone"] as? String
    else {
      return nil
    }
    let cityId = (stored["cityId"] as? String).flatMap { $0.isEmpty ? nil : $0 }
    // A city is named again from the list, so it follows the language in use.
    if source == .city, let cityId, let city = TVPrayerCities.city(id: cityId) {
      return place(for: city)
    }
    return TVPrayerPlace(
      source: source,
      cityId: cityId,
      name: stored["name"] as? String ?? "",
      latitude: latitude,
      longitude: longitude,
      timeZoneIdentifier: timeZone
    )
  }

  private static func place(for city: TVPrayerCity) -> TVPrayerPlace {
    TVPrayerPlace(
      source: .city,
      cityId: city.id,
      name: city.name,
      latitude: city.latitude,
      longitude: city.longitude,
      timeZoneIdentifier: city.timeZoneIdentifier
    )
  }

  private static let placeKey = "PathOfNurTV.prayer.place"
  private static let methodKey = "PathOfNurTV.prayer.method"
  private static let asrKey = "PathOfNurTV.prayer.asr"
  private static let offsetsKey = "PathOfNurTV.prayer.offsets"
  private static let jumuahKey = "PathOfNurTV.prayer.jumuah"
}

// MARK: - What Settings shows

extension TVPrayerMethod {
  var nameKey: String {
    switch self {
    case .muslimWorldLeague:
      return "Muslim World League"
    case .egyptian:
      return "Egyptian General Authority"
    case .isna:
      return "Islamic Society of North America"
    case .karachi:
      return "University of Karachi"
    case .ummAlQura:
      return "Umm al-Qura University"
    }
  }

  /// "Fajr 18° · Isha 17°", the two angles that set one authority apart.
  var anglesLine: String {
    let fajr = Self.degrees(fajrAngle)
    if let ishaAngle {
      return tvLocalized("Fajr %@° · Isha %@°", fajr, Self.degrees(ishaAngle))
    }
    return tvLocalized("Fajr %@° · Isha %d min after Maghrib", fajr, ishaIntervalMinutes)
  }

  var systemImage: String {
    "globe"
  }

  private static func degrees(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}

extension TVAsrRule {
  var nameKey: String {
    switch self {
    case .standard:
      return "Shafi’i, Maliki, Hanbali"
    case .hanafi:
      return "Hanafi"
    }
  }

  var detailKey: String {
    switch self {
    case .standard:
      return "Asr begins when a shadow is as long as its object."
    case .hanafi:
      return "Asr begins when a shadow is twice as long as its object."
    }
  }

  var systemImage: String {
    switch self {
    case .standard:
      return "sun.max.fill"
    case .hanafi:
      return "sun.haze.fill"
    }
  }
}
