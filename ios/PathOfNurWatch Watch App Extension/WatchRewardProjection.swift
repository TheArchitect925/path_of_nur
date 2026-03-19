import Foundation

enum WatchRewardProjection {
  static let prayerXp = 24
  static let dhikrSessionXp = 14

  static func prayerDelta(
    previous: WatchPrayerStatusValue,
    next: WatchPrayerStatusValue
  ) -> (xp: Int, drops: Int) {
    if previous != .completed && next == .completed {
      return (prayerXp, 1)
    }
    if previous == .completed && next != .completed {
      return (-prayerXp, -1)
    }
    return (0, 0)
  }

  static func dhikrCompletionDelta(
    completedTarget: Bool
  ) -> (xp: Int, drops: Int) {
    completedTarget ? (dhikrSessionXp, 1) : (dhikrSessionXp, 0)
  }
}
