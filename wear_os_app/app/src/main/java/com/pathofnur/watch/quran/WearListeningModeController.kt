package com.pathofnur.watch.quran

import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.QuranPlaybackSourceType

object WearListeningModeController {
    fun shouldAutoActivate(snapshot: QuranPlaybackSnapshot): Boolean = snapshot.isPlaying

    fun remoteCommandsEnabled(snapshot: QuranPlaybackSnapshot, phoneReachable: Boolean): Boolean {
        return snapshot.sourceType == QuranPlaybackSourceType.Watch || phoneReachable
    }

    fun statusText(snapshot: QuranPlaybackSnapshot, phoneReachable: Boolean): String {
        if (!snapshot.isPlaying) return "Playback finished"
        if (snapshot.sourceType == QuranPlaybackSourceType.Phone && !phoneReachable) {
            return "Phone unavailable"
        }
        return if (snapshot.sourceType == QuranPlaybackSourceType.Phone) {
            "Playing on Phone"
        } else {
            "Playing on Watch"
        }
    }
}
