import Foundation

enum WatchDhikrPaceDecision {
    case updated(Double)
    case blocked
}

enum WatchDhikrPacePolicy {
    static let defaultInterval = 2.5
    static let steadyInterval = 2.5
    static let minimumAllowed = 1.8
    static let minimumSelectable = 1.0
    static let maximumAllowed = 3.5
    static let step = 0.25

    static func faster(from current: Double) -> WatchDhikrPaceDecision {
        let next = (current - step * 100).rounded() / 100
        if next < minimumAllowed {
            return .blocked
        }
        return .updated(max(minimumAllowed, next))
    }

    static func slower(from current: Double) -> WatchDhikrPaceDecision {
        let next = (current + step * 100).rounded() / 100
        return .updated(min(maximumAllowed, next))
    }

    static func shouldShowReminder(lastShownAt: Date?, now: Date = Date()) -> Bool {
        guard let lastShownAt else { return true }
        return now.timeIntervalSince(lastShownAt) > 300
    }
}
