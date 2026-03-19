import Foundation
import SwiftUI
import WidgetKit

@MainActor
final class WatchAppModel: ObservableObject {
  @Published private(set) var snapshot: WatchDailySnapshotPayload?
  @Published private(set) var settings: WatchSettingsPayload?
  @Published private(set) var dashboardState: WatchDashboardState?
  @Published private(set) var prayerState: WatchPrayerState
  @Published private(set) var dhikrState: WatchDhikrSessionState
  @Published private(set) var autoDhikrState: WatchAutoDhikrSessionState
  @Published private(set) var progressState: WatchProgressState?
  @Published private(set) var postPrayerAdhkarState: WatchPostPrayerAdhkarState?
  @Published private(set) var syncBadgeState: WatchSyncBadgeState = .cached
  @Published var showDhikrAntiRushReminder = false
  @Published var focusedPrayerId: String?
  @Published var selectedTab: WatchRootTab = .home
  @Published var dhikrMode: WatchDhikrMode
  @Published var hapticsEnabled: Bool

  private let cacheStore: WatchCacheStore
  private let syncService: WatchSyncService
  private var notificationObservers: [NSObjectProtocol] = []
  private var dhikrSessionId: String
  private var autoDhikrTimer: Timer?
  private var recentDhikrTapTimes: [Date] = []
  private var lastDhikrAntiRushReminderAt: Date?

  init(
    cacheStore: WatchCacheStore = WatchCacheStore(),
    syncService: WatchSyncService? = nil
  ) {
    self.cacheStore = cacheStore
    self.syncService = syncService ?? WatchSyncService(cacheStore: cacheStore)
    self.hapticsEnabled = cacheStore.hapticsEnabled()

    let cachedSnapshot = cacheStore.loadSnapshot()
    let cachedSettings = cacheStore.loadSettings()
    let cachedPostPrayerAdhkarState = cacheStore.loadPostPrayerAdhkarState()
    let defaultPreset = cacheStore.defaultDhikrPreset()
    let cachedAutoPreferences = cacheStore.loadAutoDhikrPreferences()
    let cachedAutoDhikrState = cacheStore.loadAutoDhikrSession()
    let initialCount = cachedSnapshot?.activeDhikrSession?.currentCount ?? 0
    self.snapshot = cachedSnapshot
    self.settings = cachedSettings
    self.prayerState = WatchPrayerState(prayers: cachedSnapshot?.prayers ?? [])
    self.postPrayerAdhkarState = cachedPostPrayerAdhkarState
    self.dhikrSessionId = cachedSnapshot?.activeDhikrSession?.sessionId
        ?? "watch-dhikr-\(UUID().uuidString)"
    self.dhikrState = WatchDhikrSessionState(
      preset: WatchDhikrPreset.from(target: cachedSnapshot?.activeDhikrSession?.targetCount ?? defaultPreset.target),
      count: initialCount,
      target: cachedSnapshot?.activeDhikrSession?.targetCount ?? defaultPreset.target,
      phrase: WatchDhikrPreset.from(target: cachedSnapshot?.activeDhikrSession?.targetCount ?? defaultPreset.target).phrase,
      isComplete: initialCount >= (cachedSnapshot?.activeDhikrSession?.targetCount ?? defaultPreset.target)
    )
    let normalizedAutoState: WatchAutoDhikrSessionState
    if var cachedAutoDhikrState {
      if cachedAutoDhikrState.phase == .running {
        cachedAutoDhikrState.phase = .paused
        cachedAutoDhikrState.updatedAt = Date()
      }
      normalizedAutoState = cachedAutoDhikrState
    } else {
      normalizedAutoState = WatchAutoDhikrSessionState.default(
        preferences: cachedAutoPreferences,
        sessionId: "watch-auto-dhikr-\(UUID().uuidString)"
      )
    }
    self.autoDhikrState = normalizedAutoState
    self.dhikrMode =
      normalizedAutoState.isActive || normalizedAutoState.isCompleted
      ? .auto
      : cacheStore.loadDhikrMode()
    recomputeStates()
    registerForSyncNotifications()

    Task {
      await refresh()
      await flushPendingActions()
    }
  }

  deinit {
    autoDhikrTimer?.invalidate()
    for observer in notificationObservers {
      NotificationCenter.default.removeObserver(observer)
    }
  }

  var pendingActionCount: Int {
    cacheStore.loadPendingActions().count
  }

  func refresh() async {
    if let result = await syncService.fetchLatestSnapshot() {
      snapshot = result.0
      settings = result.1 ?? settings
      refreshDerivedSnapshotFields()
      if let settings = result.1 {
        cacheStore.saveSettings(settings)
      }
    }
    recomputeStates()
  }

  func syncNow() async {
    if let result = await syncService.syncNow() {
      snapshot = result.0
      settings = result.1 ?? settings
      refreshDerivedSnapshotFields()
      if let settings = result.1 {
        cacheStore.saveSettings(settings)
      }
    }
    recomputeStates()
  }

  func setHapticsEnabled(_ enabled: Bool) {
    hapticsEnabled = enabled
    cacheStore.setHapticsEnabled(enabled)
  }

  func setDefaultDhikrPreset(_ preset: WatchDhikrPreset) {
    cacheStore.setDefaultDhikrPreset(preset)
    dhikrState = WatchDhikrSessionState(
      preset: preset,
      count: 0,
      target: preset.target,
      phrase: preset.phrase,
      isComplete: false
    )
    applyDhikrSessionToSnapshot()
    recomputeStates()
  }

  func setDhikrMode(_ mode: WatchDhikrMode) {
    dhikrMode = mode
    cacheStore.setDhikrMode(mode)
  }

  func selectAutoDhikrPhrase(_ phrase: WatchAutoDhikrPhrase) {
    autoDhikrState.phrase = phrase
    autoDhikrState.updatedAt = Date()
    persistAutoDhikrState()
    recomputeStates()
  }

  func selectAutoDhikrTarget(_ target: Int) {
    autoDhikrState.target = target
    autoDhikrState.updatedAt = Date()
    persistAutoDhikrState()
    recomputeStates()
  }

  func slowerAutoDhikr() {
    setAutoDhikrInterval(autoDhikrState.intervalSeconds + WatchAutoDhikrPreferences.intervalStep)
  }

  func fasterAutoDhikr() {
    setAutoDhikrInterval(autoDhikrState.intervalSeconds - WatchAutoDhikrPreferences.intervalStep)
  }

  func beginAutoDhikr() {
    if autoDhikrState.isCompleted || autoDhikrState.phase == .idle {
      autoDhikrState.count = 0
      autoDhikrState.completedAt = nil
      autoDhikrState.startedAt = Date()
      autoDhikrState.lastTickAt = nil
      autoDhikrState.sessionId = newAutoDhikrSessionId()
    } else if autoDhikrState.startedAt == nil {
      autoDhikrState.startedAt = Date()
    }

    autoDhikrState.phase = .running
    autoDhikrState.updatedAt = Date()
    setDhikrMode(.auto)
    persistAutoDhikrState()
    applyAutoDhikrStateToSnapshot()
    scheduleAutoDhikrTimer()
    WatchHaptics.autoDhikrControl(enabled: hapticsEnabled)
    sendAutoDhikrStarted()
    recomputeStates()
  }

  func pauseAutoDhikr() {
    guard autoDhikrState.isRunning else { return }
    autoDhikrState.phase = .paused
    autoDhikrState.updatedAt = Date()
    autoDhikrTimer?.invalidate()
    autoDhikrTimer = nil
    persistAutoDhikrState()
    queueAutoDhikrCheckpoint()
    WatchHaptics.autoDhikrControl(enabled: hapticsEnabled)
    recomputeStates()
  }

  func resumeAutoDhikr() {
    guard autoDhikrState.isPaused, !autoDhikrState.isCompleted else { return }
    autoDhikrState.phase = .running
    autoDhikrState.updatedAt = Date()
    persistAutoDhikrState()
    scheduleAutoDhikrTimer()
    WatchHaptics.autoDhikrControl(enabled: hapticsEnabled)
    recomputeStates()
  }

  func endAutoDhikr() {
    let didAdvance = autoDhikrState.count > 0
    autoDhikrTimer?.invalidate()
    autoDhikrTimer = nil
    if didAdvance {
      sendAutoDhikrReset()
    }
    resetAutoDhikrState(keepPreferences: true)
    WatchHaptics.autoDhikrControl(enabled: hapticsEnabled)
    recomputeStates()
  }

  func dismissAutoDhikrCompletion() {
    resetAutoDhikrState(keepPreferences: true)
    recomputeStates()
  }

  func updatePrayer(
    prayerId: String,
    status: WatchPrayerStatusValue,
    timing: WatchPrayerTimingValue?,
    offerPostPrayerAdhkar: Bool = true,
    source: String = "watch"
  ) {
    guard var snapshot else { return }
    guard let index = snapshot.prayers.firstIndex(where: { $0.prayerId == prayerId }) else {
      return
    }
    let previous = snapshot.prayers[index]
    let delta = WatchRewardProjection.prayerDelta(previous: previous.status, next: status)
    snapshot.prayers[index] = WatchPrayerPayload(
      prayerId: previous.prayerId,
      displayName: previous.displayName,
      scheduledTime: previous.scheduledTime,
      status: status,
      completedAt: status == .completed ? Date() : nil,
      timing: timing?.rawValue,
      source: source,
    )
    snapshot.completedPrayerCount = snapshot.prayers.filter { $0.status == .completed }.count
    snapshot.xpToday = max(0, snapshot.xpToday + delta.xp)
    snapshot.oceanDropsToday = max(0, snapshot.oceanDropsToday + delta.drops)
    self.snapshot = snapshot
    refreshDerivedSnapshotFields()
    if status == .completed {
      if offerPostPrayerAdhkar {
        self.offerPostPrayerAdhkar(for: snapshot.prayers[index])
      }
      WatchHaptics.success(enabled: hapticsEnabled)
    } else {
      WatchHaptics.confirmation(enabled: hapticsEnabled)
    }

    var payload: [String: String] = [
      "prayerId": prayerId,
      "status": status.rawValue,
    ]
    if let timing {
      payload["timing"] = timing.rawValue
    }

    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .prayerStatusUpdated,
      createdAt: Date(),
      logicalDate: snapshot.date,
      payload: payload,
      sourceVersion: "1"
    )
    recomputeStates()

    Task {
      if let response = await syncService.sendAction(action) {
        snapshot = response.snapshot
        self.snapshot = response.snapshot
        refreshDerivedSnapshotFields()
        recomputeStates()
      } else {
        recomputeStates()
      }
    }
  }

  func handlePrayerReminderAction(
    prayerId: String,
    timing: WatchPrayerTimingValue
  ) {
    updatePrayer(
      prayerId: prayerId,
      status: .completed,
      timing: timing,
      offerPostPrayerAdhkar: false,
      source: "watch_notification"
    )
  }

  func logPrayerReminderSnoozeRequested(
    prayerId: String,
    logicalDate: String,
    minutes: Int
  ) {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .snoozeRequested,
      createdAt: Date(),
      logicalDate: logicalDate,
      payload: [
        "prayerId": prayerId,
        "minutes": "\(minutes)",
        "source": "watch_notification",
      ],
      sourceVersion: "1"
    )
    WatchHaptics.confirmation(enabled: hapticsEnabled)
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  var isPhoneReachableForSync: Bool {
    syncService.isReachable
  }

  var prayerReminderSnoozeMinutes: Int {
    max(settings?.snoozeDurationMinutes ?? 10, 1)
  }

  var quietModeEnabled: Bool {
    settings?.quietModeEnabled ?? false
  }

  func incrementDhikr() {
    let wasZero = dhikrState.count == 0
    let nextCount = dhikrState.count + 1
    let target = dhikrState.target
    let completed = nextCount >= target
    dhikrState = WatchDhikrSessionState(
      preset: dhikrState.preset,
      count: nextCount,
      target: target,
      phrase: dhikrState.phrase,
      isComplete: completed
    )
    WatchHaptics.increment(enabled: hapticsEnabled)
    if nextCount % 10 == 0 {
      WatchHaptics.milestone(enabled: hapticsEnabled)
    }
    if completed {
      WatchHaptics.success(enabled: hapticsEnabled)
    }
    if shouldPresentDhikrAntiRushReminder(at: Date()) {
      showDhikrAntiRushReminder = true
      WatchHaptics.antiRush(enabled: hapticsEnabled)
    }
    applyDhikrSessionToSnapshot()
    if wasZero {
      sendDhikrStarted()
    }
    if nextCount % 10 == 0 || completed {
      queueDhikrCheckpoint()
    }
    recomputeStates()
  }

  func resetDhikr() {
    recentDhikrTapTimes.removeAll()
    showDhikrAntiRushReminder = false
    let previousSessionId = dhikrSessionId
    let previousMode = dhikrState.preset.syncMode
    dhikrState = WatchDhikrSessionState(
      preset: dhikrState.preset,
      count: 0,
      target: dhikrState.target,
      phrase: dhikrState.phrase,
      isComplete: false
    )
    dhikrSessionId = newDhikrSessionId()
    applyDhikrSessionToSnapshot()
    queueDhikrReset(sessionId: previousSessionId, mode: previousMode)
    recomputeStates()
  }

  func finishDhikrSession() {
    guard dhikrState.count > 0 else { return }
    recentDhikrTapTimes.removeAll()
    showDhikrAntiRushReminder = false
    if var snapshot {
      let delta = WatchRewardProjection.dhikrCompletionDelta(
        completedTarget: dhikrState.isComplete
      )
      snapshot.xpToday += delta.xp
      snapshot.oceanDropsToday += delta.drops
      snapshot.activeDhikrSession = nil
      self.snapshot = snapshot
      refreshDerivedSnapshotFields()
    }

    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrSessionCompleted,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "sessionId": dhikrSessionId,
        "mode": dhikrState.preset.syncMode,
        "targetCount": "\(dhikrState.target)",
        "count": "\(dhikrState.count)",
      ],
      sourceVersion: "1"
    )
    WatchHaptics.success(enabled: hapticsEnabled)
    Task {
      if let response = await syncService.sendAction(action) {
        snapshot = response.snapshot
        self.snapshot = response.snapshot
        refreshDerivedSnapshotFields()
      }
      dhikrState = WatchDhikrSessionState(
        preset: dhikrState.preset,
        count: 0,
        target: dhikrState.target,
        phrase: dhikrState.phrase,
        isComplete: false
      )
      dhikrSessionId = newDhikrSessionId()
      recomputeStates()
    }
  }

  func selectDhikrPreset(_ preset: WatchDhikrPreset) {
    cacheStore.setDefaultDhikrPreset(preset)
    recentDhikrTapTimes.removeAll()
    showDhikrAntiRushReminder = false
    dhikrSessionId = newDhikrSessionId()
    dhikrState = WatchDhikrSessionState(
      preset: preset,
      count: 0,
      target: preset.target,
      phrase: preset.phrase,
      isComplete: false
    )
    applyDhikrSessionToSnapshot()
    recomputeStates()
  }

  func handleScenePhase(_ phase: ScenePhase) {
    switch phase {
    case .active:
      Task {
        await refresh()
        await flushPendingActions()
      }
    case .background:
      pauseAutoDhikrForInterruption()
      queueDhikrCheckpoint()
      persistPostPrayerAdhkarState()
    default:
      break
    }
  }

  func dismissDhikrAntiRushReminder() {
    showDhikrAntiRushReminder = false
  }

  private func shouldPresentDhikrAntiRushReminder(at timestamp: Date) -> Bool {
    recentDhikrTapTimes.append(timestamp)
    let rapidTapWindow: TimeInterval = 2
    let cooldown: TimeInterval = 45
    let minimumTapCount = 8
    let averageIntervalThreshold: TimeInterval = 0.25
    recentDhikrTapTimes.removeAll { timestamp.timeIntervalSince($0) > rapidTapWindow }

    guard recentDhikrTapTimes.count >= minimumTapCount else {
      return false
    }
    if let lastReminder = lastDhikrAntiRushReminderAt,
       timestamp.timeIntervalSince(lastReminder) < cooldown {
      return false
    }
    guard let firstTap = recentDhikrTapTimes.first else {
      return false
    }
    let totalWindow = timestamp.timeIntervalSince(firstTap)
    guard totalWindow <= rapidTapWindow else {
      return false
    }
    let intervalCount = max(recentDhikrTapTimes.count - 1, 1)
    let averageInterval = totalWindow / Double(intervalCount)
    guard averageInterval <= averageIntervalThreshold else {
      return false
    }

    lastDhikrAntiRushReminderAt = timestamp
    recentDhikrTapTimes.removeAll()
    return true
  }

  func startPostPrayerAdhkar(for prayer: WatchPrayerPayload) {
    let state = WatchPostPrayerAdhkarState.default(for: prayer)
    postPrayerAdhkarState = state
    cacheStore.savePostPrayerAdhkarState(state)
    selectedTab = .prayer
    WatchHaptics.confirmation(enabled: hapticsEnabled)
  }

  func advancePostPrayerAdhkar() {
    guard var state = postPrayerAdhkarState, !state.isComplete else { return }
    guard state.steps.indices.contains(state.currentStepIndex) else { return }

    state.steps[state.currentStepIndex].count += 1
    state.updatedAt = Date()
    let step = state.steps[state.currentStepIndex]
    let reachedTarget = step.count >= step.kind.targetCount

    WatchHaptics.increment(enabled: hapticsEnabled)

    if reachedTarget {
      if state.currentStepIndex == state.steps.count - 1 {
        state.completedAt = Date()
        postPrayerAdhkarState = state
        cacheStore.savePostPrayerAdhkarState(state)
        WatchHaptics.completion(enabled: hapticsEnabled)
        sendPostPrayerAdhkarCompletion(state)
        return
      }
      state.currentStepIndex += 1
      WatchHaptics.milestone(enabled: hapticsEnabled)
    }

    postPrayerAdhkarState = state
    cacheStore.savePostPrayerAdhkarState(state)
  }

  func skipPostPrayerAdhkar() {
    postPrayerAdhkarState = nil
    cacheStore.clearPostPrayerAdhkarState()
  }

  func finishPostPrayerAdhkarPrompt() {
    postPrayerAdhkarState = nil
    cacheStore.clearPostPrayerAdhkarState()
  }

  func handleOpenURL(_ url: URL) {
    let destination = url.host ?? url.lastPathComponent
    let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    let prayerId = queryItems?
      .first(where: { $0.name == "prayerId" })?
      .value
    let dhikrModeQuery = queryItems?
      .first(where: { $0.name == "mode" })?
      .value
    switch destination {
    case "prayer":
      selectedTab = .prayer
      focusPrayer(prayerId)
    case "dhikr":
      selectedTab = .dhikr
      if dhikrModeQuery == WatchDhikrMode.auto.rawValue {
        setDhikrMode(.auto)
      }
      focusedPrayerId = nil
    case "progress":
      selectedTab = .progress
      focusedPrayerId = nil
    case "utility":
      selectedTab = .utility
      focusedPrayerId = nil
    default:
      selectedTab = .home
      focusedPrayerId = nil
    }
    WatchHaptics.confirmation(enabled: hapticsEnabled)

    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .notificationActionLogged,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "destination": destination,
        "url": url.absoluteString,
      ],
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
    }
  }

  func clearFocusedPrayer() {
    focusedPrayerId = nil
  }

  private func focusPrayer(_ prayerId: String?) {
    guard let prayerId, !prayerId.isEmpty else {
      focusedPrayerId = nil
      return
    }
    if focusedPrayerId == prayerId {
      focusedPrayerId = nil
      Task { @MainActor in
        focusedPrayerId = prayerId
      }
    } else {
      focusedPrayerId = prayerId
    }
  }

  func flushPendingActions() async {
    if let result = await syncService.flushPendingActions() {
      snapshot = result.0
      settings = result.1 ?? settings
      refreshDerivedSnapshotFields()
      if let settings = result.1 {
        cacheStore.saveSettings(settings)
      }
    }
    recomputeStates()
  }

  private func queueDhikrCheckpoint() {
    guard dhikrState.count > 0 else { return }
    let incrementAction = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrIncrement,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "sessionId": dhikrSessionId,
        "mode": dhikrState.preset.syncMode,
        "targetCount": "\(dhikrState.target)",
        "count": "\(dhikrState.count)",
      ],
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(incrementAction)
      recomputeStates()
    }
  }

  private func sendDhikrStarted() {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrSessionStarted,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "sessionId": dhikrSessionId,
        "mode": dhikrState.preset.syncMode,
        "targetCount": "\(dhikrState.target)",
      ],
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  private func queueDhikrReset(sessionId: String, mode: String) {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrReset,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "sessionId": sessionId,
        "mode": mode,
      ],
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  private func setAutoDhikrInterval(_ seconds: Double) {
    let clamped = WatchAutoDhikrPreferences.clampedInterval(seconds)
    guard abs(clamped - autoDhikrState.intervalSeconds) > 0.001 else { return }
    autoDhikrState.intervalSeconds = clamped
    autoDhikrState.updatedAt = Date()
    persistAutoDhikrState()
    WatchHaptics.autoDhikrControl(enabled: hapticsEnabled)
    if autoDhikrState.isRunning {
      scheduleAutoDhikrTimer()
    }
    recomputeStates()
  }

  private func scheduleAutoDhikrTimer() {
    autoDhikrTimer?.invalidate()
    guard autoDhikrState.isRunning, !autoDhikrState.isCompleted else { return }
    let interval = WatchAutoDhikrPreferences.clampedInterval(autoDhikrState.intervalSeconds)
    let timer = Timer(timeInterval: interval, repeats: false) { [weak self] _ in
      Task { @MainActor in
        self?.handleAutoDhikrTick()
      }
    }
    timer.tolerance = min(0.25, interval * 0.2)
    autoDhikrTimer = timer
    RunLoop.main.add(timer, forMode: .common)
  }

  private func handleAutoDhikrTick() {
    guard autoDhikrState.isRunning else { return }
    let nextCount = min(autoDhikrState.count + 1, autoDhikrState.target)
    autoDhikrState.count = nextCount
    autoDhikrState.lastTickAt = Date()
    autoDhikrState.updatedAt = Date()

    if nextCount >= autoDhikrState.target {
      autoDhikrState.phase = .completed
      autoDhikrState.completedAt = Date()
      autoDhikrTimer?.invalidate()
      autoDhikrTimer = nil
      WatchHaptics.success(enabled: hapticsEnabled)
      finishAutoDhikrSession()
      return
    }

    if nextCount % 10 == 0 {
      WatchHaptics.milestone(enabled: hapticsEnabled)
      queueAutoDhikrCheckpoint()
    } else {
      WatchHaptics.autoDhikrTick(
        enabled: hapticsEnabled,
        intervalSeconds: autoDhikrState.intervalSeconds
      )
    }

    persistAutoDhikrState()
    applyAutoDhikrStateToSnapshot()
    scheduleAutoDhikrTimer()
    recomputeStates()
  }

  private func finishAutoDhikrSession() {
    guard autoDhikrState.isCompleted else { return }
    if var snapshot {
      let delta = WatchRewardProjection.dhikrCompletionDelta(completedTarget: true)
      snapshot.xpToday += delta.xp
      snapshot.oceanDropsToday += delta.drops
      snapshot.dhikrTodayCount = max(snapshot.dhikrTodayCount, autoDhikrState.count)
      snapshot.activeDhikrSession = nil
      self.snapshot = snapshot
      refreshDerivedSnapshotFields()
    }

    persistAutoDhikrState()
    sendAutoDhikrCompleted()
    recomputeStates()
  }

  private func sendAutoDhikrStarted() {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrSessionStarted,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: autoDhikrPayload(includeCount: true),
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  private func queueAutoDhikrCheckpoint() {
    guard autoDhikrState.count > 0 else { return }
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrIncrement,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: autoDhikrPayload(includeCount: true),
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  private func sendAutoDhikrReset() {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrReset,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: autoDhikrPayload(includeCount: true),
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
      recomputeStates()
    }
  }

  private func sendAutoDhikrCompleted() {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .dhikrSessionCompleted,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: autoDhikrPayload(includeCount: true),
      sourceVersion: "1"
    )
    Task {
      if let response = await syncService.sendAction(action) {
        snapshot = response.snapshot
        self.snapshot = response.snapshot
        refreshDerivedSnapshotFields()
      }
      recomputeStates()
    }
  }

  private func autoDhikrPayload(includeCount: Bool) -> [String: String] {
    var payload: [String: String] = [
      "sessionId": autoDhikrState.sessionId,
      "mode": autoDhikrState.phrase.syncMode,
      "targetCount": "\(autoDhikrState.target)",
      "phrase": autoDhikrState.phrase.rawValue,
      "intervalSeconds": String(format: "%.1f", autoDhikrState.intervalSeconds),
      "autoMode": "true",
    ]
    if includeCount {
      payload["count"] = "\(autoDhikrState.count)"
    }
    if let startedAt = autoDhikrState.startedAt {
      payload["startedAt"] = WatchCodec.iso8601.string(from: startedAt)
    }
    return payload
  }

  private func pauseAutoDhikrForInterruption() {
    guard autoDhikrState.isRunning else { return }
    autoDhikrState.phase = .paused
    autoDhikrState.updatedAt = Date()
    autoDhikrTimer?.invalidate()
    autoDhikrTimer = nil
    persistAutoDhikrState()
    queueAutoDhikrCheckpoint()
  }

  private func persistAutoDhikrState() {
    let preferences = WatchAutoDhikrPreferences(
      phrase: autoDhikrState.phrase,
      target: autoDhikrState.target,
      intervalSeconds: autoDhikrState.intervalSeconds
    )
    cacheStore.saveAutoDhikrPreferences(preferences)
    cacheStore.saveAutoDhikrSession(autoDhikrState)
  }

  private func resetAutoDhikrState(keepPreferences: Bool) {
    autoDhikrTimer?.invalidate()
    autoDhikrTimer = nil
    let preferences = keepPreferences
      ? WatchAutoDhikrPreferences(
          phrase: autoDhikrState.phrase,
          target: autoDhikrState.target,
          intervalSeconds: autoDhikrState.intervalSeconds
        )
      : cacheStore.loadAutoDhikrPreferences()
    cacheStore.saveAutoDhikrPreferences(preferences)
    autoDhikrState = WatchAutoDhikrSessionState.default(
      preferences: preferences,
      sessionId: newAutoDhikrSessionId()
    )
    cacheStore.saveAutoDhikrSession(autoDhikrState)
    clearAutoDhikrSnapshot()
  }

  private func applyDhikrSessionToSnapshot() {
    guard var snapshot else { return }
    if dhikrState.count > 0 || dhikrState.isComplete {
      snapshot.activeDhikrSession = WatchDhikrSessionPayload(
        sessionId: dhikrSessionId,
        mode: dhikrState.preset.syncMode,
        targetCount: dhikrState.target,
        currentCount: dhikrState.count,
        startedAt: snapshot.activeDhikrSession?.startedAt ?? Date(),
        updatedAt: Date(),
        completed: dhikrState.isComplete,
        rewardEligible: dhikrState.isComplete,
        source: "watch"
      )
    } else {
      snapshot.activeDhikrSession = nil
    }
    snapshot.dhikrTodayCount = max(snapshot.dhikrTodayCount, dhikrState.count)
    self.snapshot = snapshot
    refreshDerivedSnapshotFields()
    WidgetCenter.shared.reloadAllTimelines()
  }

  private func applyAutoDhikrStateToSnapshot() {
    guard var snapshot else { return }
    if autoDhikrState.isActive || autoDhikrState.isCompleted {
      snapshot.activeDhikrSession = WatchDhikrSessionPayload(
        sessionId: autoDhikrState.sessionId,
        mode: autoDhikrState.phrase.syncMode,
        targetCount: autoDhikrState.target,
        currentCount: autoDhikrState.count,
        startedAt: autoDhikrState.startedAt ?? Date(),
        updatedAt: autoDhikrState.updatedAt,
        completed: autoDhikrState.isCompleted,
        rewardEligible: autoDhikrState.isCompleted,
        source: "watch_auto"
      )
      snapshot.dhikrTodayCount = max(snapshot.dhikrTodayCount, autoDhikrState.count)
    } else {
      snapshot.activeDhikrSession = nil
    }
    self.snapshot = snapshot
    refreshDerivedSnapshotFields()
    WidgetCenter.shared.reloadAllTimelines()
  }

  private func clearAutoDhikrSnapshot() {
    guard var snapshot else { return }
    snapshot.activeDhikrSession = nil
    self.snapshot = snapshot
    refreshDerivedSnapshotFields()
    WidgetCenter.shared.reloadAllTimelines()
  }

  private func recomputeStates() {
    if let snapshot {
      let nextPrayer = snapshot.resolvedNextPrayer(now: Date())
      dashboardState = WatchDashboardState(
        nextPrayerName: nextPrayer?.displayName ?? WatchStrings.allPrayersComplete,
        nextPrayerTime: nextPrayer?.scheduledTime,
        completedPrayerCount: snapshot.completedPrayerCount,
        totalPrayerCount: snapshot.totalPrayerCount,
        streakDays: snapshot.streakDays,
        progressValue: snapshot.totalPrayerCount == 0
            ? 0
            : Double(snapshot.completedPrayerCount) / Double(snapshot.totalPrayerCount),
        allPrayersComplete: snapshot.completedPrayerCount >= snapshot.totalPrayerCount,
        lastSyncAt: snapshot.lastSyncAt,
        isStale: isSnapshotStale(snapshot)
      )
      prayerState = WatchPrayerState(prayers: snapshot.prayers)
      progressState = WatchProgressState(
        completedPrayerCount: snapshot.completedPrayerCount,
        totalPrayerCount: snapshot.totalPrayerCount,
        streakDays: snapshot.streakDays,
        xpToday: snapshot.xpToday,
        oceanDropsToday: snapshot.oceanDropsToday,
        currentLevel: snapshot.currentLevel,
        growthStageKey: snapshot.growthStageKey
      )
      if let activeDhikr = snapshot.activeDhikrSession {
        if activeDhikr.mode.hasPrefix("auto_") {
          autoDhikrState.phrase = autoDhikrPhrase(from: activeDhikr.mode)
          autoDhikrState.sessionId = activeDhikr.sessionId
          autoDhikrState.target = activeDhikr.targetCount ?? autoDhikrState.target
          autoDhikrState.count = activeDhikr.currentCount
          autoDhikrState.startedAt = activeDhikr.startedAt
          autoDhikrState.updatedAt = activeDhikr.updatedAt
          autoDhikrState.completedAt = activeDhikr.completed ? activeDhikr.updatedAt : nil
          autoDhikrState.phase = activeDhikr.completed ? .completed : .paused
        } else {
          dhikrSessionId = activeDhikr.sessionId
          let preset = WatchDhikrPreset.from(target: activeDhikr.targetCount ?? cacheStore.defaultDhikrPreset().target)
          dhikrState = WatchDhikrSessionState(
            preset: preset,
            count: activeDhikr.currentCount,
            target: activeDhikr.targetCount ?? preset.target,
            phrase: preset.phrase,
            isComplete: activeDhikr.completed
          )
        }
      }
    } else {
      dashboardState = nil
      progressState = nil
      prayerState = WatchPrayerState(prayers: [])
      let preset = cacheStore.defaultDhikrPreset()
      dhikrState = WatchDhikrSessionState(
        preset: preset,
        count: 0,
        target: preset.target,
        phrase: preset.phrase,
        isComplete: false
      )
      dhikrSessionId = newDhikrSessionId()
    }

    cacheStore.saveAutoDhikrSession(autoDhikrState)

    if pendingActionCount > 0 {
      syncBadgeState = .pending(count: pendingActionCount)
    } else if syncService.isReachable {
      syncBadgeState = .live
    } else {
      syncBadgeState = .cached
    }
    WidgetCenter.shared.reloadAllTimelines()
  }

  private func refreshDerivedSnapshotFields() {
    guard var snapshot else { return }
    let now = Date()
    let calendar = Calendar.current
    let phoneAuthoredNextPrayer = snapshot.resolvedPrayer(withId: snapshot.nextPrayerId)
    let hasValidPhoneNextPrayer = {
      guard let phoneAuthoredNextPrayer,
            phoneAuthoredNextPrayer.status != .completed else {
        return false
      }
      guard let nextPrayerTime = snapshot.nextPrayerTime else {
        return true
      }
      return calendar.isDate(
        phoneAuthoredNextPrayer.scheduledTime,
        equalTo: nextPrayerTime,
        toGranularity: .minute
      )
    }()

    if hasValidPhoneNextPrayer {
      if snapshot.nextPrayerTime == nil {
        snapshot.nextPrayerTime = phoneAuthoredNextPrayer?.scheduledTime
      }
    } else {
      let nextPrayer = snapshot.resolvedNextPrayer(now: now)
      snapshot.nextPrayerId = nextPrayer?.prayerId
      snapshot.nextPrayerTime = nextPrayer?.scheduledTime
    }
    snapshot.currentPrayerId = snapshot.resolvedCurrentPrayer(now: now)?.prayerId
    self.snapshot = snapshot
    cacheStore.saveSnapshot(snapshot)
  }

  private func currentDayKey() -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
  }

  private func newDhikrSessionId() -> String {
    "watch-dhikr-\(currentDayKey())-\(UUID().uuidString)"
  }

  private func newAutoDhikrSessionId() -> String {
    "watch-auto-dhikr-\(currentDayKey())-\(UUID().uuidString)"
  }

  private func autoDhikrPhrase(from mode: String) -> WatchAutoDhikrPhrase {
    switch mode {
    case "auto_subhan_allah":
      return .subhanAllah
    case "auto_alhamdulillah":
      return .alhamdulillah
    case "auto_allahu_akbar":
      return .allahuAkbar
    case "auto_astaghfirullah":
      return .astaghfirullah
    default:
      return .generic
    }
  }

  private func registerForSyncNotifications() {
    let center = NotificationCenter.default
    notificationObservers.append(
      center.addObserver(
        forName: WatchSyncService.cacheDidUpdateNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self else { return }
        Task { @MainActor in
          self.snapshot = self.cacheStore.loadSnapshot()
          self.settings = self.cacheStore.loadSettings() ?? self.settings
          self.autoDhikrState = self.cacheStore.loadAutoDhikrSession() ?? self.autoDhikrState
          self.postPrayerAdhkarState = self.cacheStore.loadPostPrayerAdhkarState()
          self.recomputeStates()
        }
      }
    )
    notificationObservers.append(
      center.addObserver(
        forName: WatchSyncService.reachabilityDidChangeNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self else { return }
        Task { @MainActor in
          if self.syncService.isReachable {
            await self.syncNow()
          } else {
            self.recomputeStates()
          }
        }
      }
    )
  }

  private func offerPostPrayerAdhkar(for prayer: WatchPrayerPayload) {
    if let state = postPrayerAdhkarState,
       !state.isComplete,
       state.prayerId == prayer.prayerId {
      return
    }
    let state = WatchPostPrayerAdhkarState.default(for: prayer)
    postPrayerAdhkarState = state
    cacheStore.savePostPrayerAdhkarState(state)
  }

  private func persistPostPrayerAdhkarState() {
    guard let postPrayerAdhkarState else { return }
    cacheStore.savePostPrayerAdhkarState(postPrayerAdhkarState)
  }

  private func sendPostPrayerAdhkarCompletion(_ state: WatchPostPrayerAdhkarState) {
    let action = WatchActionEnvelopePayload(
      actionId: UUID().uuidString,
      deviceType: "apple_watch",
      actionType: .postPrayerAdhkarCompleted,
      createdAt: Date(),
      logicalDate: snapshot?.date ?? currentDayKey(),
      payload: [
        "setId": state.setId,
        "prayerId": state.prayerId,
        "count": "\(state.totalCompletedCount)",
      ],
      sourceVersion: "1"
    )
    Task {
      _ = await syncService.sendAction(action)
    }
  }

  private func isSnapshotStale(_ snapshot: WatchDailySnapshotPayload) -> Bool {
    let now = Date()
    if currentDayKey() != snapshot.date {
      return true
    }
    return now.timeIntervalSince(snapshot.generatedAt) > 60 * 90
  }
}
