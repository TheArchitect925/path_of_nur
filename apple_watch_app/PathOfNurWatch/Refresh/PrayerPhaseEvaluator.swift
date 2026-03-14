import Foundation

struct PrayerPhaseEvaluation {
    var state: PrayerPhaseState
    var didTransition: Bool
}

struct PrayerPhaseEvaluator {
    func evaluate(prayers: [WatchPrayerStatus], now: Date, previous: PrayerPhaseState?) -> PrayerPhaseEvaluation {
        let sorted = prayers.sorted { $0.scheduledTime < $1.scheduledTime }
        let next = sorted.first { $0.scheduledTime > now }
        let current = sorted.last { $0.scheduledTime <= now }
        let state = PrayerPhaseState(
            currentPrayerId: current?.prayerId,
            nextPrayerId: next?.prayerId,
            nextPrayerTime: next?.scheduledTime,
            lastEvaluatedAt: now
        )
        let didTransition = previous?.nextPrayerId != state.nextPrayerId || previous?.currentPrayerId != state.currentPrayerId
        return PrayerPhaseEvaluation(state: state, didTransition: didTransition)
    }
}

