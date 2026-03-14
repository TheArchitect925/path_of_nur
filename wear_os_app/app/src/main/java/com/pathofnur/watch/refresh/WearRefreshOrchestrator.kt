package com.pathofnur.watch.refresh

import android.content.Context
import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.notifications.WearPrayerNotificationScheduler
import com.pathofnur.watch.sync.StubWatchSyncBridge
import com.pathofnur.watch.tiles.TileUpdateCoordinator
import java.time.Instant

class WearRefreshOrchestrator(context: Context) {
    private val appContext = context.applicationContext
    private val repository = WatchRepository(appContext)
    private val refreshStore = WearRefreshStateStore(appContext)
    private val freshnessPolicy = SnapshotFreshnessPolicy()
    private val phaseEvaluator = PrayerPhaseEvaluator()
    private val rolloverEngine = DayRolloverEngine(repository)
    private val syncReconciler = WearSyncReconciler(repository, StubWatchSyncBridge())
    private val notificationScheduler = WearPrayerNotificationScheduler(appContext)

    suspend fun handle(type: BackgroundRefreshEventType): RefreshResult {
        val now = Instant.now()
        refreshStore.appendEvent(type, now.toEpochMilli())

        val rollover = rolloverEngine.performIfNeeded()
        refreshStore.saveDayRolloverState(
            DayRolloverState(
                activeDate = repository.snapshot().date,
                lastRolloverCheckAt = now.toEpochMilli(),
                lastRolloverCompletedAt = if (rollover.performed) now.toEpochMilli() else null,
                rolloverStatus = if (rollover.performed) DayRolloverStatus.Complete else DayRolloverStatus.Idle
            )
        )

        val snapshot = repository.snapshot()
        val freshness = freshnessPolicy.evaluate(
            now = now,
            snapshot = snapshot,
            lastRefreshAt = refreshStore.loadFreshnessState()?.lastRefreshAt,
            lastSuccessfulSyncAt = null,
            hasPendingActions = repository.queue().isNotEmpty()
        )
        refreshStore.saveFreshnessState(freshness)

        val phase = phaseEvaluator.evaluate(
            prayers = repository.prayers(),
            nextPrayerId = snapshot.nextPrayerId,
            nextPrayerTime = repository.instantForPrayer(snapshot.nextPrayerId),
            previous = refreshStore.loadPrayerPhaseState()
        )
        refreshStore.savePrayerPhaseState(phase.state)

        val shouldSync = freshness.freshnessStatus == SnapshotFreshnessStatus.Stale ||
            freshness.freshnessStatus == SnapshotFreshnessStatus.Expired ||
            repository.queue().isNotEmpty() ||
            type == BackgroundRefreshEventType.AppLaunch ||
            type == BackgroundRefreshEventType.AppResume
        val syncAttempted = if (shouldSync) syncReconciler.attemptSync() else false

        val shouldRefreshSurfaces = rollover.performed || phase.didTransition || type == BackgroundRefreshEventType.PrayerCompletion || type == BackgroundRefreshEventType.DhikrUpdate || syncAttempted
        if (shouldRefreshSurfaces) {
            notificationScheduler.refreshSchedules()
            TileUpdateCoordinator.refreshAll(appContext)
        }

        refreshStore.saveFreshnessState(
            freshnessPolicy.evaluate(
                now = now,
                snapshot = repository.snapshot(),
                lastRefreshAt = now.toEpochMilli(),
                lastSuccessfulSyncAt = now.toEpochMilli().takeIf { syncAttempted },
                hasPendingActions = repository.queue().isNotEmpty()
            )
        )

        return RefreshResult(
            snapshotUpdated = rollover.performed || phase.didTransition || syncAttempted,
            notificationsRescheduled = shouldRefreshSurfaces,
            tilesRefreshed = shouldRefreshSurfaces,
            complicationsRefreshed = false,
            syncAttempted = shouldSync,
            rolloverPerformed = rollover.performed,
            errors = emptyList()
        )
    }
}

