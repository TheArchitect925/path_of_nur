import SwiftUI

struct WatchQuranPlayerView: View {
    @EnvironmentObject private var store: WatchAppStore
    @State private var showOutputSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Qur’an Audio")
                    .font(.headline)
                Text(store.quranPlayback.surahName)
                    .multilineTextAlignment(.center)
                    .font(.title3.weight(.semibold))
                Text(store.quranPlayback.reciterName)
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                Text(store.quranPlayback.sourceType == .phone ? "Playing on: Phone" : "Playing on: Watch")
                    .font(.caption2)
                    .foregroundStyle(WatchTheme.textSecondary)

                if let duration = store.quranPlayback.durationSeconds, duration > 0 {
                    ProgressView(
                        value: Double(store.quranPlayback.positionSeconds),
                        total: Double(duration)
                    )
                    .tint(WatchTheme.accent)
                }

                HStack(spacing: 8) {
                    Button("<<") {
                        store.sendQuranCommand(.previous)
                    }
                    Button(store.quranPlayback.isPlaying ? "Pause" : "Play") {
                        store.sendQuranCommand(store.quranPlayback.isPlaying ? .pause : .play)
                    }
                    Button(">>") {
                        store.sendQuranCommand(.next)
                    }
                }
                .buttonStyle(.borderedProminent)

                if !store.quranPlayback.isPlaying {
                    Button("Resume Last Recitation") {
                        store.sendQuranCommand(.resumeLast)
                    }
                }

                Button("Switch Output") {
                    showOutputSheet = true
                }
                .buttonStyle(.bordered)

                if store.quranPlayback.isPlaying || store.quranPlayback.positionSeconds > 0 {
                    Link(destination: WatchSharedConstants.routeURL(.quranListening)) {
                        Text("Listening Mode")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showOutputSheet) {
            WatchQuranOutputSelectionView(
                currentSource: store.quranPlayback.sourceType,
                availability: store.quranAvailability,
                onSelectPhone: {
                    showOutputSheet = false
                    store.sendQuranCommand(.switchOutputPhone)
                },
                onSelectWatch: {
                    showOutputSheet = false
                    store.sendQuranCommand(.switchOutputWatch)
                }
            )
        }
    }
}
