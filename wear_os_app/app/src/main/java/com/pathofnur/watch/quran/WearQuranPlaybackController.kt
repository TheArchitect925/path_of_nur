package com.pathofnur.watch.quran

import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.WatchAudioAvailabilitySnapshot
import java.time.Instant

class WearQuranPlaybackController(
    private val repository: WatchRepository,
    private val bridge: WearQuranPlaybackBridge,
    private val localAudioPlayer: WearLocalAudioPlayer
) {
    fun isPhoneReachable(): Boolean = bridge.isPhoneReachable()

    suspend fun refreshFromPhone() {
        bridge.requestPlaybackSnapshot()?.let(repository::saveQuranPlayback)
        bridge.requestAudioAvailability()?.let(repository::saveQuranAudioAvailability)
    }

    fun sendCommand(command: QuranPlaybackCommand): QuranPlaybackSnapshot {
        val current = repository.quranPlayback()
        val availability = repository.quranAudioAvailability()

        val next = when (command) {
            QuranPlaybackCommand.SwitchOutputPhone ->
                current.copy(sourceType = com.pathofnur.watch.domain.QuranPlaybackSourceType.Phone, isPlaying = false, lastUpdatedAt = Instant.now())
            QuranPlaybackCommand.SwitchOutputWatch ->
                if (availability.watchPlaybackAvailable) {
                    current.copy(sourceType = com.pathofnur.watch.domain.QuranPlaybackSourceType.Watch, isPlaying = false, lastUpdatedAt = Instant.now())
                } else current
            else ->
                if (current.sourceType == com.pathofnur.watch.domain.QuranPlaybackSourceType.Watch) {
                    localAudioPlayer.apply(command, current, availability)
                } else {
                    when (command) {
                        QuranPlaybackCommand.Play, QuranPlaybackCommand.ResumeLast -> current.copy(isPlaying = true, lastUpdatedAt = Instant.now())
                        QuranPlaybackCommand.Pause -> current.copy(isPlaying = false, lastUpdatedAt = Instant.now())
                        QuranPlaybackCommand.SeekForward15 -> current.copy(positionSeconds = current.positionSeconds + 15, lastUpdatedAt = Instant.now())
                        QuranPlaybackCommand.SeekBack15 -> current.copy(positionSeconds = (current.positionSeconds - 15).coerceAtLeast(0), lastUpdatedAt = Instant.now())
                        QuranPlaybackCommand.Next, QuranPlaybackCommand.Previous -> current.copy(positionSeconds = 0, lastUpdatedAt = Instant.now())
                        QuranPlaybackCommand.SwitchOutputPhone, QuranPlaybackCommand.SwitchOutputWatch -> current
                    }
                }
        }

        repository.saveQuranPlayback(next)
        repository.enqueueQuranCommand(command, next.playbackSessionId)
        return next
    }

    fun audioAvailability(): WatchAudioAvailabilitySnapshot = repository.quranAudioAvailability()
}
