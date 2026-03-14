package com.pathofnur.watch.refresh

import android.content.Context

class WearBackgroundRefreshCoordinator(context: Context) {
    private val orchestrator = WearRefreshOrchestrator(context)

    suspend fun appLaunch() = orchestrator.handle(BackgroundRefreshEventType.AppLaunch)
    suspend fun appResume() = orchestrator.handle(BackgroundRefreshEventType.AppResume)
    suspend fun prayerCompletion() = orchestrator.handle(BackgroundRefreshEventType.PrayerCompletion)
    suspend fun dhikrUpdate() = orchestrator.handle(BackgroundRefreshEventType.DhikrUpdate)
    suspend fun syncComplete() = orchestrator.handle(BackgroundRefreshEventType.SyncComplete)
    suspend fun notificationAction() = orchestrator.handle(BackgroundRefreshEventType.NotificationAction)
}

