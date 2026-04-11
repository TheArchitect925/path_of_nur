import Foundation

enum WatchPrayerStatusValue: String, Codable {
  case pending
  case completed
  case missed
}

enum WatchPrayerTimingValue: String, Codable {
  case onTime = "on_time"
  case late
}

struct WatchPrayerPayload: Codable, Identifiable {
  let prayerId: String
  let displayName: String
  let scheduledTime: Date
  var status: WatchPrayerStatusValue
  let completedAt: Date?
  let timing: String?
  let source: String

  var id: String { prayerId }
}

struct WatchDhikrSessionPayload: Codable {
  let sessionId: String
  let mode: String
  let targetCount: Int?
  let currentCount: Int
  let startedAt: Date
  let updatedAt: Date
  let completed: Bool
  let rewardEligible: Bool
  let source: String
}

struct WatchSpiritualPromptPayload: Codable {
  let kind: String
  let title: String
  let shortText: String
  let inlineText: String
  let circularText: String
}

struct WatchDailySnapshotPayload: Codable {
  let schemaVersion: Int
  let snapshotId: String
  let generatedAt: Date
  let date: String
  let timezone: String
  var nextPrayerId: String?
  var nextPrayerTime: Date?
  var currentPrayerId: String?
  var completedPrayerCount: Int
  let totalPrayerCount: Int
  var dhikrTodayCount: Int
  var xpToday: Int
  var oceanDropsToday: Int
  var streakDays: Int
  let currentLevel: Int
  let growthStageKey: String
  var prayers: [WatchPrayerPayload]
  var activeDhikrSession: WatchDhikrSessionPayload?
  var spiritualPrompt: WatchSpiritualPromptPayload?
  var lastSyncAt: Date
  let sourceVersion: String
}

struct WatchSettingsPayload: Codable {
  let schemaVersion: Int
  var prayerNotificationsEnabled: Bool
  let enabledPrayerIds: [String]
  let followUpReminderEnabled: Bool
  let followUpDelayMinutes: Int
  let snoozeDurationMinutes: Int
  let dhikrReminderEnabled: Bool
  let quietModeEnabled: Bool
  let watchThemeMode: String?
  let lastUpdatedAt: Date
}

enum WatchDhikrMode: String, CaseIterable, Codable, Identifiable {
  case manual
  case auto

  var id: String { rawValue }
}

extension WatchDailySnapshotPayload {
  var sortedPrayersByScheduledTime: [WatchPrayerPayload] {
    prayers.sorted { $0.scheduledTime < $1.scheduledTime }
  }

  func resolvedPrayer(withId prayerId: String?) -> WatchPrayerPayload? {
    guard let prayerId else { return nil }
    return prayers.first(where: { $0.prayerId == prayerId })
  }

  func resolvedCurrentPrayer(now _: Date = Date()) -> WatchPrayerPayload? {
    resolvedPrayer(withId: currentPrayerId)
  }

  func resolvedNextPrayer(now: Date = Date()) -> WatchPrayerPayload? {
    if let phoneAuthored = resolvedPrayer(withId: nextPrayerId),
       phoneAuthored.status != .completed {
      return phoneAuthored
    }

    if let nextPrayerTime {
      let calendar = Calendar.current
      if let timeMatched = sortedPrayersByScheduledTime.first(where: { prayer in
        prayer.status == .pending &&
        calendar.isDate(prayer.scheduledTime, equalTo: nextPrayerTime, toGranularity: .minute)
      }) {
        return timeMatched
      }
    }

    let pendingPrayers = sortedPrayersByScheduledTime.filter { $0.status == .pending }

    // When the phone-authored next prayer is missing, prefer the most recent
    // still-pending prayer that is already due before jumping to a later one.
    if let duePending = pendingPrayers.last(where: { $0.scheduledTime <= now }) {
      return duePending
    }

    if let upcomingPending = pendingPrayers.first(where: { $0.scheduledTime > now }) {
      return upcomingPending
    }

    return nil
  }
}

struct WatchSyncAckPayload: Codable {
  let actionId: String
  let processed: Bool
  let processedAt: Date
  let resultType: String
  let resultingSnapshotId: String?
  let notes: String?
}

struct WatchSyncResponsePayload: Codable {
  let ack: WatchSyncAckPayload
  let snapshot: WatchDailySnapshotPayload
}

enum WatchSyncActionType: String, Codable {
  case prayerStatusUpdated = "prayer_status_updated"
  case dhikrSessionStarted = "dhikr_session_started"
  case dhikrIncrement = "dhikr_increment"
  case dhikrReset = "dhikr_reset"
  case dhikrSessionCompleted = "dhikr_session_completed"
  case postPrayerAdhkarCompleted = "post_prayer_adhkar_completed"
  case snoozeRequested = "snooze_requested"
  case notificationActionLogged = "notification_action_logged"
}

struct WatchActionEnvelopePayload: Codable, Identifiable {
  let actionId: String
  let deviceType: String
  let actionType: WatchSyncActionType
  let createdAt: Date
  let logicalDate: String
  let payload: [String: String]
  let sourceVersion: String

  var id: String { actionId }

  func toDictionary() -> [String: Any] {
    [
      "actionId": actionId,
      "deviceType": deviceType,
      "actionType": actionType.rawValue,
      "createdAt": WatchCodec.iso8601.string(from: createdAt),
      "logicalDate": logicalDate,
      "payload": payload,
      "sourceVersion": sourceVersion,
    ]
  }
}

enum WatchDhikrPreset: String, CaseIterable, Codable, Identifiable {
  case preset33
  case preset34
  case preset99
  case custom

  var id: String { rawValue }

  var target: Int {
    switch self {
    case .preset33:
      return 33
    case .preset34:
      return 34
    case .preset99:
      return 99
    case .custom:
      return 100
    }
  }

  var syncMode: String {
    switch self {
    case .preset33:
      return "preset_33"
    case .preset34:
      return "preset_34"
    case .preset99:
      return "preset_99"
    case .custom:
      return "free"
    }
  }

  var phrase: String {
    switch self {
    case .preset33:
      return WatchStrings.dhikrPreset33Phrase
    case .preset34:
      return WatchStrings.dhikrPreset34Phrase
    case .preset99:
      return WatchStrings.dhikrPreset99Phrase
    case .custom:
      return WatchStrings.dhikrPresetCustomPhrase
    }
  }

  var title: String {
    switch self {
    case .preset33:
      return WatchStrings.dhikrPreset33Title
    case .preset34:
      return WatchStrings.dhikrPreset34Title
    case .preset99:
      return WatchStrings.dhikrPreset99Title
    case .custom:
      return WatchStrings.dhikrPresetCustomTitle
    }
  }

  static func from(target: Int) -> WatchDhikrPreset {
    switch target {
    case 33:
      return .preset33
    case 34:
      return .preset34
    case 99:
      return .preset99
    default:
      return .custom
    }
  }
}

enum WatchAutoDhikrPhrase: String, CaseIterable, Codable, Identifiable {
  case subhanAllah
  case alhamdulillah
  case allahuAkbar
  case astaghfirullah
  case generic

  var id: String { rawValue }

  var title: String {
    switch self {
    case .subhanAllah:
      return WatchStrings.autoDhikrPhraseSubhanAllah
    case .alhamdulillah:
      return WatchStrings.autoDhikrPhraseAlhamdulillah
    case .allahuAkbar:
      return WatchStrings.autoDhikrPhraseAllahuAkbar
    case .astaghfirullah:
      return WatchStrings.autoDhikrPhraseAstaghfirullah
    case .generic:
      return WatchStrings.autoDhikrPhraseGeneric
    }
  }

  var syncMode: String {
    switch self {
    case .subhanAllah:
      return "auto_subhan_allah"
    case .alhamdulillah:
      return "auto_alhamdulillah"
    case .allahuAkbar:
      return "auto_allahu_akbar"
    case .astaghfirullah:
      return "auto_astaghfirullah"
    case .generic:
      return "auto_generic"
    }
  }
}

struct WatchAutoDhikrPreferences: Codable {
  var phrase: WatchAutoDhikrPhrase
  var target: Int
  var intervalSeconds: Double

  static let minimumInterval = 1.0
  static let maximumInterval = 10.0
  static let intervalStep = 0.5
  static let defaultInterval = 2.0
  static let defaultTarget = 33

  static var `default`: WatchAutoDhikrPreferences {
    WatchAutoDhikrPreferences(
      phrase: .subhanAllah,
      target: defaultTarget,
      intervalSeconds: defaultInterval
    )
  }

  static func clampedInterval(_ value: Double) -> Double {
    let stepped = (value / intervalStep).rounded() * intervalStep
    return min(max(stepped, minimumInterval), maximumInterval)
  }
}

enum WatchAutoDhikrPhase: String, Codable {
  case idle
  case running
  case paused
  case completed
}

struct WatchAutoDhikrSessionState: Codable {
  var sessionId: String
  var phrase: WatchAutoDhikrPhrase
  var target: Int
  var intervalSeconds: Double
  var count: Int
  var phase: WatchAutoDhikrPhase
  var startedAt: Date?
  var updatedAt: Date
  var lastTickAt: Date?
  var completedAt: Date?

  static func `default`(
    preferences: WatchAutoDhikrPreferences = .default,
    sessionId: String
  ) -> WatchAutoDhikrSessionState {
    WatchAutoDhikrSessionState(
      sessionId: sessionId,
      phrase: preferences.phrase,
      target: preferences.target,
      intervalSeconds: preferences.intervalSeconds,
      count: 0,
      phase: .idle,
      startedAt: nil,
      updatedAt: Date(),
      lastTickAt: nil,
      completedAt: nil
    )
  }

  var progressValue: Double {
    guard target > 0 else { return 0 }
    return min(Double(count) / Double(target), 1)
  }

  var isRunning: Bool { phase == .running }
  var isPaused: Bool { phase == .paused }
  var isCompleted: Bool { phase == .completed }
  var isActive: Bool { phase == .running || phase == .paused }

  var intervalDisplay: String {
    String(format: "%.1fs", intervalSeconds)
  }

  mutating func applyPreferences(_ preferences: WatchAutoDhikrPreferences) {
    phrase = preferences.phrase
    target = preferences.target
    intervalSeconds = preferences.intervalSeconds
    updatedAt = Date()
  }
}

enum WatchRootTab: String, CaseIterable, Identifiable {
  case home
  case prayer
  case dhikr
  case progress
  case utility

  var id: String { rawValue }
}

enum WatchPostPrayerAdhkarPhraseKind: String, Codable, CaseIterable, Identifiable {
  case subhanAllah
  case alhamdulillah
  case allahuAkbar

  var id: String { rawValue }

  var title: String {
    switch self {
    case .subhanAllah:
      return WatchStrings.adhkarPhraseSubhanAllah
    case .alhamdulillah:
      return WatchStrings.adhkarPhraseAlhamdulillah
    case .allahuAkbar:
      return WatchStrings.adhkarPhraseAllahuAkbar
    }
  }

  var targetCount: Int {
    switch self {
    case .allahuAkbar:
      return 34
    case .subhanAllah, .alhamdulillah:
      return 33
    }
  }
}

struct WatchPostPrayerAdhkarStepState: Codable, Identifiable {
  let kind: WatchPostPrayerAdhkarPhraseKind
  var count: Int

  var id: String { kind.id }
}

struct WatchPostPrayerAdhkarState: Codable {
  let setId: String
  let prayerId: String
  let prayerName: String
  let startedAt: Date
  var updatedAt: Date
  var currentStepIndex: Int
  var steps: [WatchPostPrayerAdhkarStepState]
  var completedAt: Date?
}

extension WatchPostPrayerAdhkarState {
  static func `default`(for prayer: WatchPrayerPayload) -> WatchPostPrayerAdhkarState {
    WatchPostPrayerAdhkarState(
      setId: "post_prayer_core_v1",
      prayerId: prayer.prayerId,
      prayerName: prayer.displayName,
      startedAt: Date(),
      updatedAt: Date(),
      currentStepIndex: 0,
      steps: WatchPostPrayerAdhkarPhraseKind.allCases.map {
        WatchPostPrayerAdhkarStepState(kind: $0, count: 0)
      },
      completedAt: nil
    )
  }

  var currentStep: WatchPostPrayerAdhkarStepState? {
    guard steps.indices.contains(currentStepIndex) else { return nil }
    return steps[currentStepIndex]
  }

  var isComplete: Bool {
    completedAt != nil
  }

  var totalCompletedCount: Int {
    steps.reduce(0) { $0 + min($1.count, $1.kind.targetCount) }
  }

  var totalTargetCount: Int {
    steps.reduce(0) { $0 + $1.kind.targetCount }
  }

  var progressValue: Double {
    guard totalTargetCount > 0 else { return 0 }
    return min(Double(totalCompletedCount) / Double(totalTargetCount), 1)
  }
}

enum WatchSyncBadgeState {
  case live
  case cached
  case pending(count: Int)
}

enum WatchCodec {
  static let iso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  static let fallbackIso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()

  static let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .custom { date, enc in
      var container = enc.singleValueContainer()
      try container.encode(iso8601.string(from: date))
    }
    return encoder
  }()

  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { dec in
      let container = try dec.singleValueContainer()
      let value = try container.decode(String.self)
      if let date = iso8601.date(from: value) ?? fallbackIso8601.date(from: value) {
        return date
      }
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Invalid ISO8601 date: \(value)"
      )
    }
    return decoder
  }()
}

enum WatchStrings {
  private static func value(_ key: String, _ fallback: String) -> String {
    NSLocalizedString(key, bundle: .main, value: fallback, comment: "")
  }

  private static func format(_ key: String, _ fallback: String, _ args: CVarArg...) -> String {
    String(format: value(key, fallback), locale: .current, arguments: args)
  }

  static let homeTitle = value("watch.home.title", "Today")
  static let prayerTitle = value("watch.prayer.title", "Prayer")
  static let dhikrTitle = value("watch.dhikr.title", "Dhikr")
  static let progressTitle = value("watch.progress.title", "Progress")
  static let utilityTitle = value("watch.utility.title", "Utility")
  static let nextPrayerTitle = value("watch.home.nextPrayer", "Next Prayer")
  static let allPrayersComplete = value("watch.home.allPrayersComplete", "Today's prayers are complete")
  static let prayerSummary = value("watch.home.prayerSummary", "Prayers")
  static let streak = value("watch.common.streak", "Streak")
  static let xp = value("watch.common.xp", "XP")
  static let drops = value("watch.common.drops", "Drops")
  static let level = value("watch.common.level", "Level")
  static let progress = value("watch.common.progress", "Progress")
  static let syncNow = value("watch.utility.syncNow", "Sync Now")
  static let haptics = value("watch.utility.haptics", "Haptics")
  static let defaultDhikrTarget = value("watch.utility.defaultTarget", "Default Target")
  static let prayed = value("watch.prayer.prayed", "Mark as prayed")
  static let prayedLate = value("watch.prayer.prayedLate", "Mark as prayed late")
  static let missed = value("watch.prayer.missed", "Mark as missed")
  static let cancel = value("watch.common.cancel", "Cancel")
  static let pending = value("watch.common.pending", "Pending")
  static let completed = value("watch.common.completed", "Completed")
  static let late = value("watch.common.late", "Late")
  static let missedStatus = value("watch.common.missed", "Missed")
  static let tapToCount = value("watch.dhikr.tapToCount", "Tap to Count")
  static let finishSession = value("watch.dhikr.finish", "Finish Session")
  static let resetSession = value("watch.dhikr.reset", "Reset Session")
  static let choosePreset = value("watch.dhikr.choosePreset", "Choose Preset")
  static let noSnapshotTitle = value("watch.empty.noSnapshot", "Ready to sync")
  static let noSnapshotBody = value("watch.empty.noSnapshot.body", "Open Path of Nūr on your iPhone to refresh today's companion snapshot.")
  static let cachedBadge = value("watch.sync.cached", "Cached")
  static let liveBadge = value("watch.sync.live", "Live")
  static let pendingBadge = value("watch.sync.pending", "Pending")
  static let growthPrefix = value("watch.progress.growth", "Growth")
  static let freshnessUpdated = value("watch.sync.updated", "Updated")
  static let freshnessNeedsSync = value("watch.sync.needsSync", "Needs sync")
  static let freshnessJustNow = value("watch.sync.justNow", "Just now")
  static let postPrayerCompletedTitle = value("watch.prayer.completed.title", "Prayer logged")
  static let postPrayerCompletedBody = value("watch.prayer.completed.body", "Keep the moment with a short post-prayer adhkar flow.")
  static let postPrayerAdhkar = value("watch.prayer.postPrayerAdhkar", "Post-Prayer Adhkar")
  static let done = value("watch.common.done", "Done")
  static let skip = value("watch.common.skip", "Skip")
  static let continueLabel = value("watch.common.continue", "Continue")
  static let adhkarTitle = value("watch.adhkar.title", "Post-Prayer Adhkar")
  static let adhkarResume = value("watch.adhkar.resume", "Resume")
  static let adhkarTap = value("watch.adhkar.tap", "Tap to remember")
  static let adhkarSequence = value("watch.adhkar.sequence", "After prayer remembrance")
  static let adhkarCompletedTitle = value("watch.adhkar.completed.title", "Adhkar complete")
  static let adhkarCompletedBody = value("watch.adhkar.completed.body", "A gentle remembrance carried forward from salah.")
  static let adhkarStepLabel = value("watch.adhkar.step", "Phrase")
  static let adhkarPhraseSubhanAllah = value("watch.adhkar.phrase.subhanAllah", "SubhanAllah")
  static let adhkarPhraseAlhamdulillah = value("watch.adhkar.phrase.alhamdulillah", "Alhamdulillah")
  static let adhkarPhraseAllahuAkbar = value("watch.adhkar.phrase.allahuAkbar", "Allahu Akbar")
  static let complicationAllSet = value("watch.complication.allSet", "All set")
  static let complicationNeedsSync = value("watch.complication.needsSync", "Needs Sync")
  static let complicationDueNow = value("watch.complication.dueNow", "Due now")
  static let complicationSoon = value("watch.complication.soon", "Soon")
  static let complicationNoData = value("watch.complication.noData", "Open app")
  static let complicationNextPrayerDescription = value("watch.complication.nextPrayer.description", "Shows the next prayer and a concise due time.")
  static let complicationDailyProgressDescription = value("watch.complication.dailyProgress.description", "Shows today's prayer completion at a glance.")
  static let complicationAutoDhikrDescription = value("watch.complication.autoDhikr.description", "Launch Auto Dhikr with your last-used rhythm.")
  static let complicationSpiritualPromptTitle = value("watch.complication.spiritualPrompt.title", "Spiritual Prompt")
  static let complicationSpiritualPromptDescription = value("watch.complication.spiritualPrompt.description", "Shows a short spiritual prompt from your synced Path of Nūr snapshot.")
  static let complicationPrayerProgressTitle = value("watch.complication.prayerProgress.title", "Prayer Progress")
  static let complicationStartSession = value("watch.complication.startSession", "Start a session")
  static let complicationOpenApp = value("watch.complication.openApp", "Open Path of Nūr")
  static let complicationPrayerProgressDone = value("watch.complication.prayerProgress.done", "Done today")
  static func complicationPrayerProgressCompleted(_ completed: Int, _ total: Int) -> String {
    format("watch.complication.prayerProgress.completedFormat", "%d of %d completed", completed, total)
  }
  static func complicationAutoDhikrSummary(_ target: Int, _ pace: String) -> String {
    format("watch.complication.autoDhikr.summaryFormat", "%d • %@/count", target, pace)
  }
  static func complicationAutoDhikrRunning(_ count: Int, _ target: Int, _ pace: String) -> String {
    format("watch.complication.autoDhikr.runningFormat", "%d/%d • %@/count", count, target, pace)
  }
  static let notificationPrayerReminderBody = value("watch.notification.prayer.body", "Return gently to this prayer.")
  static let notificationActionMarkPrayed = value("watch.notification.action.markPrayed", "Mark as prayed")
  static let notificationActionMarkPrayedLate = value("watch.notification.action.markPrayedLate", "Mark as prayed late")
  static let notificationActionSnooze = value("watch.notification.action.snooze", "Snooze")
  static let notificationActionOpen = value("watch.notification.action.open", "Open")
  static let dhikrPreset33Title = value("watch.dhikr.preset.33.title", "33")
  static let dhikrPreset34Title = value("watch.dhikr.preset.34.title", "34")
  static let dhikrPreset99Title = value("watch.dhikr.preset.99.title", "99")
  static let dhikrPresetCustomTitle = value("watch.dhikr.preset.custom.title", "Custom")
  static let dhikrPreset33Phrase = value("watch.dhikr.preset.33.phrase", "SubhanAllah")
  static let dhikrPreset34Phrase = value("watch.dhikr.preset.34.phrase", "Allahu Akbar")
  static let dhikrPreset99Phrase = value("watch.dhikr.preset.99.phrase", "SubhanAllah")
  static let dhikrPresetCustomPhrase = value("watch.dhikr.preset.custom.phrase", "Dhikr Session")
  static let dhikrAntiRushTitle = value("watch.dhikr.antiRush.title", "Slow down gently")
  static let dhikrAntiRushBody = value("watch.dhikr.antiRush.body", "Dhikr is not only in number, but in presence. Slow down, breathe, and remember with sincerity.")
  static let dhikrAntiRushAcknowledge = value("watch.dhikr.antiRush.acknowledge", "Continue")
  static let dhikrModeManual = value("watch.dhikr.mode.manual", "Manual")
  static let dhikrModeAuto = value("watch.dhikr.mode.auto", "Auto")
  static let autoDhikrTitle = value("watch.dhikr.auto.title", "Auto Dhikr")
  static let autoDhikrBegin = value("watch.dhikr.auto.begin", "Begin")
  static let autoDhikrPause = value("watch.dhikr.auto.pause", "Pause")
  static let autoDhikrResume = value("watch.dhikr.auto.resume", "Resume")
  static let autoDhikrEnd = value("watch.dhikr.auto.end", "End")
  static let autoDhikrRunning = value("watch.dhikr.auto.running", "Running")
  static let autoDhikrPaused = value("watch.dhikr.auto.paused", "Paused")
  static let autoDhikrCompleted = value("watch.dhikr.auto.completed", "Completed")
  static let autoDhikrTarget = value("watch.dhikr.auto.target", "Target")
  static let autoDhikrPace = value("watch.dhikr.auto.pace", "Pace")
  static let autoDhikrFaster = value("watch.dhikr.auto.faster", "Faster")
  static let autoDhikrSlower = value("watch.dhikr.auto.slower", "Slower")
  static let autoDhikrKeepFocus = value("watch.dhikr.auto.keepFocus", "Let the watch hold a calm rhythm.")
  static let autoDhikrMinimalHint = value("watch.dhikr.auto.minimalHint", "Tap to reveal pace and end controls.")
  static let autoDhikrShowControls = value("watch.dhikr.auto.showControls", "Show Controls")
  static let autoDhikrHideControls = value("watch.dhikr.auto.hideControls", "Hide Controls")
  static let autoDhikrSessionCompleteTitle = value("watch.dhikr.auto.complete.title", "Auto Dhikr complete")
  static let autoDhikrSessionCompleteBody = value("watch.dhikr.auto.complete.body", "A calm guided remembrance has reached its target.")
  static let autoDhikrEndConfirmTitle = value("watch.dhikr.auto.end.confirm.title", "End session?")
  static let autoDhikrEndConfirmBody = value("watch.dhikr.auto.end.confirm.body", "Your current auto dhikr progress will be preserved only in today's history.")
  static let autoDhikrPhraseSubhanAllah = value("watch.dhikr.auto.phrase.subhanAllah", "SubhanAllah")
  static let autoDhikrPhraseAlhamdulillah = value("watch.dhikr.auto.phrase.alhamdulillah", "Alhamdulillah")
  static let autoDhikrPhraseAllahuAkbar = value("watch.dhikr.auto.phrase.allahuAkbar", "Allahu Akbar")
  static let autoDhikrPhraseAstaghfirullah = value("watch.dhikr.auto.phrase.astaghfirullah", "Astaghfirullah")
  static let autoDhikrPhraseGeneric = value("watch.dhikr.auto.phrase.generic", "Dhikr")
}
