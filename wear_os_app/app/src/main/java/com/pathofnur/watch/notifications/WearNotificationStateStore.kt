package com.pathofnur.watch.notifications

import android.content.Context
import com.pathofnur.watch.domain.NotificationActionLog
import com.pathofnur.watch.domain.NotificationDedupState
import com.pathofnur.watch.domain.ScheduledPrayerReminder
import com.pathofnur.watch.domain.WatchNotificationSettings
import java.time.Instant

class WearNotificationStateStore(context: Context) {
    private val prefs = context.getSharedPreferences("path_of_nur_watch_notifications", Context.MODE_PRIVATE)

    fun settings(): WatchNotificationSettings = WatchNotificationSettings(
        prayerNotificationsEnabled = prefs.getBoolean("prayerNotificationsEnabled", WatchNotificationSettings.Default.prayerNotificationsEnabled),
        enabledPrayerIds = prefs.getStringSet("enabledPrayerIds", WatchNotificationSettings.Default.enabledPrayerIds.toSet())!!.toList(),
        followUpReminderEnabled = prefs.getBoolean("followUpReminderEnabled", WatchNotificationSettings.Default.followUpReminderEnabled),
        followUpDelayMinutes = prefs.getInt("followUpDelayMinutes", WatchNotificationSettings.Default.followUpDelayMinutes),
        snoozeDurationMinutes = prefs.getInt("snoozeDurationMinutes", WatchNotificationSettings.Default.snoozeDurationMinutes),
        quietModeEnabled = prefs.getBoolean("quietModeEnabled", WatchNotificationSettings.Default.quietModeEnabled),
        dhikrReminderEnabled = prefs.getBoolean("dhikrReminderEnabled", WatchNotificationSettings.Default.dhikrReminderEnabled)
    )

    fun scheduledReminders(): List<ScheduledPrayerReminder> = emptyList()

    fun saveScheduledReminders(reminders: List<ScheduledPrayerReminder>) {
        val ids = reminders.joinToString("|") {
            listOf(it.id, it.prayerId, it.date, it.kind.name, it.scheduledAt.toEpochMilli().toString(), it.status.name, it.dedupKey)
                .joinToString("~")
        }
        prefs.edit().putString("scheduledReminders", ids).apply()
    }

    fun loadScheduledReminders(): List<ScheduledPrayerReminder> {
        val raw = prefs.getString("scheduledReminders", "") ?: ""
        if (raw.isBlank()) return emptyList()
        return raw.split("|").mapNotNull { line ->
            val parts = line.split("~")
            if (parts.size != 7) return@mapNotNull null
            ScheduledPrayerReminder(
                id = parts[0],
                prayerId = parts[1],
                date = parts[2],
                kind = enumValueOf(parts[3]),
                scheduledAt = Instant.ofEpochMilli(parts[4].toLong()),
                status = enumValueOf(parts[5]),
                dedupKey = parts[6]
            )
        }
    }

    fun loadDedupStates(): List<NotificationDedupState> {
        val raw = prefs.getString("dedupStates", "") ?: ""
        if (raw.isBlank()) return emptyList()
        return raw.split("|").mapNotNull { line ->
            val parts = line.split("~")
            if (parts.isEmpty()) return@mapNotNull null
            NotificationDedupState(
                dedupKey = parts[0],
                lastScheduledAt = parts.getOrNull(1)?.takeIf { it.isNotBlank() }?.let { Instant.ofEpochMilli(it.toLong()) },
                lastFiredAt = parts.getOrNull(2)?.takeIf { it.isNotBlank() }?.let { Instant.ofEpochMilli(it.toLong()) },
                lastCancelledAt = parts.getOrNull(3)?.takeIf { it.isNotBlank() }?.let { Instant.ofEpochMilli(it.toLong()) }
            )
        }
    }

    fun saveDedupStates(states: List<NotificationDedupState>) {
        val raw = states.joinToString("|") {
            listOf(
                it.dedupKey,
                it.lastScheduledAt?.toEpochMilli()?.toString().orEmpty(),
                it.lastFiredAt?.toEpochMilli()?.toString().orEmpty(),
                it.lastCancelledAt?.toEpochMilli()?.toString().orEmpty()
            ).joinToString("~")
        }
        prefs.edit().putString("dedupStates", raw).apply()
    }

    fun appendActionLog(log: NotificationActionLog) {
        val existing = prefs.getString("actionLogs", "") ?: ""
        val next = listOf(log.id, log.prayerId.orEmpty(), log.actionType.name, log.timestamp.toEpochMilli().toString(), log.source).joinToString("~")
        prefs.edit().putString("actionLogs", listOf(existing, next).filter { it.isNotBlank() }.joinToString("|")).apply()
    }
}

