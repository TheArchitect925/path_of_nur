package com.pathofnur.watch.notifications

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.pathofnur.watch.tiles.TileUpdateCoordinator

class WearNotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        WearPrayerNotificationScheduler(context).handleAction(
            action = intent.action.orEmpty(),
            prayerId = intent.getStringExtra(WearPrayerNotificationScheduler.EXTRA_PRAYER_ID)
        )
        TileUpdateCoordinator.refreshAll(context)
    }
}

