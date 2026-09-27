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
    let stored = Self.storedPlace(in: userDefaults)
    place = stored
    status = stored == nil ? .unset : .ready
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

    #if targetEnvironment(simulator)
    // Simulator-only, like TV_SAMPLE_ROUTE: stand in a city without the
    // location prompt, so a screen can be screenshotted with real times.
    if let forced = ProcessInfo.processInfo.environment["TV_SAMPLE_CITY"],
       let city = TVPrayerCities.city(id: forced) {
      place = Self.place(for: city)
      status = .ready
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

    let prayers: [(id: String, name: String, arabic: String, start: Date, end: Date)] = [
      ("fajr", tvLocalized("Fajr"), "الفجر", day.fajr, day.sunrise),
      ("dhuhr", tvLocalized("Dhuhr"), "الظهر", day.dhuhr, day.asr),
      ("asr", tvLocalized("Asr"), "العصر", day.asr, day.maghrib),
      ("maghrib", tvLocalized("Maghrib"), "المغرب", day.maghrib, day.isha),
      ("isha", tvLocalized("Isha"), "العشاء", day.isha, following.fajr),
    ]

    let currentIndex = prayers.lastIndex { $0.start <= now && now < $0.end }
    let nextIndex = prayers.firstIndex { $0.start > now }

    let cards = prayers.enumerated().map { index, prayer in
      let isCurrent = currentIndex == index
      let isNext = nextIndex == index
      let statusLine: String
      if isCurrent {
        statusLine = tvLocalized("Ends in %@", duration(from: now, to: prayer.end))
      } else if isNext {
        statusLine = tvLocalized("Begins at %@", formatter.string(from: prayer.start))
      } else if prayer.start <= now {
        statusLine = tvLocalized("Earlier today")
      } else {
        statusLine = tvLocalized("Later today")
      }
      return TVPrayerTime(
        id: prayer.id,
        title: prayer.name,
        arabicTitle: prayer.arabic,
        timeLabel: formatter.string(from: prayer.start),
        statusLine: statusLine,
        isCurrent: isCurrent,
        isNext: isNext
      )
    }

    // After Isha the next prayer is tomorrow's Fajr.
    let next: (name: String, start: Date) = nextIndex.map {
      (prayers[$0].name, prayers[$0].start)
    } ?? (tvLocalized("Fajr"), following.fajr)

    let summaryLine: String
    let detailLine: String
    if let currentIndex {
      summaryLine = tvLocalized("Current prayer: %@", prayers[currentIndex].name)
      detailLine = tvLocalized(
        "%@ begins at %@", next.name, formatter.string(from: next.start)
      )
    } else {
      summaryLine = tvLocalized("Next prayer: %@", next.name)
      detailLine = tvLocalized("Begins at %@", formatter.string(from: next.start))
    }

    return TVPrayerSnapshot(
      summaryLine: summaryLine,
      detailLine: detailLine,
      placeLine: place.name,
      methodLine: tvLocalized(method.nameKey),
      prayerTimes: cards
    )
  }

  /// The day at the place, as the place's own calendar names it.
  func todayLabel(at now: Date = Date()) -> String {
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.timeZone = place?.timeZone ?? .current
    formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
    return formatter.string(from: now)
  }

  private func prayerDay(_ date: DateComponents, at place: TVPrayerPlace) -> TVPrayerDay? {
    guard let year = date.year, let month = date.month, let day = date.day else {
      return nil
    }
    return TVPrayerCalculator.day(
      year: year, month: month, day: day,
      latitude: place.latitude, longitude: place.longitude,
      method: method, asr: asr
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
