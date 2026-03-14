import SwiftUI

struct WatchSilentDhikrView: View {
    @EnvironmentObject private var store: WatchAppStore

    var body: some View {
        VStack(spacing: 10) {
            Text("Silent Dhikr")
                .font(.headline)
            Text("\(store.dhikrSession.currentCount)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(WatchTheme.accent)
            if let target = store.dhikrSession.targetCount {
                Text("\(min(store.dhikrSession.currentCount, target)) / \(target)")
                    .font(.caption2)
                    .foregroundStyle(WatchTheme.textSecondary)
            }
            Button("Tap to count") {
                store.incrementDhikr(silent: true)
            }
            .buttonStyle(.borderedProminent)
            Text("Follow calmly.")
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
        }
    }
}
