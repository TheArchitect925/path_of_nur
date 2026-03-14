import Foundation

enum WatchPrayerState: String, Codable {
    case pending
    case completed
}

enum WatchSource: String, Codable {
    case phone
    case watch
    case synced
}

enum WatchDhikrMode: String, Codable {
    case preset33
    case preset99
    case free
}

enum WatchDhikrInteractionMode: String, Codable {
    case manualTap
    case silentTap
    case guidedPulse
}

enum WatchSyncItemType: String, Codable {
    case prayerComplete
    case prayerUncomplete
    case dhikrIncrement
    case dhikrReset
    case sessionComplete
    case quranPlaybackCommand
}

enum WatchSyncStatus: String, Codable {
    case pending
    case synced
    case failed
}

struct WatchDaySnapshot: Codable {
    var date: Date
    var timezone: String
    var nextPrayerId: String
    var nextPrayerTime: Date
    var currentPrayerId: String?
    var completedPrayerCount: Int
    var totalPrayerCount: Int
    var dhikrTodayCount: Int
    var xpToday: Int
    var oceanDropsToday: Int
    var streakDays: Int
    var lastSyncAt: Date?
}

struct WatchPrayerStatus: Identifiable, Codable {
    var id: String { prayerId }
    var prayerId: String
    var displayName: String
    var scheduledTime: Date
    var status: WatchPrayerState
    var completedAt: Date?
    var source: WatchSource
}

struct WatchDhikrSession: Codable {
    var sessionId: String
    var mode: WatchDhikrMode
    var targetCount: Int?
    var currentCount: Int
    var startedAt: Date
    var updatedAt: Date
    var completed: Bool
    var completionMilestoneReached: Bool
    var rewardEligible: Bool
    var rewardGranted: Bool
    var interactionMode: WatchDhikrInteractionMode
    var pulseIntervalSeconds: Double?
    var isPulseRunning: Bool
    var pulseTargetCount: Int?
    var pulseCurrentStep: Int
    var paceReminderShownAt: Date?
    var pausedAt: Date?
    var source: WatchSource
}

enum WatchQuranPlaybackSourceType: String, Codable {
    case phone
    case watch
}

enum WatchQuranPlaybackCommand: String, Codable {
    case play
    case pause
    case next
    case previous
    case seekForward15
    case seekBack15
    case switchOutputPhone
    case switchOutputWatch
    case resumeLast
}

struct WatchQuranPlaybackSnapshot: Codable {
    var playbackSessionId: String
    var sourceType: WatchQuranPlaybackSourceType
    var isPlaying: Bool
    var surahId: Int?
    var surahName: String
    var reciterId: String
    var reciterName: String
    var currentAyah: Int?
    var positionSeconds: Int
    var durationSeconds: Int?
    var isBuffering: Bool
    var lastUpdatedAt: Date
}

struct WatchAudioAvailabilitySnapshot: Codable {
    var watchPlaybackAvailable: Bool
    var downloadedSurahIds: [Int]
    var recentPlayableItems: [String]
    var lastSyncedAt: Date?
}

struct WatchSyncQueueItem: Identifiable, Codable {
    var id: String
    var type: WatchSyncItemType
    var payload: [String: String]
    var createdAt: Date
    var syncStatus: WatchSyncStatus
    var retryCount: Int
}

enum WatchNotificationKind: String, Codable {
    case initial
    case followUp
    case snooze
    case dhikr
}

enum WatchReminderStatus: String, Codable {
    case scheduled
    case fired
    case cancelled
    case expired
}

enum WatchNotificationActionType: String, Codable {
    case markPrayed
    case snooze
    case openApp
    case openDhikr
    case dismiss
}

struct WatchNotificationSettings: Codable {
    var prayerNotificationsEnabled: Bool
    var enabledPrayerIds: [String]
    var followUpReminderEnabled: Bool
    var followUpDelayMinutes: Int
    var snoozeDurationMinutes: Int
    var quietModeEnabled: Bool
    var dhikrReminderEnabled: Bool

    static let `default` = WatchNotificationSettings(
        prayerNotificationsEnabled: true,
        enabledPrayerIds: ["fajr", "dhuhr", "asr", "maghrib", "isha"],
        followUpReminderEnabled: true,
        followUpDelayMinutes: 20,
        snoozeDurationMinutes: 10,
        quietModeEnabled: false,
        dhikrReminderEnabled: false
    )
}

struct ScheduledPrayerReminder: Identifiable, Codable {
    var id: String
    var prayerId: String
    var date: Date
    var kind: WatchNotificationKind
    var scheduledAt: Date
    var status: WatchReminderStatus
    var dedupKey: String
}

struct NotificationActionLog: Identifiable, Codable {
    var id: String
    var prayerId: String?
    var actionType: WatchNotificationActionType
    var timestamp: Date
    var source: String
}

struct NotificationDedupState: Codable {
    var dedupKey: String
    var lastScheduledAt: Date?
    var lastFiredAt: Date?
    var lastCancelledAt: Date?
}

enum DhikrMilestone: String, Codable {
    case none
    case milestone33
    case milestone66
    case milestone99
    case targetCompleted
}

struct DhikrIncrementOutcome {
    var session: WatchDhikrSession
    var todayTotal: Int
    var milestone: DhikrMilestone
    var rewardGranted: Bool
    var shouldQueueCompletion: Bool
}

enum SnapshotFreshnessStatus: String, Codable {
    case fresh
    case aging
    case stale
    case expired
}

struct SnapshotFreshnessState: Codable {
    var snapshotDate: Date?
    var lastRefreshAt: Date?
    var lastSuccessfulSyncAt: Date?
    var freshnessStatus: SnapshotFreshnessStatus
    var reason: String
}

struct PrayerPhaseState: Codable {
    var currentPrayerId: String?
    var nextPrayerId: String?
    var nextPrayerTime: Date?
    var lastEvaluatedAt: Date
}

enum DayRolloverStatus: String, Codable {
    case idle
    case needed
    case processing
    case complete
    case failed
}

struct DayRolloverState: Codable {
    var activeDate: Date
    var lastRolloverCheckAt: Date?
    var lastRolloverCompletedAt: Date?
    var rolloverStatus: DayRolloverStatus
}

enum BackgroundRefreshEventType: String, Codable {
    case appLaunch
    case appResume
    case scheduledRefresh
    case nextPrayerTransition
    case dayRollover
    case syncComplete
    case manualRefresh
    case prayerCompletion
    case dhikrUpdate
    case notificationAction
}

struct BackgroundRefreshEvent: Identifiable, Codable {
    var id: String
    var type: BackgroundRefreshEventType
    var timestamp: Date
    var handled: Bool
}

struct RefreshResult {
    var snapshotUpdated: Bool
    var notificationsRescheduled: Bool
    var tilesRefreshed: Bool
    var complicationsRefreshed: Bool
    var syncAttempted: Bool
    var rolloverPerformed: Bool
    var errors: [String]
}
