import Foundation

final class WatchDhikrEngine {
    private let policy = DhikrMilestonePolicy()
    private var lastIncrementAt: Date?
    private let debounceInterval: TimeInterval = 0.035

    func increment(session: WatchDhikrSession, todayTotal: Int, now: Date = Date()) -> DhikrIncrementOutcome? {
        if let lastIncrementAt, now.timeIntervalSince(lastIncrementAt) < debounceInterval {
            return nil
        }
        self.lastIncrementAt = now

        let newCount = session.currentCount + 1
        let evaluation = policy.evaluate(
            mode: session.mode,
            previousCount: session.currentCount,
            newCount: newCount,
            targetCount: session.targetCount,
            previousTodayTotal: todayTotal
        )
        let nextSession = WatchDhikrSession(
            sessionId: session.sessionId,
            mode: session.mode,
            targetCount: session.targetCount,
            currentCount: newCount,
            startedAt: session.startedAt,
            updatedAt: now,
            completed: session.completed || evaluation.completed,
            completionMilestoneReached: session.completionMilestoneReached || evaluation.completed,
            rewardEligible: session.rewardEligible || evaluation.rewardEligible,
            rewardGranted: session.rewardGranted || evaluation.rewardGranted,
            interactionMode: session.interactionMode,
            pulseIntervalSeconds: session.pulseIntervalSeconds,
            isPulseRunning: session.isPulseRunning,
            pulseTargetCount: session.pulseTargetCount,
            pulseCurrentStep: session.pulseCurrentStep,
            paceReminderShownAt: session.paceReminderShownAt,
            pausedAt: session.pausedAt,
            source: .watch
        )
        return DhikrIncrementOutcome(
            session: nextSession,
            todayTotal: todayTotal + 1,
            milestone: evaluation.milestone,
            rewardGranted: evaluation.rewardGranted,
            shouldQueueCompletion: evaluation.completed
        )
    }

    func newSession(mode: WatchDhikrMode, now: Date = Date()) -> WatchDhikrSession {
        WatchDhikrSession(
            sessionId: UUID().uuidString,
            mode: mode,
            targetCount: mode == .preset33 ? 33 : (mode == .preset99 ? 99 : nil),
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
            pulseTargetCount: mode == .free ? nil : (mode == .preset33 ? 33 : 99),
            pulseCurrentStep: 0,
            paceReminderShownAt: nil,
            pausedAt: nil,
            source: .watch
        )
    }
}
