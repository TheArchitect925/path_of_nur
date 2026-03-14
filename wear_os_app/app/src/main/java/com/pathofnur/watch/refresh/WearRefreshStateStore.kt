package com.pathofnur.watch.refresh

import android.content.Context
import java.util.UUID

class WearRefreshStateStore(context: Context) {
    private val prefs = context.getSharedPreferences("path_of_nur_watch_refresh", Context.MODE_PRIVATE)

    fun loadFreshnessState(): SnapshotFreshnessState? {
        val status = prefs.getString("freshnessStatus", null) ?: return null
        return SnapshotFreshnessState(
            snapshotDate = prefs.getString("snapshotDate", null),
            lastRefreshAt = prefs.getLong("lastRefreshAt", 0L).takeIf { it > 0 },
            lastSuccessfulSyncAt = prefs.getLong("lastSuccessfulSyncAt", 0L).takeIf { it > 0 },
            freshnessStatus = enumValueOf(status),
            reason = prefs.getString("freshnessReason", "") ?: ""
        )
    }

    fun saveFreshnessState(state: SnapshotFreshnessState) {
        prefs.edit()
            .putString("snapshotDate", state.snapshotDate)
            .putLong("lastRefreshAt", state.lastRefreshAt ?: 0L)
            .putLong("lastSuccessfulSyncAt", state.lastSuccessfulSyncAt ?: 0L)
            .putString("freshnessStatus", state.freshnessStatus.name)
            .putString("freshnessReason", state.reason)
            .apply()
    }

    fun loadPrayerPhaseState(): PrayerPhaseState? {
        val last = prefs.getLong("phaseLast", 0L)
        if (last == 0L) return null
        return PrayerPhaseState(
            currentPrayerId = prefs.getString("phaseCurrentPrayerId", null),
            nextPrayerId = prefs.getString("phaseNextPrayerId", null),
            nextPrayerTimeLabel = prefs.getString("phaseNextPrayerTimeLabel", null),
            lastEvaluatedAt = last
        )
    }

    fun savePrayerPhaseState(state: PrayerPhaseState) {
        prefs.edit()
            .putString("phaseCurrentPrayerId", state.currentPrayerId)
            .putString("phaseNextPrayerId", state.nextPrayerId)
            .putString("phaseNextPrayerTimeLabel", state.nextPrayerTimeLabel)
            .putLong("phaseLast", state.lastEvaluatedAt)
            .apply()
    }

    fun saveDayRolloverState(state: DayRolloverState) {
        prefs.edit()
            .putString("rolloverDate", state.activeDate)
            .putLong("rolloverCheckAt", state.lastRolloverCheckAt ?: 0L)
            .putLong("rolloverCompletedAt", state.lastRolloverCompletedAt ?: 0L)
            .putString("rolloverStatus", state.rolloverStatus.name)
            .apply()
    }

    fun appendEvent(type: BackgroundRefreshEventType, at: Long) {
        prefs.edit()
            .putString("lastEventId", UUID.randomUUID().toString())
            .putString("lastEventType", type.name)
            .putLong("lastEventAt", at)
            .apply()
    }
}

