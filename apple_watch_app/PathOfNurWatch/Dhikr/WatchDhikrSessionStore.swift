import Foundation

final class WatchDhikrSessionStore {
    private let localStore = WatchLocalStore()

    func loadSession() -> WatchDhikrSession? {
        localStore.loadDhikr()
    }

    func saveSession(_ session: WatchDhikrSession) {
        localStore.saveDhikr(session)
    }
}

