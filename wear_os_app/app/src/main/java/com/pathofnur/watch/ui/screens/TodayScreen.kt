package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
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
    WatchStatCard(
        stringResource(R.string.label_next_prayer),
        snapshot.nextPrayerId.replaceFirstChar { it.titlecase() } + " • " + snapshot.nextPrayerTimeLabel
    )
    WatchStatCard(stringResource(R.string.label_prayers), "${snapshot.completedPrayerCount}/${snapshot.totalPrayerCount}")
    WatchStatCard(stringResource(R.string.label_dhikr), "${snapshot.dhikrTodayCount}")
    WatchStatCard(stringResource(R.string.label_streak), "${snapshot.streakDays}")
    Chip(onClick = onPrayers, label = { Text(stringResource(R.string.label_prayers)) })
    Chip(onClick = onDhikr, label = { Text(stringResource(R.string.label_dhikr)) })
    Chip(onClick = onQuran, label = { Text(stringResource(R.string.label_quran_audio)) })
    Chip(onClick = onProgress, label = { Text(stringResource(R.string.label_progress)) })
}
