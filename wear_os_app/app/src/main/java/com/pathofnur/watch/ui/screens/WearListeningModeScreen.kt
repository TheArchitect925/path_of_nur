package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
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
        Text(stringResource(R.string.quran_ayah, it))
    }
    Button(
        onClick = { onCommand(if (snapshot.isPlaying) QuranPlaybackCommand.Pause else QuranPlaybackCommand.Play) },
        enabled = WearListeningModeController.remoteCommandsEnabled(snapshot, phoneReachable)
    ) {
        Text(stringResource(if (snapshot.isPlaying) R.string.action_pause else R.string.action_play))
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
    Text(stringResource(WearListeningModeController.statusTextRes(snapshot, phoneReachable)))
    Chip(onClick = onPlayer, label = { Text(stringResource(R.string.quran_return_to_player)) })
}
