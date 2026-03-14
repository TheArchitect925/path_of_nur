import Foundation

@MainActor
final class WatchPlaybackStateObserver: ObservableObject {
    @Published private(set) var snapshot: WatchQuranPlaybackSnapshot

    init(snapshot: WatchQuranPlaybackSnapshot) {
        self.snapshot = snapshot
    }

    func update(_ next: WatchQuranPlaybackSnapshot) {
        snapshot = next
    }
}
