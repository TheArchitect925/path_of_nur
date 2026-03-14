package com.pathofnur.watch.notifications

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.pathofnur.watch.tiles.TileUpdateCoordinator

class WearPrayerReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != WearPrayerNotificationScheduler.ACTION_FIRE_REMINDER) return
        val prayerId = intent.getStringExtra(WearPrayerNotificationScheduler.EXTRA_PRAYER_ID) ?: return
        val kind = intent.getStringExtra(WearPrayerNotificationScheduler.EXTRA_KIND)?.let {
            enumValueOf<com.pathofnur.watch.domain.WatchNotificationKind>(it)
        } ?: com.pathofnur.watch.domain.WatchNotificationKind.Initial
        WearPrayerNotificationScheduler(context).fireReminder(prayerId, kind)
        TileUpdateCoordinator.refreshAll(context)
    }
}

