import Foundation

struct WatchGlanceData {
    var nextPrayerName: String
    var nextPrayerTime: Date?
    var nextPrayerCountdown: String
    var todayPrayerProgress: String
    var dhikrToday: Int
    var streakDays: Int
    var xpToday: Int
    var oceanDropsToday: Int
    var lastSyncAt: Date?
}

struct WatchGlanceDataProvider {
    private let store: WatchLocalStore

    init(store: WatchLocalStore = WatchLocalStore()) {
        self.store = store
    }

    func data(now: Date = Date()) -> WatchGlanceData {
        let snapshot = store.loadSnapshot()
        let prayers = store.loadPrayers()
        let nextPrayer = getNextPrayer(now: now, prayers: prayers, snapshot: snapshot)

        return WatchGlanceData(
            nextPrayerName: nextPrayer?.displayName ?? displayName(for: snapshot?.nextPrayerId) ?? "Next prayer",
            nextPrayerTime: nextPrayer?.scheduledTime ?? snapshot?.nextPrayerTime,
            nextPrayerCountdown: countdownText(to: nextPrayer?.scheduledTime ?? snapshot?.nextPrayerTime, now: now),
            todayPrayerProgress: getPrayerProgress(snapshot: snapshot, prayers: prayers),
            dhikrToday: getDhikrToday(snapshot: snapshot),
            streakDays: getStreak(snapshot: snapshot),
            xpToday: getXP(snapshot: snapshot),
            oceanDropsToday: getOceanDrops(snapshot: snapshot),
            lastSyncAt: getLastSync(snapshot: snapshot)
        )
    }

    func getNextPrayer(now: Date = Date()) -> WatchPrayerStatus? {
        getNextPrayer(now: now, prayers: store.loadPrayers(), snapshot: store.loadSnapshot())
    }

    func getPrayerProgress() -> String {
        getPrayerProgress(snapshot: store.loadSnapshot(), prayers: store.loadPrayers())
    }

    func getDhikrToday() -> Int {
        getDhikrToday(snapshot: store.loadSnapshot())
    }

    func getStreak() -> Int {
        getStreak(snapshot: store.loadSnapshot())
    }

    func getXP() -> Int {
        getXP(snapshot: store.loadSnapshot())
    }

    func getOceanDrops() -> Int {
        getOceanDrops(snapshot: store.loadSnapshot())
    }

    func getLastSync() -> Date? {
        getLastSync(snapshot: store.loadSnapshot())
    }

    private func getNextPrayer(
        now: Date,
        prayers: [WatchPrayerStatus],
        snapshot: WatchDaySnapshot?
    ) -> WatchPrayerStatus? {
        prayers
            .sorted { $0.scheduledTime < $1.scheduledTime }
            .first { $0.scheduledTime > now }
        ?? prayers.sorted { $0.scheduledTime < $1.scheduledTime }.first
    }

    private func getPrayerProgress(snapshot: WatchDaySnapshot?, prayers: [WatchPrayerStatus]) -> String {
        let completed = snapshot?.completedPrayerCount ?? prayers.filter { $0.status == .completed }.count
        let total = snapshot?.totalPrayerCount ?? max(prayers.count, 5)
        return "\(completed)/\(total)"
    }

    private func getDhikrToday(snapshot: WatchDaySnapshot?) -> Int {
        snapshot?.dhikrTodayCount ?? 0
    }

    private func getStreak(snapshot: WatchDaySnapshot?) -> Int {
        snapshot?.streakDays ?? 0
    }

    private func getXP(snapshot: WatchDaySnapshot?) -> Int {
        snapshot?.xpToday ?? 0
    }

    private func getOceanDrops(snapshot: WatchDaySnapshot?) -> Int {
        snapshot?.oceanDropsToday ?? 0
    }

    private func getLastSync(snapshot: WatchDaySnapshot?) -> Date? {
        snapshot?.lastSyncAt
    }

    private func displayName(for prayerId: String?) -> String? {
        switch prayerId?.lowercased() {
        case "fajr": return "Fajr"
        case "dhuhr": return "Dhuhr"
        case "asr": return "Asr"
        case "maghrib": return "Maghrib"
        case "isha": return "Isha"
        default: return nil
        }
    }

    private func countdownText(to target: Date?, now: Date) -> String {
        guard let target else { return "--" }
        let seconds = max(0, Int(target.timeIntervalSince(now)))
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

