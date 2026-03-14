import Foundation

final class WatchLocalStore {
    private let defaults = UserDefaults(suiteName: WatchSharedConstants.appGroupId) ?? UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Key {
        static let snapshot = "watch.snapshot"
        static let prayers = "watch.prayers"
        static let dhikr = "watch.dhikr"
        static let queue = "watch.queue"
        static let quranPlayback = "watch.quran.playback"
        static let quranAvailability = "watch.quran.availability"
        static let notificationSettings = "watch.notification.settings"
        static let scheduledReminders = "watch.notification.scheduled"
        static let actionLogs = "watch.notification.logs"
        static let dedupStates = "watch.notification.dedup"
    }

    func loadSnapshot() -> WatchDaySnapshot? {
        decode(WatchDaySnapshot.self, key: Key.snapshot)
    }

    func saveSnapshot(_ snapshot: WatchDaySnapshot) {
        encode(snapshot, key: Key.snapshot)
    }

    func loadPrayers() -> [WatchPrayerStatus] {
        decode([WatchPrayerStatus].self, key: Key.prayers) ?? []
    }

    func savePrayers(_ prayers: [WatchPrayerStatus]) {
        encode(prayers, key: Key.prayers)
    }

    func loadDhikr() -> WatchDhikrSession? {
        decode(WatchDhikrSession.self, key: Key.dhikr)
    }

    func saveDhikr(_ session: WatchDhikrSession) {
        encode(session, key: Key.dhikr)
    }

    func loadQueue() -> [WatchSyncQueueItem] {
        decode([WatchSyncQueueItem].self, key: Key.queue) ?? []
    }

    func saveQueue(_ queue: [WatchSyncQueueItem]) {
        encode(queue, key: Key.queue)
    }

    func loadQuranPlayback() -> WatchQuranPlaybackSnapshot? {
        decode(WatchQuranPlaybackSnapshot.self, key: Key.quranPlayback)
    }

    func saveQuranPlayback(_ snapshot: WatchQuranPlaybackSnapshot) {
        encode(snapshot, key: Key.quranPlayback)
    }

    func loadQuranAvailability() -> WatchAudioAvailabilitySnapshot? {
        decode(WatchAudioAvailabilitySnapshot.self, key: Key.quranAvailability)
    }

    func saveQuranAvailability(_ snapshot: WatchAudioAvailabilitySnapshot) {
        encode(snapshot, key: Key.quranAvailability)
    }

    func loadNotificationSettings() -> WatchNotificationSettings {
        decode(WatchNotificationSettings.self, key: Key.notificationSettings) ?? .default
    }

    func saveNotificationSettings(_ settings: WatchNotificationSettings) {
        encode(settings, key: Key.notificationSettings)
    }

    func loadScheduledReminders() -> [ScheduledPrayerReminder] {
        decode([ScheduledPrayerReminder].self, key: Key.scheduledReminders) ?? []
    }

    func saveScheduledReminders(_ reminders: [ScheduledPrayerReminder]) {
        encode(reminders, key: Key.scheduledReminders)
    }

    func loadNotificationActionLogs() -> [NotificationActionLog] {
        decode([NotificationActionLog].self, key: Key.actionLogs) ?? []
    }

    func saveNotificationActionLogs(_ logs: [NotificationActionLog]) {
        encode(logs, key: Key.actionLogs)
    }

    func loadDedupStates() -> [NotificationDedupState] {
        decode([NotificationDedupState].self, key: Key.dedupStates) ?? []
    }

    func saveDedupStates(_ states: [NotificationDedupState]) {
        encode(states, key: Key.dedupStates)
    }

    private func encode<T: Encodable>(_ value: T, key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    private func decode<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}
