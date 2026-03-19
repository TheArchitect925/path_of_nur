import Foundation

final class WatchCacheStore {
  static let appGroupId = "group.com.pathofnur.watch"

  private enum Key {
    static let snapshot = "watch.snapshot.v1"
    static let settings = "watch.settings.v1"
    static let pendingActions = "watch.pending_actions.v1"
    static let hapticsEnabled = "watch.haptics_enabled.v1"
    static let defaultDhikrPreset = "watch.default_dhikr_preset.v1"
    static let dhikrMode = "watch.dhikr.mode.v1"
    static let autoDhikrPreferences = "watch.auto_dhikr.preferences.v1"
    static let autoDhikrSession = "watch.auto_dhikr.session.v1"
    static let postPrayerAdhkar = "watch.post_prayer_adhkar.v1"
  }

  private let defaults: UserDefaults

  init() {
    defaults = UserDefaults(suiteName: Self.appGroupId) ?? .standard
  }

  func loadSnapshot() -> WatchDailySnapshotPayload? {
    decode(WatchDailySnapshotPayload.self, forKey: Key.snapshot)
  }

  func saveSnapshot(_ snapshot: WatchDailySnapshotPayload) {
    encode(snapshot, forKey: Key.snapshot)
  }

  func loadSettings() -> WatchSettingsPayload? {
    decode(WatchSettingsPayload.self, forKey: Key.settings)
  }

  func saveSettings(_ settings: WatchSettingsPayload) {
    encode(settings, forKey: Key.settings)
  }

  func loadPendingActions() -> [WatchActionEnvelopePayload] {
    decode([WatchActionEnvelopePayload].self, forKey: Key.pendingActions) ?? []
  }

  func savePendingActions(_ actions: [WatchActionEnvelopePayload]) {
    encode(actions, forKey: Key.pendingActions)
  }

  func hapticsEnabled() -> Bool {
    if defaults.object(forKey: Key.hapticsEnabled) == nil {
      return true
    }
    return defaults.bool(forKey: Key.hapticsEnabled)
  }

  func setHapticsEnabled(_ enabled: Bool) {
    defaults.set(enabled, forKey: Key.hapticsEnabled)
  }

  func defaultDhikrPreset() -> WatchDhikrPreset {
    guard let raw = defaults.string(forKey: Key.defaultDhikrPreset),
          let preset = WatchDhikrPreset(rawValue: raw) else {
      return .preset33
    }
    return preset
  }

  func setDefaultDhikrPreset(_ preset: WatchDhikrPreset) {
    defaults.set(preset.rawValue, forKey: Key.defaultDhikrPreset)
  }

  func loadDhikrMode() -> WatchDhikrMode {
    guard let raw = defaults.string(forKey: Key.dhikrMode),
          let mode = WatchDhikrMode(rawValue: raw) else {
      return .manual
    }
    return mode
  }

  func setDhikrMode(_ mode: WatchDhikrMode) {
    defaults.set(mode.rawValue, forKey: Key.dhikrMode)
  }

  func loadAutoDhikrPreferences() -> WatchAutoDhikrPreferences {
    decode(WatchAutoDhikrPreferences.self, forKey: Key.autoDhikrPreferences) ?? .default
  }

  func hasAutoDhikrPreferences() -> Bool {
    defaults.data(forKey: Key.autoDhikrPreferences) != nil
  }

  func saveAutoDhikrPreferences(_ preferences: WatchAutoDhikrPreferences) {
    encode(preferences, forKey: Key.autoDhikrPreferences)
  }

  func loadAutoDhikrSession() -> WatchAutoDhikrSessionState? {
    decode(WatchAutoDhikrSessionState.self, forKey: Key.autoDhikrSession)
  }

  func saveAutoDhikrSession(_ session: WatchAutoDhikrSessionState) {
    encode(session, forKey: Key.autoDhikrSession)
  }

  func clearAutoDhikrSession() {
    defaults.removeObject(forKey: Key.autoDhikrSession)
  }

  func loadPostPrayerAdhkarState() -> WatchPostPrayerAdhkarState? {
    decode(WatchPostPrayerAdhkarState.self, forKey: Key.postPrayerAdhkar)
  }

  func savePostPrayerAdhkarState(_ state: WatchPostPrayerAdhkarState) {
    encode(state, forKey: Key.postPrayerAdhkar)
  }

  func clearPostPrayerAdhkarState() {
    defaults.removeObject(forKey: Key.postPrayerAdhkar)
  }

  private func encode<T: Encodable>(_ value: T, forKey key: String) {
    guard let data = try? WatchCodec.encoder.encode(value) else { return }
    defaults.set(data, forKey: key)
  }

  private func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
    guard let data = defaults.data(forKey: key) else { return nil }
    return try? WatchCodec.decoder.decode(type, from: data)
  }
}
