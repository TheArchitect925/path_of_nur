package com.pathofnur.watch.refresh

enum class SnapshotFreshnessStatus { Fresh, Aging, Stale, Expired }

data class SnapshotFreshnessState(
    val snapshotDate: String?,
    val lastRefreshAt: Long?,
    val lastSuccessfulSyncAt: Long?,
    val freshnessStatus: SnapshotFreshnessStatus,
    val reason: String
)

data class PrayerPhaseState(
    val currentPrayerId: String?,
    val nextPrayerId: String?,
    val nextPrayerTimeLabel: String?,
    val lastEvaluatedAt: Long
)

enum class DayRolloverStatus { Idle, Needed, Processing, Complete, Failed }

data class DayRolloverState(
    val activeDate: String,
    val lastRolloverCheckAt: Long?,
    val lastRolloverCompletedAt: Long?,
    val rolloverStatus: DayRolloverStatus
)

enum class BackgroundRefreshEventType {
    AppLaunch, AppResume, ScheduledRefresh, NextPrayerTransition, DayRollover, SyncComplete, ManualRefresh, PrayerCompletion, DhikrUpdate, NotificationAction
}

data class BackgroundRefreshEvent(
    val id: String,
    val type: BackgroundRefreshEventType,
    val timestamp: Long,
    val handled: Boolean
)

data class RefreshResult(
    val snapshotUpdated: Boolean,
    val notificationsRescheduled: Boolean,
    val tilesRefreshed: Boolean,
    val complicationsRefreshed: Boolean,
    val syncAttempted: Boolean,
    val rolloverPerformed: Boolean,
    val errors: List<String>
)

