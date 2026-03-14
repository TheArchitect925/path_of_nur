import Foundation

enum WatchListeningModeController {
    static func shouldAutoActivate(snapshot: WatchQuranPlaybackSnapshot) -> Bool {
        snapshot.isPlaying
    }

    static func statusText(
        snapshot: WatchQuranPlaybackSnapshot,
        phoneReachable: Bool
    ) -> String {
        if !snapshot.isPlaying {
            return "Playback finished"
        }
        if snapshot.sourceType == .phone && !phoneReachable {
            return "Phone unavailable"
        }
        return snapshot.sourceType == .phone ? "Playing on Phone" : "Playing on Watch"
    }

    static func remoteCommandsEnabled(
        snapshot: WatchQuranPlaybackSnapshot,
        phoneReachable: Bool
    ) -> Bool {
        snapshot.sourceType == .watch || phoneReachable
    }
}
