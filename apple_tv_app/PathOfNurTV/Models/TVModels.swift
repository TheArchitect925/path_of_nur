import SwiftUI

enum TVTab: Hashable {
    case home
    case prayer
    case dhikr
    case learn
    case library
    case progress
    case settings
}

enum TVPrayerState {
    case current
    case upcoming
    case completed
}

struct TVPrayerSummary: Identifiable, Hashable {
    let id: String
    let name: String
    let arabicName: String
    let timeLabel: String
    let state: TVPrayerState
}

struct TVQuickLink: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let destinationTab: TVTab
}

struct TVShelfItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let eyebrow: String
    let systemImage: String
    let detailBody: String
    let reference: String?
}

struct TVShelfSection: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let items: [TVShelfItem]
}

struct TVAudioItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let detail: String
    let durationLabel: String
    let systemImage: String
}

struct TVProgressSummary: Hashable {
    let prayerStreak: Int
    let learningSessions: Int
    let oceanDrops: Int
    let reflectionCount: Int
    let completionRing: Double
}

struct TVSettingsOption: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let valueLabel: String
}
