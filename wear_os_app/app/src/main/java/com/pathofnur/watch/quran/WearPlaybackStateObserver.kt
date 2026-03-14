package com.pathofnur.watch.quran

import androidx.compose.runtime.Immutable
import com.pathofnur.watch.domain.QuranPlaybackSnapshot

@Immutable
data class WearPlaybackStateObserver(
    val snapshot: QuranPlaybackSnapshot
)
