import Foundation
import WidgetKit

@MainActor
final class WatchRefreshOrchestrator: ObservableObject {
    private let localStore = WatchLocalStore()
    private let refreshStore = WatchRefreshStateStore()
    private let freshnessPolicy = SnapshotFreshnessPolicy()
    private let phaseEvaluator = PrayerPhaseEvaluator()
    private let rolloverEngine = DayRolloverEngine()
    private let syncReconciler: WatchSyncReconciler

    init(syncBridge: WatchSyncBridge) {
        self.syncReconciler = WatchSyncReconciler(syncBridge: syncBridge)
    }

    func handle(_ type: BackgroundRefreshEventType) async -> RefreshResult {
        let now = Date()
        refreshStore.appendEvent(
            BackgroundRefreshEvent(id: UUID().uuidString, type: type, timestamp: now, handled: true)
        )

        let rollover = rolloverEngine.performIfNeeded(now: now)
        if rollover.performed {
            refreshStore.saveDayRolloverState(
                DayRolloverState(activeDate: now, lastRolloverCheckAt: now, lastRolloverCompletedAt: now, rolloverStatus: .complete)
            )
        } else {
            refreshStore.saveDayRolloverState(
                DayRolloverState(activeDate: localStore.loadSnapshot()?.date ?? now, lastRolloverCheckAt: now, lastRolloverCompletedAt: refreshStore.loadDayRolloverState()?.lastRolloverCompletedAt, rolloverStatus: .idle)
            )
        }

        let snapshot = localStore.loadSnapshot()
        let prayers = localStore.loadPrayers()
        let freshness = freshnessPolicy.evaluate(
            now: now,
            snapshot: snapshot,
            lastRefreshAt: refreshStore.loadFreshnessState()?.lastRefreshAt,
            lastSuccessfulSyncAt: snapshot?.lastSyncAt,
            hasPendingActions: !localStore.loadQueue().isEmpty
        )
        refreshStore.saveFreshnessState(freshness)

        let phase = phaseEvaluator.evaluate(prayers: prayers, now: now, previous: refreshStore.loadPrayerPhaseState())
        refreshStore.savePrayerPhaseState(phase.state)
        if phase.didTransition, var snapshot {
            snapshot.currentPrayerId = phase.state.currentPrayerId
            snapshot.nextPrayerId = phase.state.nextPrayerId ?? snapshot.nextPrayerId
            if let nextTime = phase.state.nextPrayerTime {
                snapshot.nextPrayerTime = nextTime
            }
            localStore.saveSnapshot(snapshot)
        }

        let shouldSync = freshness.freshnessStatus == .stale || freshness.freshnessStatus == .expired || !localStore.loadQueue().isEmpty || type == .appLaunch || type == .appResume
        let syncAttempted = shouldSync ? await syncReconciler.attemptSync() : false

        let shouldRefreshSurfaces = rollover.performed || phase.didTransition || type == .prayerCompletion || type == .dhikrUpdate || syncAttempted
        if shouldRefreshSurfaces {
            WidgetCenter.shared.reloadAllTimelines()
            WatchNotificationCoordinator.shared.refreshSchedules()
            NotificationCenter.default.post(name: WatchSharedConstants.notificationDataDidChange, object: nil)
        }

        let updatedSnapshot = localStore.loadSnapshot()
        refreshStore.saveFreshnessState(
            freshnessPolicy.evaluate(
                now: now,
                snapshot: updatedSnapshot,
                lastRefreshAt: now,
                lastSuccessfulSyncAt: updatedSnapshot?.lastSyncAt,
                hasPendingActions: !localStore.loadQueue().isEmpty
            )
        )

        return RefreshResult(
            snapshotUpdated: syncAttempted || rollover.performed || phase.didTransition,
            notificationsRescheduled: shouldRefreshSurfaces,
            tilesRefreshed: false,
            complicationsRefreshed: shouldRefreshSurfaces,
            syncAttempted: shouldSync,
            rolloverPerformed: rollover.performed,
            errors: []
        )
    }
}

