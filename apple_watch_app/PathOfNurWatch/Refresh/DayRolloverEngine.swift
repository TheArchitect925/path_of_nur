import Foundation

struct DayRolloverOutcome {
    var snapshot: WatchDaySnapshot?
    var prayers: [WatchPrayerStatus]
    var dhikrSession: WatchDhikrSession?
    var performed: Bool
}

final class DayRolloverEngine {
    private let localStore = WatchLocalStore()

    func performIfNeeded(now: Date) -> DayRolloverOutcome {
        let snapshot = localStore.loadSnapshot()
        let prayers = localStore.loadPrayers()
        let dhikr = localStore.loadDhikr()
        guard let snapshot else {
            return DayRolloverOutcome(snapshot: nil, prayers: prayers, dhikrSession: dhikr, performed: false)
        }
        guard !Calendar.current.isDate(snapshot.date, inSameDayAs: now) else {
            return DayRolloverOutcome(snapshot: snapshot, prayers: prayers, dhikrSession: dhikr, performed: false)
        }

        let resetPrayers = prayers.map {
            WatchPrayerStatus(
                prayerId: $0.prayerId,
                displayName: $0.displayName,
                scheduledTime: alignedDate(from: $0.scheduledTime, to: now),
                status: .pending,
                completedAt: nil,
                source: $0.source
            )
        }
        let nextPrayer = resetPrayers.sorted { $0.scheduledTime < $1.scheduledTime }.first
        let nextSnapshot = WatchDaySnapshot(
            date: now,
            timezone: TimeZone.current.identifier,
            nextPrayerId: nextPrayer?.prayerId ?? snapshot.nextPrayerId,
            nextPrayerTime: nextPrayer?.scheduledTime ?? snapshot.nextPrayerTime,
            currentPrayerId: nil,
            completedPrayerCount: 0,
            totalPrayerCount: snapshot.totalPrayerCount,
            dhikrTodayCount: 0,
            xpToday: snapshot.xpToday,
            oceanDropsToday: 0,
            streakDays: snapshot.streakDays,
            lastSyncAt: snapshot.lastSyncAt
        )
        localStore.saveSnapshot(nextSnapshot)
        localStore.savePrayers(resetPrayers)
        return DayRolloverOutcome(snapshot: nextSnapshot, prayers: resetPrayers, dhikrSession: dhikr, performed: true)
    }

    private func alignedDate(from original: Date, to day: Date) -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: original)
        return Calendar.current.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: components.second ?? 0, of: day) ?? day
    }
}

