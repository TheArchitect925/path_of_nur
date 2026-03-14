import SwiftUI

struct WatchListeningModeView: View {
    @EnvironmentObject private var store: WatchAppStore
    @StateObject private var observer = WatchPlaybackStateObserver(
        snapshot: WatchQuranPlaybackSnapshot(
            playbackSessionId: "idle",
            sourceType: .phone,
            isPlaying: false,
            surahId: nil,
            surahName: "Resume Last Recitation",
            reciterId: "husary",
            reciterName: "Mahmoud Khalil Al-Husary",
            currentAyah: nil,
            positionSeconds: 0,
            durationSeconds: nil,
            isBuffering: false,
            lastUpdatedAt: Date()
        )
    )

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 10) {
                Text(observer.snapshot.surahName)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                Text(observer.snapshot.reciterName)
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                if let ayah = observer.snapshot.currentAyah {
                    Text("Ayah \(ayah)")
                        .font(.caption2)
                        .foregroundStyle(WatchTheme.textSecondary)
                } else if let duration = observer.snapshot.durationSeconds,
                          duration > 0 {
                    Text("\(observer.snapshot.positionSeconds)s / \(duration)s")
                        .font(.caption2)
                        .foregroundStyle(WatchTheme.textSecondary)
                }
                Button {
                    let command: WatchQuranPlaybackCommand = observer.snapshot.isPlaying ? .pause : .play
                    store.sendQuranCommand(command)
                } label: {
                    Text(observer.snapshot.isPlaying ? "Pause" : "Play")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!WatchListeningModeController.remoteCommandsEnabled(
                    snapshot: observer.snapshot,
                    phoneReachable: store.isPhonePlaybackReachable()
                ))

                HStack(spacing: 8) {
                    Button("<<") {
                        store.sendQuranCommand(.previous)
                    }
                    .disabled(!WatchListeningModeController.remoteCommandsEnabled(
                        snapshot: observer.snapshot,
                        phoneReachable: store.isPhonePlaybackReachable()
                    ))
                    Button(">>") {
                        store.sendQuranCommand(.next)
                    }
                    .disabled(!WatchListeningModeController.remoteCommandsEnabled(
                        snapshot: observer.snapshot,
                        phoneReachable: store.isPhonePlaybackReachable()
                    ))
                }
                .buttonStyle(.bordered)

                Text(
                    WatchListeningModeController.statusText(
                        snapshot: observer.snapshot,
                        phoneReachable: store.isPhonePlaybackReachable()
                    )
                )
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)

                Link(destination: WatchSharedConstants.routeURL(.quranAudio)) {
                    Text("Return to Player")
                }
                .buttonStyle(.plain)
                .foregroundStyle(WatchTheme.accent)
            }
            .padding()
        }
        .onAppear {
            observer.update(store.quranPlayback)
        }
        .onChange(of: store.quranPlayback.lastUpdatedAt) { _, _ in
            observer.update(store.quranPlayback)
        }
    }
}
