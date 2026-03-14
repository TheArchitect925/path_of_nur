import Foundation
import UserNotifications

final class WatchNotificationCoordinator: NSObject, UNUserNotificationCenterDelegate {
    static let shared = WatchNotificationCoordinator()

    private let localStore = WatchLocalStore()
    private let stateStore = WatchNotificationStateStore()
    private let policy = PrayerReminderPolicy()
    private let actionHandler = WatchNotificationActionHandler()

    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        center.setNotificationCategories([
            prayerCategory(id: WatchSharedConstants.NotificationCategory.prayerReminder),
            prayerCategory(id: WatchSharedConstants.NotificationCategory.prayerFollowUp),
            dhikrCategory()
        ])
        refreshSchedules()
    }

    func refreshSchedules(now: Date = Date()) {
        let settings = stateStore.settings()
        let prayers = localStore.loadPrayers()
        guard !prayers.isEmpty else { return }

        cancelExpired(now: now)
        scheduleTodayReminders(prayers: prayers, settings: settings, now: now)
    }

    func scheduleSnooze(for prayerId: String, now: Date = Date()) {
        let settings = stateStore.settings()
        let snoozeAt = Calendar.current.date(byAdding: .minute, value: settings.snoozeDurationMinutes, to: now) ?? now
        let dedupStates = stateStore.dedupStates()
        guard policy.shouldAllowSnooze(prayerId: prayerId, snoozeAt: snoozeAt, dedupStates: dedupStates) else { return }
        scheduleNotification(
            prayerId: prayerId,
            kind: .snooze,
            scheduledAt: snoozeAt,
            title: "\(displayName(for: prayerId)) reminder",
            body: "Still pending",
            categoryId: WatchSharedConstants.NotificationCategory.prayerReminder
        )
    }

    func cancelPendingReminders(for prayerId: String) {
        let reminders = stateStore.scheduledReminders()
        let matching = reminders.filter { $0.prayerId == prayerId && $0.status == .scheduled }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: matching.map(\.id))
        var updatedReminders = reminders
        var dedupStates = stateStore.dedupStates()
        for reminder in matching {
            if let index = updatedReminders.firstIndex(where: { $0.id == reminder.id }) {
                updatedReminders[index].status = .cancelled
            }
            if let dedupIndex = dedupStates.firstIndex(where: { $0.dedupKey == reminder.dedupKey }) {
                dedupStates[dedupIndex].lastCancelledAt = Date()
            }
        }
        stateStore.saveScheduledReminders(updatedReminders)
        stateStore.saveDedupStates(dedupStates)
    }

    private func scheduleTodayReminders(prayers: [WatchPrayerStatus], settings: WatchNotificationSettings, now: Date) {
        let dedupStates = stateStore.dedupStates()
        for prayer in prayers {
            if policy.shouldCancel(prayer: prayer) {
                cancelPendingReminders(for: prayer.prayerId)
                continue
            }

            if policy.shouldScheduleInitial(prayer: prayer, now: now, settings: settings, dedupStates: dedupStates) {
                scheduleNotification(
                    prayerId: prayer.prayerId,
                    kind: .initial,
                    scheduledAt: prayer.scheduledTime,
                    title: "\(prayer.displayName) time has begun",
                    body: "Time for \(prayer.displayName)",
                    categoryId: WatchSharedConstants.NotificationCategory.prayerReminder
                )
            }

            if policy.shouldScheduleFollowUp(prayer: prayer, baseTime: prayer.scheduledTime, now: now, settings: settings, dedupStates: dedupStates) {
                let followUpAt = Calendar.current.date(byAdding: .minute, value: settings.followUpDelayMinutes, to: prayer.scheduledTime) ?? prayer.scheduledTime
                scheduleNotification(
                    prayerId: prayer.prayerId,
                    kind: .followUp,
                    scheduledAt: followUpAt,
                    title: "\(prayer.displayName) is still pending",
                    body: "You haven’t logged \(prayer.displayName) yet",
                    categoryId: WatchSharedConstants.NotificationCategory.prayerFollowUp
                )
            }
        }
    }

    private func scheduleNotification(
        prayerId: String,
        kind: WatchNotificationKind,
        scheduledAt: Date,
        title: String,
        body: String,
        categoryId: String
    ) {
        let key = policy.dedupKey(prayerId: prayerId, kind: kind, scheduledAt: scheduledAt)
        let identifier = "watch.\(key)"
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = categoryId
        content.userInfo = [
            "prayerId": prayerId,
            "kind": kind.rawValue
        ]

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduledAt)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        var reminders = stateStore.scheduledReminders()
        reminders.removeAll { $0.id == identifier }
        reminders.append(
            ScheduledPrayerReminder(
                id: identifier,
                prayerId: prayerId,
                date: Calendar.current.startOfDay(for: scheduledAt),
                kind: kind,
                scheduledAt: scheduledAt,
                status: .scheduled,
                dedupKey: key
            )
        )
        stateStore.saveScheduledReminders(reminders)

        var dedup = stateStore.dedupStates()
        if let index = dedup.firstIndex(where: { $0.dedupKey == key }) {
            dedup[index].lastScheduledAt = scheduledAt
            dedup[index].lastCancelledAt = nil
        } else {
            dedup.append(NotificationDedupState(dedupKey: key, lastScheduledAt: scheduledAt, lastFiredAt: nil, lastCancelledAt: nil))
        }
        stateStore.saveDedupStates(dedup)
    }

    private func cancelExpired(now: Date) {
        var reminders = stateStore.scheduledReminders()
        for index in reminders.indices {
            if reminders[index].scheduledAt < now && reminders[index].status == .scheduled {
                reminders[index].status = .expired
            }
        }
        stateStore.saveScheduledReminders(reminders)
    }

    private func prayerCategory(id: String) -> UNNotificationCategory {
        UNNotificationCategory(
            identifier: id,
            actions: [
                UNNotificationAction(identifier: WatchSharedConstants.NotificationAction.markPrayed, title: "Mark prayed"),
                UNNotificationAction(identifier: WatchSharedConstants.NotificationAction.snooze, title: "Snooze"),
                UNNotificationAction(identifier: WatchSharedConstants.NotificationAction.openApp, title: "Open app", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
    }

    private func dhikrCategory() -> UNNotificationCategory {
        UNNotificationCategory(
            identifier: WatchSharedConstants.NotificationCategory.dhikr,
            actions: [
                UNNotificationAction(identifier: WatchSharedConstants.NotificationAction.openDhikr, title: "Open Dhikr", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
    }

    private func displayName(for prayerId: String) -> String {
        switch prayerId {
        case "fajr": return "Fajr"
        case "dhuhr": return "Dhuhr"
        case "asr": return "Asr"
        case "maghrib": return "Maghrib"
        case "isha": return "Isha"
        default: return "Prayer"
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        .list
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let prayerId = response.notification.request.content.userInfo["prayerId"] as? String
        switch response.actionIdentifier {
        case WatchSharedConstants.NotificationAction.markPrayed:
            if let prayerId {
                actionHandler.markPrayed(prayerId: prayerId)
                cancelPendingReminders(for: prayerId)
            }
            logAction(.markPrayed, prayerId: prayerId)
        case WatchSharedConstants.NotificationAction.snooze:
            if let prayerId {
                actionHandler.snooze(prayerId: prayerId)
            }
            logAction(.snooze, prayerId: prayerId)
        case WatchSharedConstants.NotificationAction.openDhikr:
            logAction(.openDhikr, prayerId: nil)
        case WatchSharedConstants.NotificationAction.openApp:
            logAction(.openApp, prayerId: prayerId)
        default:
            logAction(.dismiss, prayerId: prayerId)
        }
    }

    private func logAction(_ action: WatchNotificationActionType, prayerId: String?) {
        stateStore.appendActionLog(
            NotificationActionLog(
                id: UUID().uuidString,
                prayerId: prayerId,
                actionType: action,
                timestamp: Date(),
                source: "watch_notification"
            )
        )
    }
}
