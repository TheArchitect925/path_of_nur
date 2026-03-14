import SwiftUI

struct WatchGuidedDhikrView: View {
    @EnvironmentObject private var store: WatchAppStore
    @State private var showPaceReminder = false

    var body: some View {
        VStack(spacing: 10) {
            Text("Guided Pulse")
                .font(.headline)
            Text("Target \(store.dhikrSession.pulseTargetCount ?? store.dhikrSession.targetCount ?? 33)")
                .font(.caption)
                .foregroundStyle(WatchTheme.textSecondary)
            Text("\(store.dhikrSession.currentCount)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(WatchTheme.accent)
            Text("Pulse \(store.pulseIntervalLabel)")
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
            HStack {
                Button("Slower") {
                    store.slowerGuidedPulse()
                }
                Button("Faster") {
                    store.fasterGuidedPulse()
                    showPaceReminder = store.fasterGuidedPulseBlocked
                }
            }
            .buttonStyle(.bordered)
            if store.dhikrSession.isPulseRunning {
                Button("Pause") { store.pauseGuidedDhikr() }
                    .buttonStyle(.borderedProminent)
            } else {
                Button(store.dhikrSession.currentCount == 0 ? "Start" : "Resume") { store.startGuidedDhikr() }
                    .buttonStyle(.borderedProminent)
            }
            Button("Stop") { store.stopGuidedDhikr() }
                .buttonStyle(.bordered)
            Text("Follow the pulse calmly.")
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
        }
        .alert("Take your time", isPresented: $showPaceReminder) {
            Button("Keep current pace", role: .cancel) {}
            Button("Return to steady pace") {
                store.resetGuidedPaceToSteady()
            }
        } message: {
            Text("Allah is looking for quality, presence, and sincerity — not speed. The pulse cannot go faster than 1.8 seconds.")
        }
    }
}
