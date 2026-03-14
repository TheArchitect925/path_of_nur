import Foundation

final class WatchRefreshStateStore {
    private let defaults = UserDefaults(suiteName: WatchSharedConstants.appGroupId) ?? UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Key {
        static let freshness = "watch.refresh.freshness"
        static let phase = "watch.refresh.phase"
        static let rollover = "watch.refresh.rollover"
        static let events = "watch.refresh.events"
    }

    func loadFreshnessState() -> SnapshotFreshnessState? {
        decode(SnapshotFreshnessState.self, forKey: Key.freshness)
    }

    func saveFreshnessState(_ value: SnapshotFreshnessState) {
        encode(value, forKey: Key.freshness)
    }

    func loadPrayerPhaseState() -> PrayerPhaseState? {
        decode(PrayerPhaseState.self, forKey: Key.phase)
    }

    func savePrayerPhaseState(_ value: PrayerPhaseState) {
        encode(value, forKey: Key.phase)
    }

    func loadDayRolloverState() -> DayRolloverState? {
        decode(DayRolloverState.self, forKey: Key.rollover)
    }

    func saveDayRolloverState(_ value: DayRolloverState) {
        encode(value, forKey: Key.rollover)
    }

    func loadEvents() -> [BackgroundRefreshEvent] {
        decode([BackgroundRefreshEvent].self, forKey: Key.events) ?? []
    }

    func appendEvent(_ event: BackgroundRefreshEvent) {
        var events = loadEvents()
        events.append(event)
        if events.count > 24 {
            events = Array(events.suffix(24))
        }
        encode(events, forKey: Key.events)
    }

    private func encode<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    private func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
}

