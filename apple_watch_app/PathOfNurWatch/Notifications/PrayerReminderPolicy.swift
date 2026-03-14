import Foundation

struct PrayerReminderPolicy {
    func shouldScheduleInitial(
        prayer: WatchPrayerStatus,
        now: Date,
        settings: WatchNotificationSettings,
        dedupStates: [NotificationDedupState]
    ) -> Bool {
        guard settings.prayerNotificationsEnabled,
              settings.enabledPrayerIds.contains(prayer.prayerId),
              prayer.status == .pending,
              prayer.scheduledTime > now,
              !settings.quietModeEnabled else {
            return false
        }
        let key = dedupKey(prayerId: prayer.prayerId, kind: .initial, scheduledAt: prayer.scheduledTime)
        return !hasLiveDedup(key: key, in: dedupStates)
    }

    func shouldScheduleFollowUp(
        prayer: WatchPrayerStatus,
        baseTime: Date,
        now: Date,
        settings: WatchNotificationSettings,
        dedupStates: [NotificationDedupState]
    ) -> Bool {
        guard settings.prayerNotificationsEnabled,
              settings.followUpReminderEnabled,
              settings.enabledPrayerIds.contains(prayer.prayerId),
              prayer.status == .pending else {
            return false
        }
        let followUpTime = Calendar.current.date(byAdding: .minute, value: settings.followUpDelayMinutes, to: baseTime) ?? baseTime
        guard followUpTime > now else { return false }
        let key = dedupKey(prayerId: prayer.prayerId, kind: .followUp, scheduledAt: followUpTime)
        return !hasLiveDedup(key: key, in: dedupStates)
    }

    func shouldAllowSnooze(
        prayerId: String,
        snoozeAt: Date,
        dedupStates: [NotificationDedupState]
    ) -> Bool {
        let key = dedupKey(prayerId: prayerId, kind: .snooze, scheduledAt: snoozeAt)
        return !hasLiveDedup(key: key, in: dedupStates)
    }

    func shouldCancel(prayer: WatchPrayerStatus) -> Bool {
        prayer.status == .completed
    }

    func dedupKey(prayerId: String, kind: WatchNotificationKind, scheduledAt: Date) -> String {
        let stamp = ISO8601DateFormatter().string(from: scheduledAt)
        return "\(prayerId)|\(kind.rawValue)|\(stamp)"
    }

    private func hasLiveDedup(key: String, in states: [NotificationDedupState]) -> Bool {
        states.contains(where: { $0.dedupKey == key && $0.lastCancelledAt == nil })
    }
}

