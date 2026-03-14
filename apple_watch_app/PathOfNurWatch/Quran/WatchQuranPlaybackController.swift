import Foundation

final class WatchQuranPlaybackController {
    private let store: WatchLocalStore
    private let bridge: WatchQuranPlaybackBridge
    private let localAudioPlayer = WatchLocalAudioPlayer()

    init(store: WatchLocalStore, bridge: WatchQuranPlaybackBridge) {
        self.store = store
        self.bridge = bridge
    }

    func loadAvailability() -> WatchAudioAvailabilitySnapshot {
        store.loadQuranAvailability() ?? WatchAudioAvailabilitySnapshot(
            watchPlaybackAvailable: false,
            downloadedSurahIds: [],
            recentPlayableItems: [],
            lastSyncedAt: Date()
        )
    }

    func isPhoneReachable() -> Bool {
        bridge.isPhoneReachable()
    }

    func refreshFromBridge() async -> (WatchQuranPlaybackSnapshot, WatchAudioAvailabilitySnapshot)? {
        async let snapshot = bridge.requestQuranPlaybackSnapshot()
        async let availability = bridge.requestQuranAudioAvailability()
        guard let resolvedSnapshot = await snapshot else { return nil }
        let resolvedAvailability = await availability ?? loadAvailability()
        store.saveQuranPlayback(resolvedSnapshot)
        store.saveQuranAvailability(resolvedAvailability)
        return (resolvedSnapshot, resolvedAvailability)
    }

    func handle(
        command: WatchQuranPlaybackCommand,
        current: WatchQuranPlaybackSnapshot,
        availability: WatchAudioAvailabilitySnapshot
    ) async -> WatchQuranPlaybackSnapshot {
        switch command {
        case .switchOutputPhone:
            var next = current
            next.sourceType = .phone
            next.isPlaying = false
            next.lastUpdatedAt = Date()
            store.saveQuranPlayback(next)
            return next
        case .switchOutputWatch:
            guard availability.watchPlaybackAvailable else { return current }
            var next = localAudioPlayer.apply(command: command, to: current, availability: availability)
            next.isPlaying = false
            store.saveQuranPlayback(next)
            return next
        default:
            break
        }

        if current.sourceType == .watch {
            let next = localAudioPlayer.apply(command: command, to: current, availability: availability)
            store.saveQuranPlayback(next)
            return next
        }

        if let bridged = await bridge.sendQuranPlaybackCommand(command, sessionId: current.playbackSessionId) {
            store.saveQuranPlayback(bridged)
            return bridged
        }

        var optimistic = current
        optimistic.lastUpdatedAt = Date()
        switch command {
        case .play, .resumeLast:
            optimistic.isPlaying = true
        case .pause:
            optimistic.isPlaying = false
        case .seekForward15:
            optimistic.positionSeconds += 15
        case .seekBack15:
            optimistic.positionSeconds = max(0, optimistic.positionSeconds - 15)
        case .next, .previous:
            optimistic.positionSeconds = 0
        case .switchOutputPhone, .switchOutputWatch:
            break
        }
        store.saveQuranPlayback(optimistic)
        return optimistic
    }
}
