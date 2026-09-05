package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
import com.pathofnur.watch.domain.WatchDaySnapshot
import com.pathofnur.watch.domain.WatchSyncQueueItem
import com.pathofnur.watch.ui.components.WatchStatCard

@Composable
fun ProgressScreen(
    snapshot: WatchDaySnapshot,
    queue: List<WatchSyncQueueItem>,
    onBack: () -> Unit
) {
    WatchStatCard(stringResource(R.string.label_prayers), "${snapshot.completedPrayerCount}/${snapshot.totalPrayerCount}")
    WatchStatCard(stringResource(R.string.label_dhikr), "${snapshot.dhikrTodayCount}")
    WatchStatCard(stringResource(R.string.label_streak), "${snapshot.streakDays}")
    WatchStatCard(stringResource(R.string.label_xp), "${snapshot.xpToday}")
    WatchStatCard(stringResource(R.string.label_ocean_drops), "${snapshot.oceanDropsToday}")
    WatchStatCard(
        stringResource(R.string.label_sync),
        if (queue.isEmpty()) {
            stringResource(R.string.sync_up_to_date)
        } else {
            stringResource(R.string.sync_pending, queue.size)
        }
    )
    Chip(onClick = onBack, label = { Text(stringResource(R.string.action_back)) })
}
