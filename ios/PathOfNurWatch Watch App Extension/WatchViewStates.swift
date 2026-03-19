import Foundation

struct WatchDashboardState {
  let nextPrayerName: String
  let nextPrayerTime: Date?
  let completedPrayerCount: Int
  let totalPrayerCount: Int
  let streakDays: Int
  let progressValue: Double
  let allPrayersComplete: Bool
  let lastSyncAt: Date?
  let isStale: Bool
}

struct WatchPrayerState {
  let prayers: [WatchPrayerPayload]

  var completedPrayerCount: Int {
    prayers.filter { $0.status == .completed }.count
  }
}

struct WatchDhikrSessionState {
  let preset: WatchDhikrPreset
  let count: Int
  let target: Int
  let phrase: String
  let isComplete: Bool

  var progressValue: Double {
    guard target > 0 else { return 0 }
    return min(Double(count) / Double(target), 1)
  }
}

struct WatchAutoDhikrStatusSummary {
  let phrase: String
  let count: Int
  let target: Int
  let intervalSeconds: Double
  let phase: WatchAutoDhikrPhase

  var progressValue: Double {
    guard target > 0 else { return 0 }
    return min(Double(count) / Double(target), 1)
  }
}

struct WatchProgressState {
  let completedPrayerCount: Int
  let totalPrayerCount: Int
  let streakDays: Int
  let xpToday: Int
  let oceanDropsToday: Int
  let currentLevel: Int
  let growthStageKey: String
}
