package com.pathofnur.watch.quran

import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.QuranPlaybackSourceType
import com.pathofnur.watch.domain.WatchAudioAvailabilitySnapshot
import java.time.Instant

class WearLocalAudioPlayer {
    fun apply(
        command: QuranPlaybackCommand,
        snapshot: QuranPlaybackSnapshot,
        availability: WatchAudioAvailabilitySnapshot
    ): QuranPlaybackSnapshot {
        if (!availability.watchPlaybackAvailable) return snapshot
        var next = snapshot.copy(sourceType = QuranPlaybackSourceType.Watch, lastUpdatedAt = Instant.now())
        next = when (command) {
            QuranPlaybackCommand.Play, QuranPlaybackCommand.ResumeLast -> next.copy(isPlaying = true)
            QuranPlaybackCommand.Pause -> next.copy(isPlaying = false)
            QuranPlaybackCommand.SeekForward15 -> next.copy(positionSeconds = next.positionSeconds + 15)
            QuranPlaybackCommand.SeekBack15 -> next.copy(positionSeconds = (next.positionSeconds - 15).coerceAtLeast(0))
            QuranPlaybackCommand.Next -> {
                val current = next.surahId
                val index = availability.downloadedSurahIds.indexOf(current)
                if (index >= 0 && index + 1 < availability.downloadedSurahIds.size) {
                    val surahId = availability.downloadedSurahIds[index + 1]
                    next.copy(surahId = surahId, surahName = "Surah $surahId", positionSeconds = 0)
                } else next
            }
            QuranPlaybackCommand.Previous -> {
                val current = next.surahId
                val index = availability.downloadedSurahIds.indexOf(current)
                if (index > 0) {
                    val surahId = availability.downloadedSurahIds[index - 1]
                    next.copy(surahId = surahId, surahName = "Surah $surahId", positionSeconds = 0)
                } else next
            }
            QuranPlaybackCommand.SwitchOutputPhone -> next.copy(sourceType = QuranPlaybackSourceType.Phone, isPlaying = false)
            QuranPlaybackCommand.SwitchOutputWatch -> next.copy(sourceType = QuranPlaybackSourceType.Watch, isPlaying = false)
        }
        return next
    }
}
