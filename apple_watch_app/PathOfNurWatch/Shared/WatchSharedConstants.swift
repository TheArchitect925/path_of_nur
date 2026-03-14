import Foundation

enum WatchRoute: String, CaseIterable {
    case today
    case prayers
    case dhikr
    case progress
    case quranAudio
    case quranListening
}

enum WatchSharedConstants {
    static let appGroupId = "group.com.pathofnur.watch"
    static let routeURLScheme = "pathofnurwatch"
    static let notificationDataDidChange = Notification.Name("watch.notificationDataDidChange")

    enum NotificationCategory {
        static let prayerReminder = "watch.prayer.reminder"
        static let prayerFollowUp = "watch.prayer.followUp"
        static let dhikr = "watch.dhikr.reminder"
    }

    enum NotificationAction {
        static let markPrayed = "watch.action.markPrayed"
        static let snooze = "watch.action.snooze"
        static let openApp = "watch.action.openApp"
        static let openDhikr = "watch.action.openDhikr"
    }

    static func routeURL(_ route: WatchRoute) -> URL {
        URL(string: "\(routeURLScheme)://\(route.rawValue)")!
    }
}
