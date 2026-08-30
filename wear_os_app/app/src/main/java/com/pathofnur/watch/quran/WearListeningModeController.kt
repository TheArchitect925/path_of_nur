package com.pathofnur.watch.quran

import androidx.annotation.StringRes
import com.pathofnur.watch.R
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.QuranPlaybackSourceType

object WearListeningModeController {
    fun shouldAutoActivate(snapshot: QuranPlaybackSnapshot): Boolean = snapshot.isPlaying

    fun remoteCommandsEnabled(snapshot: QuranPlaybackSnapshot, phoneReachable: Boolean): Boolean {
        return snapshot.sourceType == QuranPlaybackSourceType.Watch || phoneReachable
    }

    /**
     * Returns a string resource rather than text: this object has no Context,
     * so resolving the wording here would hard-code English. The caller is a
     * composable and can resolve it against the device locale.
     */
    @StringRes
    fun statusTextRes(snapshot: QuranPlaybackSnapshot, phoneReachable: Boolean): Int {
        if (!snapshot.isPlaying) return R.string.quran_status_finished
        if (snapshot.sourceType == QuranPlaybackSourceType.Phone && !phoneReachable) {
            return R.string.quran_status_phone_unavailable
        }
        return if (snapshot.sourceType == QuranPlaybackSourceType.Phone) {
            R.string.quran_status_playing_phone
        } else {
            R.string.quran_status_playing_watch
        }
    }
}
