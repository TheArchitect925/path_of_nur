import SwiftUI

@MainActor
final class WatchBackgroundRefreshCoordinator: ObservableObject {
    let orchestrator: WatchRefreshOrchestrator

    init(syncBridge: WatchSyncBridge) {
        orchestrator = WatchRefreshOrchestrator(syncBridge: syncBridge)
    }

    func appLaunch() async {
        _ = await orchestrator.handle(.appLaunch)
    }

    func appResume() async {
        _ = await orchestrator.handle(.appResume)
    }

    func notifyPrayerCompletion() async {
        _ = await orchestrator.handle(.prayerCompletion)
    }

    func notifyDhikrUpdate() async {
        _ = await orchestrator.handle(.dhikrUpdate)
    }

    func notifyNotificationAction() async {
        _ = await orchestrator.handle(.notificationAction)
    }
}

