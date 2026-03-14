import Foundation

final class TVHomeViewModel: ObservableObject {
    let greeting = "Assalāmu ʿalaykum"
    let subtitle = "A calm companion for prayer, learning, and remembrance in the home."
    let dateLabel = "Saturday, March 14"
    let hijriLabel = "14 Ramaḍān 1447"
    let currentPrayer = "Dhuhr"
    let nextPrayer = "Asr in 2h 14m"
    let quickLinks = TVSeedContent.quickLinks
    let shelves = TVSeedContent.featuredShelves
}

final class TVPrayerViewModel: ObservableObject {
    let title = "Prayer Today"
    let subtitle = "Large, readable timings for the home."
    let prayers = TVSeedContent.prayerSummaries
    let currentStateLabel = "Dhuhr is active"
    let nextStateLabel = "Asr begins at 4:42 PM"
}

final class TVDhikrViewModel: ObservableObject {
    let phrase = "SubḥānAllāh"
    let transliteration = "SubhanAllah"
    let translation = "Glory be to Allah"
    let subtitle = "A calm ambient display for remembrance in the home."
}

final class TVLearnViewModel: ObservableObject {
    let shelves = TVSeedContent.featuredShelves
}

final class TVProphetsViewModel: ObservableObject {
    let shelf = TVSeedContent.featuredShelves.first(where: { $0.id == "prophets" }) ?? TVShelfSection(id: "empty", title: "Prophets", subtitle: "", items: [])
}

final class TVLibraryViewModel: ObservableObject {
    let items = TVSeedContent.audioItems
}

final class TVProgressViewModel: ObservableObject {
    let summary = TVSeedContent.progressSummary
}

final class TVSettingsViewModel: ObservableObject {
    let options = TVSeedContent.settings
}
