import SwiftUI

struct WatchRootView: View {
    @State private var selectedRoute: WatchRoute = .today
    @EnvironmentObject private var store: WatchAppStore

    var body: some View {
        TabView(selection: $selectedRoute) {
            TodayWatchScreen()
                .tag(WatchRoute.today)
            PrayerCheckInScreen()
                .tag(WatchRoute.prayers)
            DhikrWatchScreen()
                .tag(WatchRoute.dhikr)
            ProgressWatchScreen()
                .tag(WatchRoute.progress)
            WatchQuranPlayerView()
                .tag(WatchRoute.quranAudio)
            WatchListeningModeView()
                .tag(WatchRoute.quranListening)
        }
        .tabViewStyle(.carousel)
        .onAppear {
            if WatchListeningModeController.shouldAutoActivate(snapshot: store.quranPlayback) {
                selectedRoute = .quranListening
            }
        }
        .onChange(of: store.quranPlayback.isPlaying) { _, isPlaying in
            if isPlaying && (selectedRoute == .today || selectedRoute == .quranAudio) {
                selectedRoute = .quranListening
            }
            if !isPlaying && selectedRoute == .quranListening {
                selectedRoute = .quranAudio
            }
        }
        .onOpenURL { url in
            guard url.scheme == WatchSharedConstants.routeURLScheme,
                  let host = url.host,
                  let route = WatchRoute(rawValue: host) else {
                return
            }
            selectedRoute = route
        }
    }
}
