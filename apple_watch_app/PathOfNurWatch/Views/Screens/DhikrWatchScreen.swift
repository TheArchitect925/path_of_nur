import SwiftUI

struct DhikrWatchScreen: View {
    @EnvironmentObject private var store: WatchAppStore
    @State private var showReset = false
    @State private var pendingMode: WatchDhikrMode?
    @State private var showModeChangeConfirmation = false
    @State private var pendingInteractionMode: WatchDhikrInteractionMode?
    @State private var showInteractionModeChangeConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Dhikr")
                    .font(.headline)
                Picker("Style", selection: Binding(
                    get: { store.dhikrSession.interactionMode },
                    set: { newMode in
                        guard newMode != store.dhikrSession.interactionMode else { return }
                        if store.dhikrSession.currentCount > 0 {
                            pendingInteractionMode = newMode
                            showInteractionModeChangeConfirmation = true
                        } else {
                            store.setDhikrInteractionMode(newMode)
                        }
                    }
                )) {
                    Text("Manual").tag(WatchDhikrInteractionMode.manualTap)
                    Text("Silent").tag(WatchDhikrInteractionMode.silentTap)
                    Text("Guided").tag(WatchDhikrInteractionMode.guidedPulse)
                }
                Text(modeLabel(store.dhikrSession.mode))
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                if store.dhikrSession.interactionMode == .guidedPulse {
                    WatchGuidedDhikrView()
                } else if store.dhikrSession.interactionMode == .silentTap {
                    WatchSilentDhikrView()
                } else {
                    Text("\(store.dhikrSession.currentCount)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(WatchTheme.accent)
                    if let target = store.dhikrSession.targetCount {
                        ProgressView(value: Double(store.dhikrSession.currentCount), total: Double(target))
                            .tint(WatchTheme.accent)
                        Text("\(min(store.dhikrSession.currentCount, target)) / \(target)")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textSecondary)
                    }
                    if store.dhikrSession.completed {
                        Text(store.dhikrSession.mode == .preset33 ? "33 complete" : store.dhikrSession.mode == .preset99 ? "99 complete" : "Session complete")
                            .font(.caption)
                            .foregroundStyle(WatchTheme.accent)
                    }
                    Button {
                        store.incrementDhikr()
                    } label: {
                        Text("Tap to count")
                            .frame(maxWidth: .infinity, minHeight: 56)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Picker("Mode", selection: Binding(
                    get: { store.dhikrSession.mode },
                    set: { newMode in
                        guard newMode != store.dhikrSession.mode else { return }
                        if store.dhikrSession.currentCount > 0 {
                            pendingMode = newMode
                            showModeChangeConfirmation = true
                        } else {
                            store.startDhikrSession(mode: newMode)
                        }
                    }
                )) {
                    Text("33").tag(WatchDhikrMode.preset33)
                    Text("99").tag(WatchDhikrMode.preset99)
                    Text("Free").tag(WatchDhikrMode.free)
                }

                Text("Today \(store.snapshot.dhikrTodayCount)")
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)

                Button("Reset") {
                    showReset = true
                }
                .confirmationDialog("Reset session?", isPresented: $showReset) {
                    Button("Reset", role: .destructive) {
                        store.resetDhikrSession()
                    }
                }
                .confirmationDialog("Start a new dhikr session?", isPresented: $showModeChangeConfirmation) {
                    Button("Start New", role: .destructive) {
                        if let pendingMode {
                            store.startDhikrSession(mode: pendingMode)
                        }
                        pendingMode = nil
                    }
                    Button("Cancel", role: .cancel) {
                        pendingMode = nil
                    }
                }
                .confirmationDialog("Start a new dhikr session?", isPresented: $showInteractionModeChangeConfirmation) {
                    Button("Start New", role: .destructive) {
                        if let pendingInteractionMode {
                            store.startDhikrSession(mode: store.dhikrSession.mode)
                            store.setDhikrInteractionMode(pendingInteractionMode)
                        }
                        pendingInteractionMode = nil
                    }
                    Button("Cancel", role: .cancel) {
                        pendingInteractionMode = nil
                    }
                }
            }
            .padding()
        }
    }

    private func modeLabel(_ mode: WatchDhikrMode) -> String {
        switch mode {
        case .preset33: return "Target 33"
        case .preset99: return "Target 99"
        case .free: return "Free"
        }
    }
}
