import Foundation

final class WatchSyncReconciler {
    private let localStore = WatchLocalStore()
    private let syncBridge: WatchSyncBridge

    init(syncBridge: WatchSyncBridge) {
        self.syncBridge = syncBridge
    }

    func attemptSync() async -> Bool {
        var queue = localStore.loadQueue()
        let flushed = await syncBridge.flush(queue: queue)
        let queueChanged = flushed.count != queue.count
        queue = flushed
        localStore.saveQueue(queue)

        if let latest = await syncBridge.requestLatestSnapshot(), queue.isEmpty {
            localStore.saveSnapshot(latest.0)
            localStore.savePrayers(latest.1)
            return true
        }
        return queueChanged
    }
}

