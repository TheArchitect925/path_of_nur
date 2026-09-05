import Foundation

struct WatchStoredQiblaLocation: Codable {
  let latitude: Double
  let longitude: Double
  let savedAt: Date
}

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
    static let dhikrRoutineProgress = "watch.dhikr.routine.progress.v1"
    static let qiblaLocation = "watch.qibla.location.v1"
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

  func loadQiblaLocation() -> WatchStoredQiblaLocation? {
    decode(WatchStoredQiblaLocation.self, forKey: Key.qiblaLocation)
  }

  func saveQiblaLocation(latitude: Double, longitude: Double) {
    encode(
      WatchStoredQiblaLocation(latitude: latitude, longitude: longitude, savedAt: Date()),
      forKey: Key.qiblaLocation
    )
  }

  func loadDhikrRoutineProgress() -> WatchDhikrRoutineProgress? {
    decode(WatchDhikrRoutineProgress.self, forKey: Key.dhikrRoutineProgress)
  }

  func saveDhikrRoutineProgress(_ progress: WatchDhikrRoutineProgress) {
    encode(progress, forKey: Key.dhikrRoutineProgress)
  }

  func clearDhikrRoutineProgress() {
    defaults.removeObject(forKey: Key.dhikrRoutineProgress)
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

#if targetEnvironment(simulator)
extension WatchCacheStore {
  /// Simulator-only demo data so the watch app can be exercised without a
  /// paired iPhone. Launching with
  /// `SIMCTL_CHILD_WATCH_SAMPLE_THEME=<AppThemeMode name>` forces a theme
  /// for visual checks; a real phone-synced snapshot for today is never
  /// overwritten.
  func seedSimulatorSampleDataIfNeeded() {
    let themeOverride = ProcessInfo.processInfo.environment["WATCH_SAMPLE_THEME"]

    let dayFormatter = DateFormatter()
    dayFormatter.calendar = Calendar(identifier: .gregorian)
    dayFormatter.locale = Locale(identifier: "en_US_POSIX")
    dayFormatter.dateFormat = "yyyy-MM-dd"
    let todayKey = dayFormatter.string(from: Date())

    let existingSettings = loadSettings()
    if themeOverride != nil || existingSettings == nil {
      saveSettings(
        WatchSettingsPayload(
          schemaVersion: existingSettings?.schemaVersion ?? 1,
          prayerNotificationsEnabled: existingSettings?.prayerNotificationsEnabled ?? true,
          enabledPrayerIds: existingSettings?.enabledPrayerIds
              ?? ["fajr", "dhuhr", "asr", "maghrib", "isha"],
          followUpReminderEnabled: existingSettings?.followUpReminderEnabled ?? true,
          followUpDelayMinutes: existingSettings?.followUpDelayMinutes ?? 20,
          snoozeDurationMinutes: existingSettings?.snoozeDurationMinutes ?? 10,
          dhikrReminderEnabled: existingSettings?.dhikrReminderEnabled ?? true,
          quietModeEnabled: existingSettings?.quietModeEnabled ?? false,
          watchThemeMode: themeOverride ?? existingSettings?.watchThemeMode ?? "midnight",
          lastUpdatedAt: Date()
        )
      )
    }

    guard loadSnapshot()?.date != todayKey else { return }

    let calendar = Calendar.current
    func time(_ hour: Int, _ minute: Int) -> Date {
      calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    let prayers: [WatchPrayerPayload] = [
      WatchPrayerPayload(
        prayerId: "fajr", displayName: "Fajr", scheduledTime: time(5, 32),
        status: .completed, completedAt: time(5, 41), timing: "on_time", source: "sample"
      ),
      WatchPrayerPayload(
        prayerId: "dhuhr", displayName: "Dhuhr", scheduledTime: time(13, 12),
        status: .completed, completedAt: time(13, 25), timing: "on_time", source: "sample"
      ),
      WatchPrayerPayload(
        prayerId: "asr", displayName: "Asr", scheduledTime: time(16, 48),
        status: .pending, completedAt: nil, timing: nil, source: "sample"
      ),
      WatchPrayerPayload(
        prayerId: "maghrib", displayName: "Maghrib", scheduledTime: time(19, 58),
        status: .pending, completedAt: nil, timing: nil, source: "sample"
      ),
      WatchPrayerPayload(
        prayerId: "isha", displayName: "Isha", scheduledTime: time(21, 24),
        status: .pending, completedAt: nil, timing: nil, source: "sample"
      ),
    ]

    saveSnapshot(
      WatchDailySnapshotPayload(
        schemaVersion: 1,
        snapshotId: "simulator-sample-\(todayKey)",
        generatedAt: Date(),
        date: todayKey,
        timezone: TimeZone.current.identifier,
        nextPrayerId: nil,
        nextPrayerTime: nil,
        currentPrayerId: nil,
        completedPrayerCount: 2,
        totalPrayerCount: 5,
        dhikrTodayCount: 33,
        xpToday: 45,
        oceanDropsToday: 12,
        streakDays: 6,
        currentLevel: 4,
        growthStageKey: "sapling",
        prayers: prayers,
        activeDhikrSession: nil,
        dhikrRoutines: [
          WatchDhikrRoutinePayload(
            id: "after-salah",
            kind: "afterSalah",
            title: "After salah",
            sessionLabel: "After-salah tasbih",
            totalCount: 100,
            estimatedMinutes: 4,
            steps: [
              WatchDhikrRoutineStepPayload(id: "subhanallah", title: "SubhanAllah", arabic: "سُبْحَانَ ٱللَّهِ", transliteration: "SubhanAllah", translation: "Glory be to Allah", count: 33),
              WatchDhikrRoutineStepPayload(id: "alhamdulillah", title: "Alhamdulillah", arabic: "ٱلْحَمْدُ لِلَّهِ", transliteration: "Alhamdulillah", translation: "All praise is for Allah", count: 33),
              WatchDhikrRoutineStepPayload(id: "allahukbar", title: "Allahu Akbar", arabic: "ٱللَّهُ أَكْبَرُ", transliteration: "Allahu Akbar", translation: "Allah is Most Great", count: 33),
              WatchDhikrRoutineStepPayload(id: "tahlil-closing", title: "La ilaha illAllah (closing)", arabic: "لَا إِلَٰهَ إِلَّا ٱللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", transliteration: "La ilaha illAllahu wahdahu la sharika lah", translation: "There is no god but Allah alone, without partner.", count: 1),
            ]
          ),
          WatchDhikrRoutinePayload(
            id: "morning",
            kind: "morning",
            title: "Morning adhkar",
            sessionLabel: "Morning adhkar",
            totalCount: 9,
            estimatedMinutes: 3,
            steps: [
              WatchDhikrRoutineStepPayload(id: "m1", title: "Upon Entering the Morning", arabic: "اَللّٰهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ وَإِلَيْكَ النُّشُوْرُ", transliteration: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur.", translation: "O Allah, by You we have entered the morning and by You we enter upon the evening. By You we live and we die, and to You is the resurrection.", count: 1),
              WatchDhikrRoutineStepPayload(id: "m2", title: "Ask Allah for Good Health and Protection", arabic: "اَللّٰهُمَّ عَافِنِيْ فِيْ بَدَنِيْ", transliteration: "Allahumma afini fi badani", translation: "O Allah, grant my body health.", count: 3),
            ]
          ),
        ],
        completedRoutineEntriesToday: [],
        spiritualPrompt: WatchSpiritualPromptPayload(
          kind: "ayah",
          title: "Remembrance",
          shortText: "In the remembrance of Allah hearts find rest.",
          inlineText: "Hearts find rest in dhikr",
          circularText: "13:28"
        ),
        lastSyncAt: Date(),
        sourceVersion: "sim-sample"
      )
    )
  }
}
#endif
