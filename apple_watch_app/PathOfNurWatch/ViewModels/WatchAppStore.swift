import Foundation
import WidgetKit

@MainActor
final class WatchAppStore: ObservableObject {
    @Published var snapshot: WatchDaySnapshot
    @Published var prayers: [WatchPrayerStatus]
    @Published var dhikrSession: WatchDhikrSession
    @Published var queue: [WatchSyncQueueItem]
    @Published var quranPlayback: WatchQuranPlaybackSnapshot
    @Published var quranAvailability: WatchAudioAvailabilitySnapshot
    @Published var fasterGuidedPulseBlocked = false

    private let store = WatchLocalStore()
    private let syncBridge: WatchSyncBridge
    private let dhikrEngine = WatchDhikrEngine()
    private let dhikrHaptics = WatchDhikrHapticEngine()
    private let refreshCoordinator: WatchBackgroundRefreshCoordinator
    private let quranPlaybackController: WatchQuranPlaybackController
    private let pulseEngine = WatchDhikrPulseEngine()

    init(syncBridge: WatchSyncBridge = StubWatchSyncBridge()) {
        self.syncBridge = syncBridge
        self.refreshCoordinator = WatchBackgroundRefreshCoordinator(syncBridge: syncBridge)
        self.quranPlaybackController = WatchQuranPlaybackController(store: store, bridge: syncBridge)
        let now = Date()
        let basePrayers = Self.mockPrayers(now: now)
        self.snapshot = store.loadSnapshot() ?? WatchDaySnapshot(
            date: now,
            timezone: TimeZone.current.identifier,
            nextPrayerId: "asr",
            nextPrayerTime: Calendar.current.date(bySettingHour: 16, minute: 42, second: 0, of: now) ?? now,
            currentPrayerId: "dhuhr",
            completedPrayerCount: 2,
            totalPrayerCount: 5,
            dhikrTodayCount: 64,
            xpToday: 42,
            oceanDropsToday: 3,
            streakDays: 18,
            lastSyncAt: now
        )
        self.prayers = store.loadPrayers().isEmpty ? basePrayers : store.loadPrayers()
        self.dhikrSession = store.loadDhikr() ?? WatchDhikrSession(
            sessionId: UUID().uuidString,
            mode: .preset33,
            targetCount: 33,
            currentCount: 0,
            startedAt: now,
            updatedAt: now,
            completed: false,
            completionMilestoneReached: false,
            rewardEligible: false,
            rewardGranted: false,
            interactionMode: .manualTap,
            pulseIntervalSeconds: 2.5,
            isPulseRunning: false,
            pulseTargetCount: 33,
            pulseCurrentStep: 0,
            paceReminderShownAt: nil,
            pausedAt: nil,
            source: .watch
        )
        self.queue = store.loadQueue()
        self.quranPlayback = store.loadQuranPlayback() ?? WatchQuranPlaybackSnapshot(
            playbackSessionId: UUID().uuidString,
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
            lastUpdatedAt: now
        )
        self.quranAvailability = store.loadQuranAvailability() ?? WatchAudioAvailabilitySnapshot(
            watchPlaybackAvailable: false,
            downloadedSurahIds: [],
            recentPlayableItems: [],
            lastSyncedAt: now
        )
        NotificationCenter.default.addObserver(
            forName: WatchSharedConstants.notificationDataDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.reloadFromStore()
        }
        WatchNotificationCoordinator.shared.refreshSchedules()
        Task {
            await refreshCoordinator.appLaunch()
            await refreshQuranPlayback()
        }
        if dhikrSession.interactionMode == .guidedPulse, dhikrSession.isPulseRunning {
            resumeGuidedPulseLoop()
        }
    }

    func markPrayer(_ prayerId: String, completed: Bool) {
        prayers = prayers.map { prayer in
            guard prayer.prayerId == prayerId else { return prayer }
            return WatchPrayerStatus(
                prayerId: prayer.prayerId,
                displayName: prayer.displayName,
                scheduledTime: prayer.scheduledTime,
                status: completed ? .completed : .pending,
                completedAt: completed ? Date() : nil,
                source: .watch
            )
        }
        snapshot.completedPrayerCount = prayers.filter { $0.status == .completed }.count
        enqueue(
            type: completed ? .prayerComplete : .prayerUncomplete,
            payload: ["prayerId": prayerId, "timestamp": ISO8601DateFormatter().string(from: Date())]
        )
        persist()
        Task { await refreshCoordinator.notifyPrayerCompletion() }
    }

    var pulseIntervalLabel: String {
        let value = dhikrSession.pulseIntervalSeconds ?? WatchDhikrPacePolicy.defaultInterval
        let raw = String(format: "%.2f", value)
        let trimmed = raw.hasSuffix(".00")
            ? String(raw.dropLast(3))
            : raw.hasSuffix("0")
                ? String(raw.dropLast())
                : raw
        return "\(trimmed)s"
    }

    func incrementDhikr(silent: Bool = false) {
        guard let outcome = dhikrEngine.increment(session: dhikrSession, todayTotal: snapshot.dhikrTodayCount) else {
            return
        }
        dhikrSession = outcome.session
        dhikrSession.pulseCurrentStep = dhikrSession.currentCount
        snapshot.dhikrTodayCount = outcome.todayTotal
        if outcome.rewardGranted {
            snapshot.oceanDropsToday += 1
        }
        enqueue(type: .dhikrIncrement, payload: [
            "sessionId": dhikrSession.sessionId,
            "amount": "1",
            "count": "\(dhikrSession.currentCount)"
        ])
        if outcome.shouldQueueCompletion {
            enqueue(type: .sessionComplete, payload: [
                "sessionId": dhikrSession.sessionId,
                "mode": dhikrSession.mode.rawValue,
                "count": "\(dhikrSession.currentCount)",
                "rewardGranted": dhikrSession.rewardGranted ? "true" : "false"
            ])
        }
        if silent {
            dhikrHaptics.playConfirmation()
        }
        dhikrHaptics.play(for: outcome.milestone)
        if dhikrSession.completed {
            pulseEngine.stop()
            dhikrSession.isPulseRunning = false
        }
        persist()
        Task { await refreshCoordinator.notifyDhikrUpdate() }
    }

    func startDhikrSession(mode: WatchDhikrMode) {
        if dhikrSession.currentCount > 0 {
            enqueue(type: .sessionComplete, payload: [
                "sessionId": dhikrSession.sessionId,
                "mode": dhikrSession.mode.rawValue,
                "count": "\(dhikrSession.currentCount)",
                "completed": dhikrSession.completed ? "true" : "false"
            ])
        }
        dhikrSession = dhikrEngine.newSession(mode: mode)
        pulseEngine.stop()
        enqueue(type: .dhikrReset, payload: ["mode": mode.rawValue])
        persist()
        Task { await refreshCoordinator.notifyDhikrUpdate() }
    }

    func resetDhikrSession() {
        if dhikrSession.currentCount > 0 {
            enqueue(type: .sessionComplete, payload: [
                "sessionId": dhikrSession.sessionId,
                "mode": dhikrSession.mode.rawValue,
                "count": "\(dhikrSession.currentCount)",
                "completed": dhikrSession.completed ? "true" : "false",
                "reset": "true"
            ])
        }
        dhikrSession = dhikrEngine.newSession(mode: dhikrSession.mode)
        pulseEngine.stop()
        enqueue(type: .dhikrReset, payload: ["mode": dhikrSession.mode.rawValue])
        persist()
        Task { await refreshCoordinator.notifyDhikrUpdate() }
    }

    func setDhikrInteractionMode(_ mode: WatchDhikrInteractionMode) {
        pulseEngine.stop()
        dhikrSession.interactionMode = mode
        dhikrSession.isPulseRunning = false
        fasterGuidedPulseBlocked = false
        if mode == .guidedPulse {
            if dhikrSession.mode == .free {
                dhikrSession.mode = .preset33
                dhikrSession.targetCount = 33
            }
            dhikrSession.pulseTargetCount = dhikrSession.mode == .preset33 ? 33 : 99
            dhikrSession.pulseIntervalSeconds = dhikrSession.pulseIntervalSeconds ?? WatchDhikrPacePolicy.defaultInterval
        }
        persist()
    }

    func fasterGuidedPulse() {
        let current = dhikrSession.pulseIntervalSeconds ?? WatchDhikrPacePolicy.defaultInterval
        switch WatchDhikrPacePolicy.faster(from: current) {
        case .updated(let next):
            fasterGuidedPulseBlocked = false
            dhikrSession.pulseIntervalSeconds = next
            persist()
            if dhikrSession.isPulseRunning {
                resumeGuidedPulseLoop()
            }
        case .blocked:
            let shouldShow = WatchDhikrPacePolicy.shouldShowReminder(lastShownAt: dhikrSession.paceReminderShownAt)
            dhikrSession.paceReminderShownAt = Date()
            fasterGuidedPulseBlocked = shouldShow
            persist()
        }
    }

    func slowerGuidedPulse() {
        let current = dhikrSession.pulseIntervalSeconds ?? WatchDhikrPacePolicy.defaultInterval
        if case .updated(let next) = WatchDhikrPacePolicy.slower(from: current) {
            fasterGuidedPulseBlocked = false
            dhikrSession.pulseIntervalSeconds = next
            persist()
            if dhikrSession.isPulseRunning {
                resumeGuidedPulseLoop()
            }
        }
    }

    func resetGuidedPaceToSteady() {
        dhikrSession.pulseIntervalSeconds = WatchDhikrPacePolicy.steadyInterval
        fasterGuidedPulseBlocked = false
        persist()
        if dhikrSession.isPulseRunning {
            resumeGuidedPulseLoop()
        }
    }

    func startGuidedDhikr() {
        if dhikrSession.interactionMode != .guidedPulse {
            setDhikrInteractionMode(.guidedPulse)
        }
        dhikrSession.isPulseRunning = true
        dhikrSession.pausedAt = nil
        persist()
        resumeGuidedPulseLoop()
    }

    func pauseGuidedDhikr() {
        pulseEngine.stop()
        dhikrSession.isPulseRunning = false
        dhikrSession.pausedAt = Date()
        persist()
    }

    func stopGuidedDhikr() {
        pulseEngine.stop()
        dhikrSession.isPulseRunning = false
        dhikrSession.pausedAt = Date()
        persist()
    }

    func flushSync() async {
        queue = await syncBridge.flush(queue: queue)
        persist()
        _ = await refreshCoordinator.orchestrator.handle(.syncComplete)
        await refreshQuranPlayback()
    }

    func refreshQuranPlayback() async {
        if let refreshed = await quranPlaybackController.refreshFromBridge() {
            quranPlayback = refreshed.0
            quranAvailability = refreshed.1
            persist()
        }
    }

    func sendQuranCommand(_ command: WatchQuranPlaybackCommand) {
        Task {
            let next = await quranPlaybackController.handle(
                command: command,
                current: quranPlayback,
                availability: quranAvailability
            )
            quranPlayback = next
            if command == .switchOutputWatch || command == .switchOutputPhone {
                quranAvailability = quranPlaybackController.loadAvailability()
            }
            enqueue(
                type: .quranPlaybackCommand,
                payload: [
                    "command": command.rawValue,
                    "sessionId": quranPlayback.playbackSessionId,
                    "sourceType": quranPlayback.sourceType.rawValue
                ]
            )
            persist()
        }
    }

    func isPhonePlaybackReachable() -> Bool {
        quranPlaybackController.isPhoneReachable()
    }

    private func enqueue(type: WatchSyncItemType, payload: [String: String]) {
        queue.append(
            WatchSyncQueueItem(
                id: UUID().uuidString,
                type: type,
                payload: payload,
                createdAt: Date(),
                syncStatus: .pending,
                retryCount: 0
            )
        )
    }

    private func persist() {
        store.saveSnapshot(snapshot)
        store.savePrayers(prayers)
        store.saveDhikr(dhikrSession)
        store.saveQueue(queue)
        store.saveQuranPlayback(quranPlayback)
        store.saveQuranAvailability(quranAvailability)
        WidgetCenter.shared.reloadAllTimelines()
        WatchNotificationCoordinator.shared.refreshSchedules()
        NotificationCenter.default.post(name: WatchSharedConstants.notificationDataDidChange, object: nil)
    }

    private func resumeGuidedPulseLoop() {
        let interval = dhikrSession.pulseIntervalSeconds ?? WatchDhikrPacePolicy.defaultInterval
        pulseEngine.start(interval: interval) { [weak self] in
            Task { @MainActor in
                guard let self, self.dhikrSession.isPulseRunning else { return }
                self.dhikrHaptics.playGuidancePulse()
                self.incrementDhikr()
                if self.dhikrSession.completed {
                    self.pauseGuidedDhikr()
                }
            }
        }
    }

    private func reloadFromStore() {
        if let storedSnapshot = store.loadSnapshot() {
            snapshot = storedSnapshot
        }
        let storedPrayers = store.loadPrayers()
        if !storedPrayers.isEmpty {
            prayers = storedPrayers
        }
        if let storedDhikr = store.loadDhikr() {
            dhikrSession = storedDhikr
        }
        if let storedQuran = store.loadQuranPlayback() {
            quranPlayback = storedQuran
        }
        if let storedAvailability = store.loadQuranAvailability() {
            quranAvailability = storedAvailability
        }
        queue = store.loadQueue()
    }

    private static func mockPrayers(now: Date) -> [WatchPrayerStatus] {
        let calendar = Calendar.current
        let items: [(String, String, Int, Int, WatchPrayerState)] = [
            ("fajr", "Fajr", 5, 18, .completed),
            ("dhuhr", "Dhuhr", 13, 9, .completed),
            ("asr", "Asr", 16, 42, .pending),
            ("maghrib", "Maghrib", 19, 18, .pending),
            ("isha", "Isha", 20, 47, .pending)
        ]
        return items.map { id, name, hour, minute, state in
            WatchPrayerStatus(
                prayerId: id,
                displayName: name,
                scheduledTime: calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now,
                status: state,
                completedAt: state == .completed ? now : nil,
                source: .phone
            )
        }
    }
}
