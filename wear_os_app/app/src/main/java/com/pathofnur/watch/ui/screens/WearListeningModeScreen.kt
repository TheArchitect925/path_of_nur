package com.pathofnur.watch.ui.screens

import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.quran.WearListeningModeController

@Composable
fun WearListeningModeScreen(
    snapshot: QuranPlaybackSnapshot,
    phoneReachable: Boolean,
    onCommand: (QuranPlaybackCommand) -> Unit,
    onPlayer: () -> Unit
) {
    Text(snapshot.surahName)
    Text(snapshot.reciterName)
    snapshot.currentAyah?.let {
        Text("Ayah $it")
    }
    Button(
        onClick = { onCommand(if (snapshot.isPlaying) QuranPlaybackCommand.Pause else QuranPlaybackCommand.Play) },
        enabled = WearListeningModeController.remoteCommandsEnabled(snapshot, phoneReachable)
    ) {
        Text(if (snapshot.isPlaying) "Pause" else "Play")
    }
    Chip(
        onClick = { onCommand(QuranPlaybackCommand.Previous) },
        enabled = WearListeningModeController.remoteCommandsEnabled(snapshot, phoneReachable),
        label = { Text("<<") }
    )
    Chip(
        onClick = { onCommand(QuranPlaybackCommand.Next) },
        enabled = WearListeningModeController.remoteCommandsEnabled(snapshot, phoneReachable),
        label = { Text(">>") }
    )
    Text(WearListeningModeController.statusText(snapshot, phoneReachable))
    Chip(onClick = onPlayer, label = { Text("Return to Player") })
}
