import Foundation

/// A place the viewer can choose when the Apple TV cannot say where it is.
struct TVPrayerCity: Identifiable, Hashable {
  let id: String
  let name: String
  let latitude: Double
  let longitude: Double
  let timeZoneIdentifier: String
}

/// The cities offered in Settings. A television has no keyboard worth typing
/// a town into, so this is a list to pick from, and the Apple TV's own
/// location is the first choice. The phone's five cities are here with the
/// phone's coordinates (lib/core/prayer/prayer_preferences.dart).
enum TVPrayerCities {
  static let all: [TVPrayerCity] = [
    TVPrayerCity(
      id: "makkah",
      name: tvLocalized("Makkah, Saudi Arabia"),
      latitude: 21.4225,
      longitude: 39.8262,
      timeZoneIdentifier: "Asia/Riyadh"
    ),
    TVPrayerCity(
      id: "madinah",
      name: tvLocalized("Madinah, Saudi Arabia"),
      latitude: 24.4672,
      longitude: 39.6112,
      timeZoneIdentifier: "Asia/Riyadh"
    ),
    TVPrayerCity(
      id: "riyadh",
      name: tvLocalized("Riyadh, Saudi Arabia"),
      latitude: 24.7136,
      longitude: 46.6753,
      timeZoneIdentifier: "Asia/Riyadh"
    ),
    TVPrayerCity(
      id: "jeddah",
      name: tvLocalized("Jeddah, Saudi Arabia"),
      latitude: 21.4858,
      longitude: 39.1925,
      timeZoneIdentifier: "Asia/Riyadh"
    ),
    TVPrayerCity(
      id: "dubai",
      name: tvLocalized("Dubai, UAE"),
      latitude: 25.2048,
      longitude: 55.2708,
      timeZoneIdentifier: "Asia/Dubai"
    ),
    TVPrayerCity(
      id: "abu_dhabi",
      name: tvLocalized("Abu Dhabi, UAE"),
      latitude: 24.4539,
      longitude: 54.3773,
      timeZoneIdentifier: "Asia/Dubai"
    ),
    TVPrayerCity(
      id: "doha",
      name: tvLocalized("Doha, Qatar"),
      latitude: 25.2854,
      longitude: 51.531,
      timeZoneIdentifier: "Asia/Qatar"
    ),
    TVPrayerCity(
      id: "kuwait_city",
      name: tvLocalized("Kuwait City, Kuwait"),
      latitude: 29.3759,
      longitude: 47.9774,
      timeZoneIdentifier: "Asia/Kuwait"
    ),
    TVPrayerCity(
      id: "amman",
      name: tvLocalized("Amman, Jordan"),
      latitude: 31.9539,
      longitude: 35.9106,
      timeZoneIdentifier: "Asia/Amman"
    ),
    TVPrayerCity(
      id: "jerusalem",
      name: tvLocalized("Jerusalem"),
      latitude: 31.7683,
      longitude: 35.2137,
      timeZoneIdentifier: "Asia/Jerusalem"
    ),
    TVPrayerCity(
      id: "cairo",
      name: tvLocalized("Cairo, Egypt"),
      latitude: 30.0444,
      longitude: 31.2357,
      timeZoneIdentifier: "Africa/Cairo"
    ),
    TVPrayerCity(
      id: "istanbul",
      name: tvLocalized("Istanbul, Turkey"),
      latitude: 41.0082,
      longitude: 28.9784,
      timeZoneIdentifier: "Europe/Istanbul"
    ),
    TVPrayerCity(
      id: "casablanca",
      name: tvLocalized("Casablanca, Morocco"),
      latitude: 33.5731,
      longitude: -7.5898,
      timeZoneIdentifier: "Africa/Casablanca"
    ),
    TVPrayerCity(
      id: "algiers",
      name: tvLocalized("Algiers, Algeria"),
      latitude: 36.7538,
      longitude: 3.0588,
      timeZoneIdentifier: "Africa/Algiers"
    ),
    TVPrayerCity(
      id: "tunis",
      name: tvLocalized("Tunis, Tunisia"),
      latitude: 36.8065,
      longitude: 10.1815,
      timeZoneIdentifier: "Africa/Tunis"
    ),
    TVPrayerCity(
      id: "lagos",
      name: tvLocalized("Lagos, Nigeria"),
      latitude: 6.5244,
      longitude: 3.3792,
      timeZoneIdentifier: "Africa/Lagos"
    ),
    TVPrayerCity(
      id: "nairobi",
      name: tvLocalized("Nairobi, Kenya"),
      latitude: -1.2921,
      longitude: 36.8219,
      timeZoneIdentifier: "Africa/Nairobi"
    ),
    TVPrayerCity(
      id: "johannesburg",
      name: tvLocalized("Johannesburg, South Africa"),
      latitude: -26.2041,
      longitude: 28.0473,
      timeZoneIdentifier: "Africa/Johannesburg"
    ),
    TVPrayerCity(
      id: "karachi",
      name: tvLocalized("Karachi, Pakistan"),
      latitude: 24.8607,
      longitude: 67.0011,
      timeZoneIdentifier: "Asia/Karachi"
    ),
    TVPrayerCity(
      id: "lahore",
      name: tvLocalized("Lahore, Pakistan"),
      latitude: 31.5204,
      longitude: 74.3587,
      timeZoneIdentifier: "Asia/Karachi"
    ),
    TVPrayerCity(
      id: "islamabad",
      name: tvLocalized("Islamabad, Pakistan"),
      latitude: 33.6844,
      longitude: 73.0479,
      timeZoneIdentifier: "Asia/Karachi"
    ),
    TVPrayerCity(
      id: "delhi",
      name: tvLocalized("Delhi, India"),
      latitude: 28.6139,
      longitude: 77.209,
      timeZoneIdentifier: "Asia/Kolkata"
    ),
    TVPrayerCity(
      id: "mumbai",
      name: tvLocalized("Mumbai, India"),
      latitude: 19.076,
      longitude: 72.8777,
      timeZoneIdentifier: "Asia/Kolkata"
    ),
    TVPrayerCity(
      id: "dhaka",
      name: tvLocalized("Dhaka, Bangladesh"),
      latitude: 23.8103,
      longitude: 90.4125,
      timeZoneIdentifier: "Asia/Dhaka"
    ),
    TVPrayerCity(
      id: "jakarta",
      name: tvLocalized("Jakarta, Indonesia"),
      latitude: -6.2088,
      longitude: 106.8456,
      timeZoneIdentifier: "Asia/Jakarta"
    ),
    TVPrayerCity(
      id: "kuala_lumpur",
      name: tvLocalized("Kuala Lumpur, Malaysia"),
      latitude: 3.139,
      longitude: 101.6869,
      timeZoneIdentifier: "Asia/Kuala_Lumpur"
    ),
    TVPrayerCity(
      id: "singapore",
      name: tvLocalized("Singapore"),
      latitude: 1.3521,
      longitude: 103.8198,
      timeZoneIdentifier: "Asia/Singapore"
    ),
    TVPrayerCity(
      id: "london",
      name: tvLocalized("London, UK"),
      latitude: 51.5072,
      longitude: -0.1276,
      timeZoneIdentifier: "Europe/London"
    ),
    TVPrayerCity(
      id: "paris",
      name: tvLocalized("Paris, France"),
      latitude: 48.8566,
      longitude: 2.3522,
      timeZoneIdentifier: "Europe/Paris"
    ),
    TVPrayerCity(
      id: "berlin",
      name: tvLocalized("Berlin, Germany"),
      latitude: 52.52,
      longitude: 13.405,
      timeZoneIdentifier: "Europe/Berlin"
    ),
    TVPrayerCity(
      id: "amsterdam",
      name: tvLocalized("Amsterdam, Netherlands"),
      latitude: 52.3676,
      longitude: 4.9041,
      timeZoneIdentifier: "Europe/Amsterdam"
    ),
    TVPrayerCity(
      id: "stockholm",
      name: tvLocalized("Stockholm, Sweden"),
      latitude: 59.3293,
      longitude: 18.0686,
      timeZoneIdentifier: "Europe/Stockholm"
    ),
    TVPrayerCity(
      id: "sarajevo",
      name: tvLocalized("Sarajevo, Bosnia and Herzegovina"),
      latitude: 43.8563,
      longitude: 18.4131,
      timeZoneIdentifier: "Europe/Sarajevo"
    ),
    TVPrayerCity(
      id: "toronto",
      name: tvLocalized("Toronto, Canada"),
      latitude: 43.6532,
      longitude: -79.3832,
      timeZoneIdentifier: "America/Toronto"
    ),
    TVPrayerCity(
      id: "montreal",
      name: tvLocalized("Montreal, Canada"),
      latitude: 45.5019,
      longitude: -73.5674,
      timeZoneIdentifier: "America/Toronto"
    ),
    TVPrayerCity(
      id: "vancouver",
      name: tvLocalized("Vancouver, Canada"),
      latitude: 49.2827,
      longitude: -123.1207,
      timeZoneIdentifier: "America/Vancouver"
    ),
    TVPrayerCity(
      id: "new_york",
      name: tvLocalized("New York, USA"),
      latitude: 40.7128,
      longitude: -74.006,
      timeZoneIdentifier: "America/New_York"
    ),
    TVPrayerCity(
      id: "chicago",
      name: tvLocalized("Chicago, USA"),
      latitude: 41.8781,
      longitude: -87.6298,
      timeZoneIdentifier: "America/Chicago"
    ),
    TVPrayerCity(
      id: "houston",
      name: tvLocalized("Houston, USA"),
      latitude: 29.7604,
      longitude: -95.3698,
      timeZoneIdentifier: "America/Chicago"
    ),
    TVPrayerCity(
      id: "los_angeles",
      name: tvLocalized("Los Angeles, USA"),
      latitude: 34.0522,
      longitude: -118.2437,
      timeZoneIdentifier: "America/Los_Angeles"
    ),
    TVPrayerCity(
      id: "sydney",
      name: tvLocalized("Sydney, Australia"),
      latitude: -33.8688,
      longitude: 151.2093,
      timeZoneIdentifier: "Australia/Sydney"
    ),
    TVPrayerCity(
      id: "melbourne",
      name: tvLocalized("Melbourne, Australia"),
      latitude: -37.8136,
      longitude: 144.9631,
      timeZoneIdentifier: "Australia/Melbourne"
    ),
  ]

  /// In the order of the viewer's own alphabet.
  static var sorted: [TVPrayerCity] {
    all.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
  }

  static func city(id: String) -> TVPrayerCity? {
    all.first { $0.id == id }
  }
}
