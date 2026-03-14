import SwiftUI

@main
struct PathOfNurWatchApp: App {
    @StateObject private var store = WatchAppStore()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        WatchNotificationCoordinator.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            WatchRootView()
                .environmentObject(store)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await store.flushSync()
                }
            }
        }
    }
}
