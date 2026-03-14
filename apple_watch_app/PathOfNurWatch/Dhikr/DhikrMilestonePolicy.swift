import Foundation

struct DhikrMilestonePolicy {
    func evaluate(
        mode: WatchDhikrMode,
        previousCount: Int,
        newCount: Int,
        targetCount: Int?,
        previousTodayTotal: Int
    ) -> (milestone: DhikrMilestone, completed: Bool, rewardEligible: Bool, rewardGranted: Bool) {
        let completed = targetCount != nil && previousCount < targetCount! && newCount >= targetCount!
        let rewardFromPreset = completed && mode != .free
        let crossedHundredBoundary = mode == .free && (previousTodayTotal / 100) < ((previousTodayTotal + 1) / 100)
        let rewardGranted = rewardFromPreset || crossedHundredBoundary

        if completed {
            return (.targetCompleted, true, true, rewardGranted)
        }
        if previousCount < 99 && newCount >= 99 {
            return (.milestone99, false, false, rewardGranted)
        }
        if mode == .preset99 && previousCount < 66 && newCount >= 66 {
            return (.milestone66, false, false, rewardGranted)
        }
        if previousCount < 33 && newCount >= 33 {
            return (.milestone33, false, false, rewardGranted)
        }
        return (.none, false, false, rewardGranted)
    }
}

