package com.pathofnur.watch.quran

import com.pathofnur.watch.domain.QuranPlaybackCommand
import com.pathofnur.watch.domain.QuranPlaybackSnapshot
import com.pathofnur.watch.domain.WatchAudioAvailabilitySnapshot

interface WearQuranPlaybackBridge {
    suspend fun requestPlaybackSnapshot(): QuranPlaybackSnapshot?
    suspend fun requestAudioAvailability(): WatchAudioAvailabilitySnapshot?
    suspend fun sendCommand(command: QuranPlaybackCommand, sessionId: String?): QuranPlaybackSnapshot?
    fun isPhoneReachable(): Boolean = true
}

class StubWearQuranPlaybackBridge : WearQuranPlaybackBridge {
    override suspend fun requestPlaybackSnapshot(): QuranPlaybackSnapshot? = null
    override suspend fun requestAudioAvailability(): WatchAudioAvailabilitySnapshot? = null
    override suspend fun sendCommand(command: QuranPlaybackCommand, sessionId: String?): QuranPlaybackSnapshot? = null
}
