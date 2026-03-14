package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.WatchDaySnapshot
import com.pathofnur.watch.ui.components.WatchStatCard

@Composable
fun TodayScreen(
    snapshot: WatchDaySnapshot,
    onPrayers: () -> Unit,
    onDhikr: () -> Unit,
    onProgress: () -> Unit,
    onQuran: () -> Unit
) {
    WatchStatCard("Next Prayer", snapshot.nextPrayerId.replaceFirstChar { it.titlecase() } + " • " + snapshot.nextPrayerTimeLabel)
    WatchStatCard("Prayers", "${snapshot.completedPrayerCount}/${snapshot.totalPrayerCount}")
    WatchStatCard("Dhikr", "${snapshot.dhikrTodayCount}")
    WatchStatCard("Streak", "${snapshot.streakDays}")
    Chip(onClick = onPrayers, label = { Text("Prayers") })
    Chip(onClick = onDhikr, label = { Text("Dhikr") })
    Chip(onClick = onQuran, label = { Text("Qur’an Audio") })
    Chip(onClick = onProgress, label = { Text("Progress") })
}
