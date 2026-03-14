package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.WatchDaySnapshot
import com.pathofnur.watch.domain.WatchSyncQueueItem
import com.pathofnur.watch.ui.components.WatchStatCard

@Composable
fun ProgressScreen(
    snapshot: WatchDaySnapshot,
    queue: List<WatchSyncQueueItem>,
    onBack: () -> Unit
) {
    WatchStatCard("Prayers", "${snapshot.completedPrayerCount}/${snapshot.totalPrayerCount}")
    WatchStatCard("Dhikr", "${snapshot.dhikrTodayCount}")
    WatchStatCard("Streak", "${snapshot.streakDays}")
    WatchStatCard("XP", "${snapshot.xpToday}")
    WatchStatCard("Ocean Drops", "${snapshot.oceanDropsToday}")
    WatchStatCard("Sync", if (queue.isEmpty()) "Up to date" else "Pending ${queue.size}")
    Chip(onClick = onBack, label = { Text("Back") })
}
