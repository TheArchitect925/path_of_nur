package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
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
    Text(stringResource(R.string.quran_output))
    Chip(
        onClick = onSelectPhone,
        label = {
            Text(
                stringResource(
                    if (currentSource == QuranPlaybackSourceType.Phone) {
                        R.string.quran_output_phone_selected
                    } else {
                        R.string.quran_output_phone
                    }
                )
            )
        }
    )
    Chip(
        onClick = onSelectWatch,
        enabled = availability.watchPlaybackAvailable,
        label = {
            Text(
                stringResource(
                    if (currentSource == QuranPlaybackSourceType.Watch) {
                        R.string.quran_output_watch_selected
                    } else {
                        R.string.quran_output_watch
                    }
                )
            )
        }
    )
    if (!availability.watchPlaybackAvailable) {
        Text(stringResource(R.string.quran_watch_needs_download))
    }
    Chip(onClick = onBack, label = { Text(stringResource(R.string.action_back)) })
}
