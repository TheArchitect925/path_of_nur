package com.pathofnur.watch.ui.screens

import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.QuranPlaybackSourceType
import com.pathofnur.watch.domain.WatchAudioAvailabilitySnapshot

@Composable
fun QuranOutputScreen(
    currentSource: QuranPlaybackSourceType,
    availability: WatchAudioAvailabilitySnapshot,
    onSelectPhone: () -> Unit,
    onSelectWatch: () -> Unit,
    onBack: () -> Unit
) {
    Text("Output")
    Chip(onClick = onSelectPhone, label = { Text(if (currentSource == QuranPlaybackSourceType.Phone) "Phone / Device ✓" else "Phone / Device") })
    Chip(
        onClick = onSelectWatch,
        enabled = availability.watchPlaybackAvailable,
        label = { Text(if (currentSource == QuranPlaybackSourceType.Watch) "Watch ✓" else "Watch") }
    )
    if (!availability.watchPlaybackAvailable) {
        Text("Watch playback requires downloaded audio.")
    }
    Chip(onClick = onBack, label = { Text("Back") })
}
