package com.pathofnur.watch.data

import android.content.Context
import androidx.wear.tiles.TileService
import com.pathofnur.watch.dhikr.WearDhikrEngine
import com.pathofnur.watch.dhikr.WearDhikrPaceDecision
import com.pathofnur.watch.dhikr.WearDhikrPacePolicy
import com.pathofnur.watch.dhikr.WearDhikrSessionStore
import com.pathofnur.watch.domain.*
import java.time.LocalDate
import com.pathofnur.watch.tiles.DhikrTileService
import com.pathofnur.watch.tiles.NextPrayerTileService
import com.pathofnur.watch.tiles.PrayerProgressTileService
import java.time.Instant
import java.util.UUID

class WatchRepository(context: Context) {
    private val appContext = context.applicationContext
    private val prefs = appContext.getSharedPreferences("path_of_nur_watch", Context.MODE_PRIVATE)
    private val dhikrStore = WearDhikrSessionStore(appContext)
    private val dhikrEngine = WearDhikrEngine()

    fun snapshot(): WatchDaySnapshot = WatchDaySnapshot(
        date = "2026-03-14",
        timezone = "America/Toronto",
        nextPrayerId = "asr",
        nextPrayerTimeLabel = "4:42 PM",
        nextPrayerCountdownLabel = "42m",
        currentPrayerId = "dhuhr",
        completedPrayerCount = prefs.getInt("completedPrayerCount", 2),
        totalPrayerCount = 5,
        dhikrTodayCount = prefs.getInt("dhikrTodayCount", 64),
        xpToday = 42,
        oceanDropsToday = prefs.getInt("oceanDropsToday", 3),
        streakDays = 18,
        lastSyncLabel = if (queue().isEmpty()) "Synced recently" else "Offline changes saved"
    )

    fun prayers(): List<WatchPrayerStatus> {
        val completed = prefs.getStringSet("completedPrayers", setOf("fajr", "dhuhr")) ?: emptySet()
        return listOf(
            Triple("fajr", "Fajr", "5:18 AM"),
            Triple("dhuhr", "Dhuhr", "1:09 PM"),
            Triple("asr", "Asr", "4:42 PM"),
            Triple("maghrib", "Maghrib", "7:18 PM"),
            Triple("isha", "Isha", "8:47 PM")
        ).map { (id, name, time) ->
            WatchPrayerStatus(
                prayerId = id,
                displayName = name,
                scheduledTimeLabel = time,
                status = if (completed.contains(id)) PrayerState.Completed else PrayerState.Pending,
                completedAt = null,
                source = SourceType.Phone
            )
        }
    }

    fun dhikrSession(): WatchDhikrSession = dhikrStore.loadSession()

    fun queue(): List<WatchSyncQueueItem> {
        val count = prefs.getInt("queueCount", 0)
        return List(count) {
            WatchSyncQueueItem(
                id = "pending_$it",
                type = SyncItemType.DhikrIncrement,
                payload = emptyMap(),
                createdAt = Instant.now(),
                syncStatus = SyncStatus.Pending,
                retryCount = 0
            )
        }
    }

    fun togglePrayer(prayerId: String) {
        val set = prefs.getStringSet("completedPrayers", mutableSetOf())!!.toMutableSet()
        if (!set.add(prayerId)) set.remove(prayerId)
        prefs.edit().putStringSet("completedPrayers", set).putInt("completedPrayerCount", set.size).apply()
        enqueue()
        refreshTiles()
    }

    fun markPrayerCompleted(prayerId: String) {
        val set = prefs.getStringSet("completedPrayers", mutableSetOf())!!.toMutableSet()
        if (set.add(prayerId)) {
            prefs.edit().putStringSet("completedPrayers", set).putInt("completedPrayerCount", set.size).apply()
            enqueue()
            refreshTiles()
        }
    }

    fun markPrayerPending(prayerId: String) {
        val set = prefs.getStringSet("completedPrayers", mutableSetOf())!!.toMutableSet()
        if (set.remove(prayerId)) {
            prefs.edit().putStringSet("completedPrayers", set).putInt("completedPrayerCount", set.size).apply()
            enqueue()
            refreshTiles()
        }
    }

    fun incrementDhikr(): DhikrIncrementOutcome? {
        val session = dhikrStore.loadSession()
        val today = prefs.getInt("dhikrTodayCount", 64)
        val outcome = dhikrEngine.increment(session, today) ?: return null
        dhikrStore.saveSession(outcome.session)
        prefs.edit().putInt("dhikrTodayCount", outcome.todayTotal).apply()
        if (outcome.rewardGranted) {
            prefs.edit().putInt("oceanDropsToday", prefs.getInt("oceanDropsToday", 3) + 1).apply()
        }
        enqueueDetailed(
            SyncItemType.DhikrIncrement,
            mapOf("sessionId" to outcome.session.sessionId, "count" to outcome.session.currentCount.toString(), "amount" to "1")
        )
        if (outcome.shouldQueueCompletion) {
            enqueueDetailed(
                SyncItemType.SessionComplete,
                mapOf(
                    "sessionId" to outcome.session.sessionId,
                    "mode" to outcome.session.mode.name,
                    "count" to outcome.session.currentCount.toString(),
                    "rewardGranted" to outcome.session.rewardGranted.toString()
                )
            )
        }
        refreshTiles()
        return outcome
    }

    fun startDhikrSession(mode: DhikrMode) {
        val current = dhikrStore.loadSession()
        if (current.currentCount > 0) {
            enqueueDetailed(
                SyncItemType.SessionComplete,
                mapOf("sessionId" to current.sessionId, "count" to current.currentCount.toString(), "completed" to current.completed.toString())
            )
        }
        dhikrStore.saveSession(dhikrEngine.newSession(mode))
        enqueueDetailed(SyncItemType.DhikrReset, mapOf("mode" to mode.name))
        refreshTiles()
    }

    fun setDhikrInteractionMode(mode: DhikrInteractionMode) {
        val current = dhikrStore.loadSession()
        val adjusted = current.copy(
            interactionMode = mode,
            isPulseRunning = false,
            pulseTargetCount = if (mode == DhikrInteractionMode.GuidedPulse) {
                when (current.mode) {
                    DhikrMode.Preset33 -> 33
                    DhikrMode.Preset99 -> 99
                    DhikrMode.Free -> 33
                }
            } else current.pulseTargetCount
        )
        dhikrStore.saveSession(adjusted)
    }

    fun updateGuidedPulseFaster(): Boolean {
        val current = dhikrStore.loadSession()
        return when (val result = WearDhikrPacePolicy.faster(current.pulseIntervalSeconds ?: WearDhikrPacePolicy.defaultInterval)) {
            is WearDhikrPaceDecision.Updated -> {
                dhikrStore.saveSession(current.copy(pulseIntervalSeconds = result.seconds, paceReminderShownAt = null))
                true
            }
            WearDhikrPaceDecision.Blocked -> {
                dhikrStore.saveSession(current.copy(paceReminderShownAt = Instant.now()))
                false
            }
        }
    }

    fun updateGuidedPulseSlower() {
        val current = dhikrStore.loadSession()
        val result = WearDhikrPacePolicy.slower(current.pulseIntervalSeconds ?: WearDhikrPacePolicy.defaultInterval)
        if (result is WearDhikrPaceDecision.Updated) {
            dhikrStore.saveSession(current.copy(pulseIntervalSeconds = result.seconds))
        }
    }

    fun resetGuidedPaceToSteady() {
        val current = dhikrStore.loadSession()
        dhikrStore.saveSession(current.copy(pulseIntervalSeconds = WearDhikrPacePolicy.steadyInterval))
    }

    fun setGuidedPulseRunning(running: Boolean) {
        val current = dhikrStore.loadSession()
        dhikrStore.saveSession(current.copy(isPulseRunning = running, pausedAt = if (running) null else Instant.now()))
    }

    fun resetDhikrSession() {
        val current = dhikrStore.loadSession()
        if (current.currentCount > 0) {
            enqueueDetailed(
                SyncItemType.SessionComplete,
                mapOf("sessionId" to current.sessionId, "count" to current.currentCount.toString(), "reset" to "true")
            )
        }
        dhikrStore.saveSession(dhikrEngine.newSession(current.mode))
        enqueueDetailed(SyncItemType.DhikrReset, mapOf("mode" to current.mode.name))
        refreshTiles()
    }

    private fun enqueue() {
        prefs.edit().putInt("queueCount", prefs.getInt("queueCount", 0) + 1).apply()
    }

    private fun enqueueDetailed(type: SyncItemType, payload: Map<String, String>) {
        enqueue()
    }

    private fun refreshTiles() {
        TileService.getUpdater(appContext).requestUpdate(NextPrayerTileService::class.java)
        TileService.getUpdater(appContext).requestUpdate(PrayerProgressTileService::class.java)
        TileService.getUpdater(appContext).requestUpdate(DhikrTileService::class.java)
    }

    fun instantForPrayer(prayerId: String): Instant? {
        val base = mapOf(
            "fajr" to (5 to 18),
            "dhuhr" to (13 to 9),
            "asr" to (16 to 42),
            "maghrib" to (19 to 18),
            "isha" to (20 to 47)
        )[prayerId] ?: return null
        val zoned = java.time.ZonedDateTime.now()
            .withHour(base.first)
            .withMinute(base.second)
            .withSecond(0)
            .withNano(0)
        return zoned.toInstant()
    }

    fun rolloverToToday(today: String) {
        prefs.edit()
            .putStringSet("completedPrayers", emptySet())
            .putInt("completedPrayerCount", 0)
            .putInt("dhikrTodayCount", 0)
            .putInt("oceanDropsToday", 0)
            .apply()
        refreshTiles()
    }

    fun quranPlayback(): QuranPlaybackSnapshot {
        val source = prefs.getString("quranPlaybackSource", QuranPlaybackSourceType.Phone.name)
            ?.let { runCatching { QuranPlaybackSourceType.valueOf(it) }.getOrNull() }
            ?: QuranPlaybackSourceType.Phone
        val surahId = prefs.getInt("quranSurahId", 0).takeIf { it > 0 }
        return QuranPlaybackSnapshot(
            playbackSessionId = prefs.getString("quranPlaybackSessionId", null) ?: UUID.randomUUID().toString(),
            sourceType = source,
            isPlaying = prefs.getBoolean("quranIsPlaying", false),
            surahId = surahId,
            surahName = prefs.getString("quranSurahName", null)
                ?: if (surahId != null) "Surah $surahId" else "Resume Last Recitation",
            reciterId = prefs.getString("quranReciterId", "husary") ?: "husary",
            reciterName = prefs.getString("quranReciterName", "Mahmoud Khalil Al-Husary")
                ?: "Mahmoud Khalil Al-Husary",
            currentAyah = prefs.getInt("quranCurrentAyah", 0).takeIf { it > 0 },
            positionSeconds = prefs.getInt("quranPositionSeconds", 0),
            durationSeconds = prefs.getInt("quranDurationSeconds", 0).takeIf { it > 0 },
            isBuffering = prefs.getBoolean("quranBuffering", false),
            lastUpdatedAt = Instant.ofEpochMilli(prefs.getLong("quranLastUpdatedAt", Instant.now().toEpochMilli()))
        )
    }

    fun saveQuranPlayback(snapshot: QuranPlaybackSnapshot) {
        prefs.edit()
            .putString("quranPlaybackSessionId", snapshot.playbackSessionId)
            .putString("quranPlaybackSource", snapshot.sourceType.name)
            .putBoolean("quranIsPlaying", snapshot.isPlaying)
            .putInt("quranSurahId", snapshot.surahId ?: 0)
            .putString("quranSurahName", snapshot.surahName)
            .putString("quranReciterId", snapshot.reciterId)
            .putString("quranReciterName", snapshot.reciterName)
            .putInt("quranCurrentAyah", snapshot.currentAyah ?: 0)
            .putInt("quranPositionSeconds", snapshot.positionSeconds)
            .putInt("quranDurationSeconds", snapshot.durationSeconds ?: 0)
            .putBoolean("quranBuffering", snapshot.isBuffering)
            .putLong("quranLastUpdatedAt", snapshot.lastUpdatedAt.toEpochMilli())
            .apply()
    }

    fun quranAudioAvailability(): WatchAudioAvailabilitySnapshot {
        val ids = prefs.getString("quranDownloadedIds", "")
            ?.split(',')
            ?.mapNotNull { it.toIntOrNull() }
            ?.filter { it > 0 }
            ?: emptyList()
        val recents = prefs.getString("quranRecentPlayableItems", "")
            ?.split('|')
            ?.map { it.trim() }
            ?.filter { it.isNotEmpty() }
            ?: emptyList()
        val lastSynced = prefs.getLong("quranAvailabilitySyncedAt", 0L)
            .takeIf { it > 0L }
            ?.let(Instant::ofEpochMilli)
        return WatchAudioAvailabilitySnapshot(
            watchPlaybackAvailable = ids.isNotEmpty(),
            downloadedSurahIds = ids,
            recentPlayableItems = recents,
            lastSyncedAt = lastSynced
        )
    }

    fun saveQuranAudioAvailability(snapshot: WatchAudioAvailabilitySnapshot) {
        prefs.edit()
            .putString("quranDownloadedIds", snapshot.downloadedSurahIds.joinToString(","))
            .putString("quranRecentPlayableItems", snapshot.recentPlayableItems.joinToString("|"))
            .putLong("quranAvailabilitySyncedAt", snapshot.lastSyncedAt?.toEpochMilli() ?: 0L)
            .apply()
    }

    fun enqueueQuranCommand(command: QuranPlaybackCommand, sessionId: String) {
        enqueueDetailed(
            SyncItemType.QuranPlaybackCommand,
            mapOf(
                "command" to command.name,
                "sessionId" to sessionId,
                "logicalDate" to LocalDate.now().toString()
            )
        )
    }
}
