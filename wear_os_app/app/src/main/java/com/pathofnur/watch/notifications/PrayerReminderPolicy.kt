package com.pathofnur.watch.notifications

import com.pathofnur.watch.domain.NotificationDedupState
import com.pathofnur.watch.domain.WatchNotificationKind
import com.pathofnur.watch.domain.WatchNotificationSettings
import com.pathofnur.watch.domain.WatchPrayerStatus
import com.pathofnur.watch.domain.PrayerState
import java.time.Instant

class PrayerReminderPolicy {
    fun shouldScheduleInitial(
        prayer: WatchPrayerStatus,
        scheduledAt: Instant,
        now: Instant,
        settings: WatchNotificationSettings,
        dedupStates: List<NotificationDedupState>
    ): Boolean {
        if (!settings.prayerNotificationsEnabled || settings.quietModeEnabled) return false
        if (prayer.status == PrayerState.Completed) return false
        if (!settings.enabledPrayerIds.contains(prayer.prayerId)) return false
        if (!scheduledAt.isAfter(now)) return false
        return !hasLiveDedup(dedupKey(prayer.prayerId, WatchNotificationKind.Initial, scheduledAt), dedupStates)
    }

    fun shouldScheduleFollowUp(
        prayer: WatchPrayerStatus,
        followUpAt: Instant,
        settings: WatchNotificationSettings,
        now: Instant,
        dedupStates: List<NotificationDedupState>
    ): Boolean {
        if (!settings.prayerNotificationsEnabled || !settings.followUpReminderEnabled) return false
        if (prayer.status == PrayerState.Completed) return false
        if (!settings.enabledPrayerIds.contains(prayer.prayerId)) return false
        if (!followUpAt.isAfter(now)) return false
        return !hasLiveDedup(dedupKey(prayer.prayerId, WatchNotificationKind.FollowUp, followUpAt), dedupStates)
    }

    fun shouldAllowSnooze(prayerId: String, snoozeAt: Instant, dedupStates: List<NotificationDedupState>): Boolean {
        return !hasLiveDedup(dedupKey(prayerId, WatchNotificationKind.Snooze, snoozeAt), dedupStates)
    }

    fun dedupKey(prayerId: String, kind: WatchNotificationKind, scheduledAt: Instant): String {
        return "$prayerId|${kind.name}|${scheduledAt.toEpochMilli()}"
    }

    private fun hasLiveDedup(key: String, states: List<NotificationDedupState>): Boolean {
        return states.any { it.dedupKey == key && it.lastCancelledAt == null }
    }
}

