import Foundation

final class WatchLocalAudioPlayer {
    func apply(
        command: WatchQuranPlaybackCommand,
        to snapshot: WatchQuranPlaybackSnapshot,
        availability: WatchAudioAvailabilitySnapshot
    ) -> WatchQuranPlaybackSnapshot {
        guard availability.watchPlaybackAvailable else { return snapshot }
        var next = snapshot
        next.sourceType = .watch
        next.lastUpdatedAt = Date()
        switch command {
        case .play, .resumeLast:
            next.isPlaying = true
        case .pause:
            next.isPlaying = false
        case .next:
            if let current = next.surahId,
               let index = availability.downloadedSurahIds.firstIndex(of: current),
               index + 1 < availability.downloadedSurahIds.count {
                next.surahId = availability.downloadedSurahIds[index + 1]
                next.surahName = "Surah \(availability.downloadedSurahIds[index + 1])"
                next.positionSeconds = 0
            }
        case .previous:
            if let current = next.surahId,
               let index = availability.downloadedSurahIds.firstIndex(of: current),
               index > 0 {
                next.surahId = availability.downloadedSurahIds[index - 1]
                next.surahName = "Surah \(availability.downloadedSurahIds[index - 1])"
                next.positionSeconds = 0
            }
        case .seekForward15:
            next.positionSeconds += 15
        case .seekBack15:
            next.positionSeconds = max(0, next.positionSeconds - 15)
        case .switchOutputPhone:
            next.sourceType = .phone
            next.isPlaying = false
        case .switchOutputWatch:
            next.sourceType = .watch
        }
        return next
    }
}
