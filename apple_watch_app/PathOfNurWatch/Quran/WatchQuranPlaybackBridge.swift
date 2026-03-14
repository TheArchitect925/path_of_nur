import Foundation

protocol WatchQuranPlaybackBridge {
    func requestQuranPlaybackSnapshot() async -> WatchQuranPlaybackSnapshot?
    func requestQuranAudioAvailability() async -> WatchAudioAvailabilitySnapshot?
    func sendQuranPlaybackCommand(_ command: WatchQuranPlaybackCommand, sessionId: String?) async -> WatchQuranPlaybackSnapshot?
    func isPhoneReachable() -> Bool
}
