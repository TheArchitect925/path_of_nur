import Foundation
import WidgetKit

final class WatchNotificationActionHandler {
    private let store = WatchLocalStore()

    func markPrayed(prayerId: String) {
        var prayers = store.loadPrayers()
        prayers = prayers.map { prayer in
            guard prayer.prayerId == prayerId else { return prayer }
            return WatchPrayerStatus(
                prayerId: prayer.prayerId,
                displayName: prayer.displayName,
                scheduledTime: prayer.scheduledTime,
                status: .completed,
                completedAt: Date(),
                source: .watch
            )
        }
        var snapshot = store.loadSnapshot()
        snapshot?.completedPrayerCount = prayers.filter { $0.status == .completed }.count
        if let snapshot {
            store.saveSnapshot(snapshot)
        }
        store.savePrayers(prayers)
        appendQueue(type: .prayerComplete, prayerId: prayerId)
        WidgetCenter.shared.reloadAllTimelines()
        NotificationCenter.default.post(name: WatchSharedConstants.notificationDataDidChange, object: nil)
    }

    func snooze(prayerId: String) {
        WatchNotificationCoordinator.shared.scheduleSnooze(for: prayerId)
        NotificationCenter.default.post(name: WatchSharedConstants.notificationDataDidChange, object: nil)
    }

    private func appendQueue(type: WatchSyncItemType, prayerId: String) {
        var queue = store.loadQueue()
        queue.append(
            WatchSyncQueueItem(
                id: UUID().uuidString,
                type: type,
                payload: ["prayerId": prayerId, "timestamp": ISO8601DateFormatter().string(from: Date())],
                createdAt: Date(),
                syncStatus: .pending,
                retryCount: 0
            )
        )
        store.saveQueue(queue)
    }
}

