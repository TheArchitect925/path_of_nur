import Foundation

final class WatchNotificationStateStore {
    private let store = WatchLocalStore()

    func settings() -> WatchNotificationSettings {
        store.loadNotificationSettings()
    }

    func saveSettings(_ settings: WatchNotificationSettings) {
        store.saveNotificationSettings(settings)
    }

    func scheduledReminders() -> [ScheduledPrayerReminder] {
        store.loadScheduledReminders()
    }

    func saveScheduledReminders(_ reminders: [ScheduledPrayerReminder]) {
        store.saveScheduledReminders(reminders)
    }

    func dedupStates() -> [NotificationDedupState] {
        store.loadDedupStates()
    }

    func saveDedupStates(_ states: [NotificationDedupState]) {
        store.saveDedupStates(states)
    }

    func actionLogs() -> [NotificationActionLog] {
        store.loadNotificationActionLogs()
    }

    func appendActionLog(_ log: NotificationActionLog) {
        var logs = actionLogs()
        logs.append(log)
        store.saveNotificationActionLogs(logs)
    }
}

