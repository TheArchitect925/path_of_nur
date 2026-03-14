package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.WatchPrayerStatus

@Composable
fun PrayersScreen(
    prayers: List<WatchPrayerStatus>,
    onToggle: (String) -> Unit,
    onBack: () -> Unit
) {
    prayers.forEach { prayer ->
        Chip(
            onClick = { onToggle(prayer.prayerId) },
            label = { Text("${prayer.displayName} • ${prayer.scheduledTimeLabel}") },
            secondaryLabel = { Text(prayer.status.name) }
        )
    }
    Chip(onClick = onBack, label = { Text("Back") })
}
