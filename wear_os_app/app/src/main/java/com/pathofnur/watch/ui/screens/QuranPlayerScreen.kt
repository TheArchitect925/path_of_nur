package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.QuranPlaybackSourceType
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
    WatchStatCard(stringResource(R.string.label_quran_audio), snapshot.surahName)
    Text(snapshot.reciterName)
    Text(
        stringResource(
            if (snapshot.sourceType == QuranPlaybackSourceType.Phone) {
                R.string.quran_playing_on_phone
            } else {
                R.string.quran_playing_on_watch
            }
        )
    )
    if (!snapshot.isPlaying) {
        Chip(
            onClick = { onCommand(QuranPlaybackCommand.ResumeLast) },
            label = { Text(stringResource(R.string.quran_resume_last)) }
        )
    }
    Button(onClick = { onCommand(QuranPlaybackCommand.Previous) }) { Text("<<") }
    Button(onClick = { onCommand(if (snapshot.isPlaying) QuranPlaybackCommand.Pause else QuranPlaybackCommand.Play) }) {
        Text(stringResource(if (snapshot.isPlaying) R.string.action_pause else R.string.action_play))
    }
    Button(onClick = { onCommand(QuranPlaybackCommand.Next) }) { Text(">>") }
    Chip(onClick = onOutput, label = { Text(stringResource(R.string.quran_switch_output)) })
    if (snapshot.isPlaying || snapshot.positionSeconds > 0) {
        Chip(onClick = onListeningMode, label = { Text(stringResource(R.string.quran_listening_mode)) })
    }
    if (!availability.watchPlaybackAvailable && snapshot.sourceType == QuranPlaybackSourceType.Watch) {
        Text(stringResource(R.string.quran_watch_needs_download))
    }
    Chip(onClick = onBack, label = { Text(stringResource(R.string.action_back)) })
}
