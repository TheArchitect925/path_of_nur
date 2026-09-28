package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
import com.pathofnur.watch.domain.PrayerState
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
            // Was prayer.status.name, which printed the raw Kotlin enum constant.
            secondaryLabel = {
                Text(
                    stringResource(
                        when (prayer.status) {
                            PrayerState.Completed -> R.string.prayer_status_completed
                            PrayerState.Pending -> R.string.prayer_status_pending
                        }
                    )
                )
            }
        )
    }
    Chip(onClick = onBack, label = { Text(stringResource(R.string.action_back)) })
}
