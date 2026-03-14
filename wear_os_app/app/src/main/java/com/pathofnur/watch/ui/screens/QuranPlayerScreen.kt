package com.pathofnur.watch.ui.screens

import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.WatchAudioAvailabilitySnapshot
import com.pathofnur.watch.ui.components.WatchStatCard

@Composable
fun QuranPlayerScreen(
    snapshot: QuranPlaybackSnapshot,
    availability: WatchAudioAvailabilitySnapshot,
    onCommand: (QuranPlaybackCommand) -> Unit,
    onOutput: () -> Unit,
    onListeningMode: () -> Unit,
    onBack: () -> Unit
) {
    WatchStatCard("Qur’an Audio", snapshot.surahName)
    Text(snapshot.reciterName)
    Text(if (snapshot.sourceType.name == "Phone") "Playing on: Phone" else "Playing on: Watch")
    if (!snapshot.isPlaying) {
        Chip(onClick = { onCommand(QuranPlaybackCommand.ResumeLast) }, label = { Text("Resume Last Recitation") })
    }
    Button(onClick = { onCommand(QuranPlaybackCommand.Previous) }) { Text("<<") }
    Button(onClick = { onCommand(if (snapshot.isPlaying) QuranPlaybackCommand.Pause else QuranPlaybackCommand.Play) }) {
        Text(if (snapshot.isPlaying) "Pause" else "Play")
    }
    Button(onClick = { onCommand(QuranPlaybackCommand.Next) }) { Text(">>") }
    Chip(onClick = onOutput, label = { Text("Switch Output") })
    if (snapshot.isPlaying || snapshot.positionSeconds > 0) {
        Chip(onClick = onListeningMode, label = { Text("Listening Mode") })
    }
    if (!availability.watchPlaybackAvailable && snapshot.sourceType.name == "Watch") {
        Text("Watch playback requires downloaded audio.")
    }
    Chip(onClick = onBack, label = { Text("Back") })
}
