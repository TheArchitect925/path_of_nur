package com.pathofnur.watch.refresh

import com.pathofnur.watch.domain.WatchDaySnapshot
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId

class SnapshotFreshnessPolicy {
    fun evaluate(
        now: Instant,
        snapshot: WatchDaySnapshot?,
        lastRefreshAt: Long?,
        lastSuccessfulSyncAt: Long?,
        hasPendingActions: Boolean
    ): SnapshotFreshnessState {
        if (snapshot == null) {
            return SnapshotFreshnessState(null, lastRefreshAt, lastSuccessfulSyncAt, SnapshotFreshnessStatus.Expired, "Missing snapshot")
        }
        val today = LocalDate.now(ZoneId.systemDefault()).toString()
        if (snapshot.date != today) {
            return SnapshotFreshnessState(snapshot.date, lastRefreshAt, lastSuccessfulSyncAt, SnapshotFreshnessStatus.Expired, "Snapshot belongs to a different day")
        }
        val ageMillis = now.toEpochMilli() - (lastRefreshAt ?: lastSuccessfulSyncAt ?: now.toEpochMilli())
        if (hasPendingActions) {
            return SnapshotFreshnessState(snapshot.date, lastRefreshAt, lastSuccessfulSyncAt, if (ageMillis > 60 * 60 * 1000) SnapshotFreshnessStatus.Stale else SnapshotFreshnessStatus.Aging, "Pending local actions")
        }
        return when {
            ageMillis <= 15 * 60 * 1000 -> SnapshotFreshnessState(snapshot.date, lastRefreshAt, lastSuccessfulSyncAt, SnapshotFreshnessStatus.Fresh, "Recent refresh")
            ageMillis <= 60 * 60 * 1000 -> SnapshotFreshnessState(snapshot.date, lastRefreshAt, lastSuccessfulSyncAt, SnapshotFreshnessStatus.Aging, "Refresh advisable soon")
            else -> SnapshotFreshnessState(snapshot.date, lastRefreshAt, lastSuccessfulSyncAt, SnapshotFreshnessStatus.Stale, "Snapshot is aging")
        }
    }
}

