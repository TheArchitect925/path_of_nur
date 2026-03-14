import Foundation

protocol WatchSyncBridge: WatchQuranPlaybackBridge {
    func requestLatestSnapshot() async -> (WatchDaySnapshot, [WatchPrayerStatus])?
    func flush(queue: [WatchSyncQueueItem]) async -> [WatchSyncQueueItem]
}

struct StubWatchSyncBridge: WatchSyncBridge {
    func requestLatestSnapshot() async -> (WatchDaySnapshot, [WatchPrayerStatus])? {
        nil
    }

    func flush(queue: [WatchSyncQueueItem]) async -> [WatchSyncQueueItem] {
        queue
    }

    func requestQuranPlaybackSnapshot() async -> WatchQuranPlaybackSnapshot? {
        nil
    }

    func requestQuranAudioAvailability() async -> WatchAudioAvailabilitySnapshot? {
        nil
    }

    func sendQuranPlaybackCommand(_ command: WatchQuranPlaybackCommand, sessionId: String?) async -> WatchQuranPlaybackSnapshot? {
        nil
    }

    func isPhoneReachable() -> Bool {
        true
    }
}
