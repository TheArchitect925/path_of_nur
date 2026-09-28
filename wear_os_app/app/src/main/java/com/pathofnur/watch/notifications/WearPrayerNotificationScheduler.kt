package com.pathofnur.watch.notifications

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.pathofnur.watch.MainActivity
import com.pathofnur.watch.R
import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.domain.NotificationActionLog
import com.pathofnur.watch.domain.NotificationDedupState
import com.pathofnur.watch.domain.ScheduledPrayerReminder
import com.pathofnur.watch.domain.WatchNotificationActionType
import com.pathofnur.watch.domain.WatchNotificationKind
import com.pathofnur.watch.domain.WatchReminderStatus
import com.pathofnur.watch.tiles.TileRoutes
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.util.UUID

class WearPrayerNotificationScheduler(private val context: Context) {
    private val appContext = context.applicationContext
    private val repository = WatchRepository(appContext)
    private val stateStore = WearNotificationStateStore(appContext)
    private val policy = PrayerReminderPolicy()
    private val alarmManager = appContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    fun configure() {
        val manager = appContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_PRAYER,
                appContext.getString(R.string.notif_channel_name),
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = appContext.getString(R.string.notif_channel_description)
            }
        )
    }

    fun refreshSchedules(now: Instant = Instant.now()) {
        configure()
        cancelExpired(now)
        val settings = stateStore.settings()
        val prayers = repository.prayers()
        val dedupStates = stateStore.loadDedupStates()
        prayers.forEach { prayer ->
            val scheduledAt = repository.instantForPrayer(prayer.prayerId) ?: return@forEach
            if (prayer.status.name == "Completed") {
                cancelPendingForPrayer(prayer.prayerId)
                return@forEach
            }
            if (policy.shouldScheduleInitial(prayer, scheduledAt, now, settings, dedupStates)) {
                schedule(
                    prayer.prayerId,
                    WatchNotificationKind.Initial,
                    scheduledAt,
                    appContext.getString(R.string.notif_initial_title, prayer.displayName),
                    appContext.getString(R.string.notif_initial_body, prayer.displayName)
                )
            }
            val followUpAt = scheduledAt.plusSeconds((settings.followUpDelayMinutes * 60).toLong())
            if (policy.shouldScheduleFollowUp(prayer, followUpAt, settings, now, dedupStates)) {
                schedule(
                    prayer.prayerId,
                    WatchNotificationKind.FollowUp,
                    followUpAt,
                    appContext.getString(R.string.notif_followup_title, prayer.displayName),
                    appContext.getString(R.string.notif_followup_body, prayer.displayName)
                )
            }
        }
    }

    fun scheduleSnooze(prayerId: String) {
        val settings = stateStore.settings()
        val snoozeAt = Instant.now().plusSeconds((settings.snoozeDurationMinutes * 60).toLong())
        if (!policy.shouldAllowSnooze(prayerId, snoozeAt, stateStore.loadDedupStates())) return
        schedule(
            prayerId,
            WatchNotificationKind.Snooze,
            snoozeAt,
            appContext.getString(R.string.notif_snooze_title, displayName(prayerId)),
            appContext.getString(R.string.notif_snooze_body)
        )
    }

    fun cancelPendingForPrayer(prayerId: String) {
        val reminders = stateStore.loadScheduledReminders()
        val matching = reminders.filter { it.prayerId == prayerId && it.status == WatchReminderStatus.Scheduled }
        matching.forEach {
            alarmManager.cancel(pendingReminderIntent(it.id))
        }
        val updated = reminders.map {
            if (it.prayerId == prayerId && it.status == WatchReminderStatus.Scheduled) it.copy(status = WatchReminderStatus.Cancelled) else it
        }
        stateStore.saveScheduledReminders(updated)
        val dedup = stateStore.loadDedupStates().map {
            if (matching.any { reminder -> reminder.dedupKey == it.dedupKey }) it.copy(lastCancelledAt = Instant.now()) else it
        }
        stateStore.saveDedupStates(dedup)
    }

    fun fireReminder(prayerId: String, kind: WatchNotificationKind) {
        val prayer = repository.prayers().firstOrNull { it.prayerId == prayerId } ?: return
        if (prayer.status.name == "Completed") {
            cancelPendingForPrayer(prayerId)
            return
        }
        val title = when (kind) {
            WatchNotificationKind.Initial -> appContext.getString(R.string.notif_initial_title, prayer.displayName)
            WatchNotificationKind.FollowUp -> appContext.getString(R.string.notif_followup_title, prayer.displayName)
            WatchNotificationKind.Snooze -> appContext.getString(R.string.notif_snooze_title, prayer.displayName)
            WatchNotificationKind.Dhikr -> appContext.getString(R.string.notif_dhikr_body)
        }
        val body = when (kind) {
            WatchNotificationKind.Initial -> appContext.getString(R.string.notif_initial_body, prayer.displayName)
            WatchNotificationKind.FollowUp, WatchNotificationKind.Snooze -> appContext.getString(R.string.notif_mark_or_snooze)
            WatchNotificationKind.Dhikr -> appContext.getString(R.string.notif_open_dhikr)
        }

        NotificationManagerCompat.from(appContext).notify(
            notificationId(prayerId, kind),
            NotificationCompat.Builder(appContext, CHANNEL_PRAYER)
                .setSmallIcon(R.drawable.ic_watch_placeholder)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setContentIntent(openAppIntent(TileRoutes.SCREEN_TODAY))
                .addAction(0, appContext.getString(R.string.notif_action_mark_prayed), actionIntent(ACTION_MARK_PRAYED, prayerId))
                .addAction(0, appContext.getString(R.string.notif_action_snooze), actionIntent(ACTION_SNOOZE, prayerId))
                .addAction(0, appContext.getString(R.string.notif_action_open_app), openAppIntent(TileRoutes.SCREEN_TODAY))
                .build()
        )
    }

    fun handleAction(action: String, prayerId: String?) {
        when (action) {
            ACTION_MARK_PRAYED -> {
                prayerId?.let { repository.markPrayerCompleted(it) }
                prayerId?.let { cancelPendingForPrayer(it) }
                logAction(WatchNotificationActionType.MarkPrayed, prayerId)
            }
            ACTION_SNOOZE -> {
                prayerId?.let { scheduleSnooze(it) }
                logAction(WatchNotificationActionType.Snooze, prayerId)
            }
            ACTION_OPEN_DHIKR -> logAction(WatchNotificationActionType.OpenDhikr, null)
            else -> logAction(WatchNotificationActionType.OpenApp, prayerId)
        }
    }

    private fun schedule(prayerId: String, kind: WatchNotificationKind, at: Instant, title: String, body: String) {
        val id = "watch_${policy.dedupKey(prayerId, kind, at)}"
        alarmManager.setAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            at.toEpochMilli(),
            pendingReminderIntent(id, prayerId, kind, title, body)
        )
        val reminder = ScheduledPrayerReminder(
            id = id,
            prayerId = prayerId,
            date = LocalDate.now(ZoneId.systemDefault()).toString(),
            kind = kind,
            scheduledAt = at,
            status = WatchReminderStatus.Scheduled,
            dedupKey = policy.dedupKey(prayerId, kind, at)
        )
        val reminders = stateStore.loadScheduledReminders().filterNot { it.id == id } + reminder
        stateStore.saveScheduledReminders(reminders)
        val dedup = stateStore.loadDedupStates().filterNot { it.dedupKey == reminder.dedupKey } +
            NotificationDedupState(reminder.dedupKey, at, null, null)
        stateStore.saveDedupStates(dedup)
    }

    private fun cancelExpired(now: Instant) {
        val updated = stateStore.loadScheduledReminders().map {
            if (it.status == WatchReminderStatus.Scheduled && it.scheduledAt.isBefore(now.minusSeconds(3600))) {
                it.copy(status = WatchReminderStatus.Expired)
            } else {
                it
            }
        }
        stateStore.saveScheduledReminders(updated)
    }

    private fun pendingReminderIntent(
        id: String,
        prayerId: String = "",
        kind: WatchNotificationKind = WatchNotificationKind.Initial,
        title: String = "",
        body: String = ""
    ): PendingIntent {
        val intent = Intent(appContext, WearPrayerReminderReceiver::class.java).apply {
            action = ACTION_FIRE_REMINDER
            putExtra(EXTRA_ID, id)
            putExtra(EXTRA_PRAYER_ID, prayerId)
            putExtra(EXTRA_KIND, kind.name)
            putExtra(EXTRA_TITLE, title)
            putExtra(EXTRA_BODY, body)
        }
        return PendingIntent.getBroadcast(appContext, id.hashCode(), intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun actionIntent(action: String, prayerId: String?): PendingIntent {
        val intent = Intent(appContext, WearNotificationActionReceiver::class.java).apply {
            this.action = action
            putExtra(EXTRA_PRAYER_ID, prayerId)
        }
        return PendingIntent.getBroadcast(appContext, "${action}_${prayerId.orEmpty()}".hashCode(), intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun openAppIntent(screen: String): PendingIntent {
        val intent = Intent(appContext, MainActivity::class.java).apply {
            putExtra(TileRoutes.EXTRA_SCREEN, screen)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(appContext, screen.hashCode(), intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun notificationId(prayerId: String, kind: WatchNotificationKind): Int = "${prayerId}_${kind.name}".hashCode()

    private fun displayName(prayerId: String): String = repository.prayers().firstOrNull { it.prayerId == prayerId }?.displayName ?: appContext.getString(R.string.prayer_fallback_name)

    private fun logAction(action: WatchNotificationActionType, prayerId: String?) {
        stateStore.appendActionLog(
            NotificationActionLog(
                id = UUID.randomUUID().toString(),
                prayerId = prayerId,
                actionType = action,
                timestamp = Instant.now(),
                source = "watch_notification"
            )
        )
    }

    companion object {
        const val CHANNEL_PRAYER = "path_of_nur_prayer"
        const val ACTION_FIRE_REMINDER = "com.pathofnur.watch.notification.FIRE"
        const val ACTION_MARK_PRAYED = "com.pathofnur.watch.notification.MARK_PRAYED"
        const val ACTION_SNOOZE = "com.pathofnur.watch.notification.SNOOZE"
        const val ACTION_OPEN_DHIKR = "com.pathofnur.watch.notification.OPEN_DHIKR"
        const val EXTRA_ID = "id"
        const val EXTRA_PRAYER_ID = "prayerId"
        const val EXTRA_KIND = "kind"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
    }
}

