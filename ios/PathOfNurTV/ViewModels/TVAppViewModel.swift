import AVFoundation
import Combine
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// The time. In the simulator it can be given, so that a Friday, a night or
/// a day of the year can be looked at without waiting for it:
/// TV_SAMPLE_DATE=2026-10-16, or 2026-10-02T13:15 by the machine's clock.
enum TVClock {
  static func now() -> Date {
    sample ?? Date()
  }

  private static let sample: Date? = {
    #if targetEnvironment(simulator)
    guard let given = ProcessInfo.processInfo.environment["TV_SAMPLE_DATE"] else {
      return nil
    }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
    return formatter.date(from: given.contains("T") ? given : "\(given)T12:00")
    #else
    return nil
    #endif
  }()
}

final class TVAppViewModel: ObservableObject {
  @Published var selectedRoute: TVRoute
  @Published private(set) var activeColumn: TVShellColumn
  @Published private(set) var navigationItems: [TVNavigationItem]
  @Published private(set) var preferredContentSectionByRoute: [TVRoute: String]
  @Published private(set) var navigationFocusRequest = 0
  @Published private(set) var contentFocusRequest = 0

  let profilesViewModel: TVProfilesViewModel
  let prayerService: TVPrayerService
  let homeViewModel: TVHomeViewModel
  let quranViewModel: TVQuranViewModel
  let favoritesViewModel = TVFavoritesViewModel()
  let settingsViewModel: TVSettingsViewModel
  let arabicViewModel = TVArabicViewModel()
  let learnViewModel = TVLearnViewModel()
  let gamesViewModel = TVGamesViewModel()
  let prayerViewModel: TVPrayerViewModel
  let dhikrViewModel: TVDhikrViewModel
  let kidsViewModel = TVKidsViewModel()
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    TVTelemetry.bootstrap(userDefaults: userDefaults)
    let prayerService = TVPrayerService(userDefaults: userDefaults)
    self.prayerService = prayerService
    #if targetEnvironment(simulator)
    // TV_SAMPLE_FRESH=1 opens the app as it is before anything has been
    // read, whatever an earlier launch left behind.
    if ProcessInfo.processInfo.environment["TV_SAMPLE_FRESH"] == "1" {
      userDefaults.removeObject(forKey: TVQuranViewModel.placeStorageKey)
      userDefaults.removeObject(forKey: TVQuranTranslationChoice.storageKey)
      userDefaults.removeObject(forKey: TVQuranViewModel.bookmarksStorageKey)
      userDefaults.removeObject(forKey: TVDhikrViewModel.completedRoutinesKey)
      userDefaults.removeObject(forKey: TVDhikrViewModel.routineInProgressKey)
    }
    #endif
    dhikrViewModel = TVDhikrViewModel(userDefaults: userDefaults)
    let quranViewModel = TVQuranViewModel(userDefaults: userDefaults)
    self.quranViewModel = quranViewModel
    homeViewModel = TVHomeViewModel(prayerService: prayerService)
    prayerViewModel = TVPrayerViewModel(prayerService: prayerService)
    navigationItems = TVRoute.released.map(TVNavigationItem.init)
    preferredContentSectionByRoute = Dictionary(
      uniqueKeysWithValues: TVRoute.allCases.map { ($0, $0.defaultContentSection) }
    )
    activeColumn = .content

    let storedActiveProfileId = userDefaults.string(forKey: Self.activeProfileStorageKey)
    let lastRouteByProfileId = Self.decodeRouteDictionary(
      userDefaults.string(forKey: Self.lastRouteStorageKey)
    )
    let lastOpenedAtByProfileId = Self.decodeDateDictionary(
      userDefaults.string(forKey: Self.lastOpenedAtStorageKey)
    )

    profilesViewModel = TVProfilesViewModel(
      activeProfileId: storedActiveProfileId,
      lastRouteByProfileId: lastRouteByProfileId,
      lastOpenedAtByProfileId: lastOpenedAtByProfileId
    )
    settingsViewModel = TVSettingsViewModel(
      startupPreferenceRawValue: userDefaults.string(
        forKey: Self.startupPreferenceStorageKey
      ),
      defaultReciterRawValue: userDefaults.string(
        forKey: Self.defaultReciterStorageKey
      ),
      showListeningTranslationByDefault: userDefaults.object(
        forKey: Self.defaultListeningTranslationStorageKey
      ) as? Bool,
      showListeningTransliterationByDefault: userDefaults.object(
        forKey: Self.defaultListeningTransliterationStorageKey
      ) as? Bool
    )
    quranViewModel.applyPreferenceDefaults(
      reciter: settingsViewModel.defaultReciter,
      showTranslation: settingsViewModel.showListeningTranslationByDefault,
      showTransliteration:
          settingsViewModel.showListeningTransliterationByDefault
    )
    selectedRoute = settingsViewModel.startupPreference.openingRoute(
      lastUsedRoute: profilesViewModel.routeForActiveProfile()
    )
    // "Opens on the reader": a viewer who has chosen to open on the Qur'an
    // opens in it, where they left it, and not on the list beside it.
    if settingsViewModel.startupPreference == .quran, quranViewModel.place != nil {
      preferredContentSectionByRoute[.quran] = TVFocusSectionId.quranReader
    }
    #if targetEnvironment(simulator)
    // Simulator-only, like TV_SAMPLE_THEME: open straight on a route so a
    // screen can be screenshotted without driving the sidebar.
    if let forced = ProcessInfo.processInfo.environment["TV_SAMPLE_ROUTE"],
       let route = TVRoute(rawValue: forced) {
      selectedRoute = route
    }
    if let section = ProcessInfo.processInfo.environment["TV_SAMPLE_SECTION"] {
      markContentSectionFocused(section, for: selectedRoute)
    }
    // TV_SAMPLE_ROUTINE=after-salah opens a routine in the player, or a
    // phrase (phrase.subhanallah), and TV_SAMPLE_COUNT=12 counts that far.
    if let routineId = ProcessInfo.processInfo.environment["TV_SAMPLE_ROUTINE"],
       let routine = (dhikrViewModel.routines + dhikrViewModel.phrases)
         .first(where: { $0.id == routineId }) {
      dhikrViewModel.openRoutine(routine)
      let counted = ProcessInfo.processInfo.environment["TV_SAMPLE_COUNT"].flatMap(Int.init) ?? 0
      for _ in 0..<max(min(counted, routine.totalCount - 1), 0) {
        dhikrViewModel.countRoutine()
      }
    }
    // TV_SAMPLE_SURAH=2 TV_SAMPLE_AYAH=282 opens the reader there, and
    // TV_SAMPLE_LISTENING=1 opens that ayah full screen.
    if let surah = ProcessInfo.processInfo.environment["TV_SAMPLE_SURAH"].flatMap(Int.init) {
      quranViewModel.select(
        surahNumber: surah,
        ayahNumber: ProcessInfo.processInfo.environment["TV_SAMPLE_AYAH"].flatMap(Int.init) ?? 1
      )
    }
    if ProcessInfo.processInfo.environment["TV_SAMPLE_LISTENING"] == "1" {
      quranViewModel.openListeningMode()
    }
    // TV_SAMPLE_PHRASE_TARGET=33 sets what each phrase is counted to.
    if let target = ProcessInfo.processInfo.environment["TV_SAMPLE_PHRASE_TARGET"].flatMap(Int.init) {
      dhikrViewModel.selectPhraseTarget(target)
    }
    // TV_SAMPLE_OPTIONS=1 opens the player's options beside it.
    if ProcessInfo.processInfo.environment["TV_SAMPLE_OPTIONS"] == "1" {
      quranViewModel.isPlayerOptionsPresented = true
    }
    // TV_SAMPLE_TRANSLATION=bn (or none) and TV_SAMPLE_RECITER=sudais.
    if let id = ProcessInfo.processInfo.environment["TV_SAMPLE_TRANSLATION"] {
      quranViewModel.selectTranslation(TVQuranTranslation.withID(id))
    }
    if let id = ProcessInfo.processInfo.environment["TV_SAMPLE_RECITER"],
       let reciter = TVQuranReciter(rawValue: id) {
      quranViewModel.selectReciter(reciter)
    }
    #endif
    quranViewModel.onDiagnosticsEvent = { [weak self] name, metadata in
      guard let self else { return }
      TVTelemetry.logEvent(name, metadata: metadata, userDefaults: self.userDefaults)
    }
    // The reciter chosen beside the reader is the reciter from then on, as
    // the one chosen in Settings is.
    quranViewModel.onReciterChosen = { [weak self] reciter in
      guard let self else { return }
      self.settingsViewModel.selectDefaultReciter(reciter)
      self.cloudShare?.record(reciter: reciter.rawValue)
      self.persistSessionState()
    }
    startCloudShare()
    // So is what is shown while listening, chosen beside the recitation.
    quranViewModel.onListeningTextChosen = { [weak self] translation, transliteration in
      guard let self else { return }
      self.settingsViewModel.setShowListeningTranslationByDefault(translation)
      self.settingsViewModel.setShowListeningTransliterationByDefault(transliteration)
      self.persistSessionState()
    }
    // The verse of the day turns with the day, while the app is open.
    homeViewModel.onRefresh = { [weak self] now in
      self?.quranViewModel.refreshVerseOfTheDay(now: now)
    }
    quranViewModel.onDiagnosticsError = { [weak self] name, message, metadata in
      guard let self else { return }
      TVTelemetry.recordError(
        name,
        message: message,
        metadata: metadata,
        userDefaults: self.userDefaults
      )
    }
    profilesViewModel.updateSession(route: selectedRoute, now: Date())
    TVTelemetry.logEvent(
      "tvos_route_opened",
      metadata: [
        "route": selectedRoute.rawValue,
        "source": "app_startup",
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
    prayerService.startIfNeeded()
  }

  var selectedTab: TVTab {
    get { selectedRoute.tab }
    set {
      let route: TVRoute
      switch newValue {
      case .home:
        route = .home
      case .profiles:
        route = .profiles
      case .quran:
        route = .quran
      case .favorites:
        route = .favorites
      case .settings:
        route = .settings
      case .arabic:
        route = .arabic
      case .learn:
        route = .learn
      case .games:
        route = .games
      case .prayer:
        route = .prayer
      case .dhikr:
        route = .dhikr
      case .kids:
        route = .kids
      }
      navigate(to: route, preferredColumn: .content)
    }
  }

  var selectedNavigationItem: TVNavigationItem {
    navigationItems.first(where: { $0.route == selectedRoute }) ?? TVNavigationItem(route: .home)
  }

  func navigate(to route: TVRoute, preferredColumn: TVShellColumn = .content) {
    let route = route.isReleased ? route : .home
    selectedRoute = route
    profilesViewModel.updateSession(route: route, now: Date())
    TVTelemetry.logEvent(
      "tvos_route_opened",
      metadata: [
        "route": route.rawValue,
        "column": preferredColumn.rawValue,
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
    if preferredColumn == .content {
      focusContent(preferredSection: preferredContentSection(for: route))
    } else {
      focusNavigation()
    }
  }

  /// Opens the Qur'an at a place: in the reader, or full screen to listen.
  func openQuran(at place: TVQuranPlace, listening: Bool = false) {
    quranViewModel.select(surahNumber: place.surahNumber, ayahNumber: place.ayahNumber)
    preferredContentSectionByRoute[.quran] = TVFocusSectionId.quranReader
    navigate(to: .quran, preferredColumn: .content)
    if listening {
      quranViewModel.openListeningMode()
    }
  }

  func preferredContentSection(for route: TVRoute) -> String {
    preferredContentSectionByRoute[route] ?? route.defaultContentSection
  }

  func markContentSectionFocused(_ section: String, for route: TVRoute? = nil) {
    let targetRoute = route ?? selectedRoute
    preferredContentSectionByRoute[targetRoute] = section
    activeColumn = .content
  }

  func selectHouseholdProfile(_ profile: TVHouseholdProfile) {
    let route = profilesViewModel.activateProfile(profile, now: Date())
    TVTelemetry.logEvent(
      "tvos_profile_switched",
      metadata: [
        "profileId": profile.id,
        "route": route.rawValue,
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
    navigate(to: route, preferredColumn: .content)
  }

  func selectStartupPreference(_ preference: TVStartupPreference) {
    settingsViewModel.selectStartupPreference(preference)
    TVTelemetry.logEvent(
      "tvos_settings_changed",
      metadata: [
        "setting": "startupPreference",
        "value": preference.rawValue,
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
  }

  func selectDefaultReciter(_ reciter: TVQuranReciter) {
    settingsViewModel.selectDefaultReciter(reciter)
    cloudShare?.record(reciter: reciter.rawValue)
    quranViewModel.applyPreferenceDefaults(
      reciter: reciter,
      showTranslation: settingsViewModel.showListeningTranslationByDefault,
      showTransliteration:
          settingsViewModel.showListeningTransliterationByDefault
    )
    TVTelemetry.logEvent(
      "tvos_settings_changed",
      metadata: [
        "setting": "defaultReciter",
        "value": reciter.rawValue,
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
  }

  func setShowListeningTranslationByDefault(_ value: Bool) {
    settingsViewModel.setShowListeningTranslationByDefault(value)
    quranViewModel.applyPreferenceDefaults(
      reciter: settingsViewModel.defaultReciter,
      showTranslation: value,
      showTransliteration:
          settingsViewModel.showListeningTransliterationByDefault
    )
    TVTelemetry.logEvent(
      "tvos_settings_changed",
      metadata: [
        "setting": "listeningTranslationDefault",
        "value": value ? "on" : "off",
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
  }

  func setShowListeningTransliterationByDefault(_ value: Bool) {
    settingsViewModel.setShowListeningTransliterationByDefault(value)
    quranViewModel.applyPreferenceDefaults(
      reciter: settingsViewModel.defaultReciter,
      showTranslation: settingsViewModel.showListeningTranslationByDefault,
      showTransliteration: value
    )
    TVTelemetry.logEvent(
      "tvos_settings_changed",
      metadata: [
        "setting": "listeningTransliterationDefault",
        "value": value ? "on" : "off",
      ],
      userDefaults: userDefaults
    )
    persistSessionState()
  }

  // MARK: - Shared with the phone

  private var cloudShare: TVQuranCloudShare?

  /// The reading place, bookmarks, reciter and translation are kept in step
  /// with the phone through iCloud (`TVQuranCloudShare`).
  private func startCloudShare() {
    #if targetEnvironment(simulator)
    // The simulator has no iCloud account; a test must not reach one.
    guard ProcessInfo.processInfo.environment["TV_SAMPLE_CLOUD"] == "1" else { return }
    #endif
    guard FileManager.default.ubiquityIdentityToken != nil else { return }
    let share = TVQuranCloudShare(store: NSUbiquitousKeyValueStore.default, userDefaults: userDefaults)
    cloudShare = share
    let quran = quranViewModel
    share.seed(
      place: quran.place?.key,
      bookmarks: quran.bookmarks.map(\.key),
      reciter: settingsViewModel.defaultReciter.rawValue,
      translation: TVQuranTranslationCodes.code(for: quran.translation)
    )
    share.onRemoteChange = { [weak self] before, after in
      guard let self else { return }
      let quran = self.quranViewModel
      quran.applyShared(
        place: after.placeAt != before.placeAt ? TVQuranPlace(key: after.place) : nil,
        bookmarks: after.bookmarksAt != before.bookmarksAt
          ? after.bookmarks?.compactMap { TVQuranPlace(key: $0) }
          : nil,
        translation: after.translationAt != before.translationAt
          ? after.translation.flatMap(TVQuranTranslationCodes.translation(for:))
          : nil
      )
      if after.reciterAt != before.reciterAt,
         let reciter = after.reciter.flatMap(TVQuranReciter.init(rawValue:)) {
        self.selectDefaultReciter(reciter)
      }
    }
    quran.onPlaceKept = { [weak share] place in
      share?.record(place: place.key)
    }
    quran.onBookmarksChanged = { [weak share] bookmarks in
      share?.record(bookmarks: bookmarks.map(\.key))
    }
    quran.onTranslationChosen = { [weak share] translation in
      share?.record(translation: TVQuranTranslationCodes.code(for: translation))
    }
    share.sync()
  }

  func selectTranslation(_ translation: TVQuranTranslation?) {
    // Settings shows the choice, and draws from this model, not the Qur'an's.
    objectWillChange.send()
    quranViewModel.selectTranslation(translation)
    TVTelemetry.logEvent(
      "tvos_settings_changed",
      metadata: [
        "setting": "translation",
        "value": translation?.id ?? TVQuranTranslationChoice.noneValue,
      ],
      userDefaults: userDefaults
    )
  }

  func focusNavigation() {
    activeColumn = .navigation
    navigationFocusRequest += 1
  }

  func focusContent(preferredSection: String? = nil) {
    activeColumn = .content
    if let preferredSection {
      preferredContentSectionByRoute[selectedRoute] = preferredSection
    }
    contentFocusRequest += 1
  }

  func setNavigationFocused() {
    activeColumn = .navigation
  }

  private func persistSessionState() {
    userDefaults.set(
      profilesViewModel.activeProfileId,
      forKey: Self.activeProfileStorageKey
    )
    userDefaults.set(
      Self.encodeRouteDictionary(profilesViewModel.lastRouteByProfileId),
      forKey: Self.lastRouteStorageKey
    )
    userDefaults.set(
      Self.encodeDateDictionary(profilesViewModel.lastOpenedAtByProfileId),
      forKey: Self.lastOpenedAtStorageKey
    )
    userDefaults.set(
      settingsViewModel.startupPreference.rawValue,
      forKey: Self.startupPreferenceStorageKey
    )
    userDefaults.set(
      settingsViewModel.defaultReciter.rawValue,
      forKey: Self.defaultReciterStorageKey
    )
    userDefaults.set(
      settingsViewModel.showListeningTranslationByDefault,
      forKey: Self.defaultListeningTranslationStorageKey
    )
    userDefaults.set(
      settingsViewModel.showListeningTransliterationByDefault,
      forKey: Self.defaultListeningTransliterationStorageKey
    )
  }

  private static let activeProfileStorageKey = "PathOfNurTV.activeProfileId"
  private static let lastRouteStorageKey = "PathOfNurTV.lastRouteByProfile"
  private static let lastOpenedAtStorageKey = "PathOfNurTV.lastOpenedAtByProfile"
  private static let startupPreferenceStorageKey = "PathOfNurTV.startupPreference"
  private static let defaultReciterStorageKey = "PathOfNurTV.defaultReciter"
  private static let defaultListeningTranslationStorageKey =
      "PathOfNurTV.defaultListeningTranslation"
  private static let defaultListeningTransliterationStorageKey =
      "PathOfNurTV.defaultListeningTransliteration"

  private static func decodeRouteDictionary(_ raw: String?) -> [String: TVRoute] {
    guard
      let raw,
      let data = raw.data(using: .utf8),
      let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: String]
    else {
      return [:]
    }

    var mapped: [String: TVRoute] = [:]
    for (key, value) in decoded {
      if let route = TVRoute(rawValue: value) {
        mapped[key] = route
      }
    }
    return mapped
  }

  private static func encodeRouteDictionary(_ value: [String: TVRoute]) -> String? {
    let raw = value.mapValues(\.rawValue)
    guard
      let data = try? JSONSerialization.data(withJSONObject: raw, options: []),
      let string = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return string
  }

  private static func decodeDateDictionary(_ raw: String?) -> [String: Date] {
    guard
      let raw,
      let data = raw.data(using: .utf8),
      let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: String]
    else {
      return [:]
    }

    let formatter = ISO8601DateFormatter()
    var mapped: [String: Date] = [:]
    for (key, value) in decoded {
      if let date = formatter.date(from: value) {
        mapped[key] = date
      }
    }
    return mapped
  }

  private static func encodeDateDictionary(_ value: [String: Date]) -> String? {
    let formatter = ISO8601DateFormatter()
    let raw = value.mapValues { formatter.string(from: $0) }
    guard
      let data = try? JSONSerialization.data(withJSONObject: raw, options: []),
      let string = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return string
  }
}

final class TVSettingsViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.settingsHero()
  @Published private(set) var startupPreference: TVStartupPreference
  @Published private(set) var defaultReciter: TVQuranReciter
  @Published private(set) var showListeningTranslationByDefault: Bool
  @Published private(set) var showListeningTransliterationByDefault: Bool

  init(
    startupPreferenceRawValue: String?,
    defaultReciterRawValue: String?,
    showListeningTranslationByDefault: Bool?,
    showListeningTransliterationByDefault: Bool?
  ) {
    let storedStartup = TVStartupPreference(rawValue: startupPreferenceRawValue ?? "")
    startupPreference =
        storedStartup.flatMap { TVStartupPreference.released.contains($0) ? $0 : nil } ??
        .lastUsed
    defaultReciter =
        TVQuranReciter(rawValue: defaultReciterRawValue ?? "") ?? .phoneDefault
    self.showListeningTranslationByDefault =
        showListeningTranslationByDefault ?? true
    self.showListeningTransliterationByDefault =
        showListeningTransliterationByDefault ?? true
  }

  var startupTitle: String {
    tvLocalized("When the app opens")
  }

  var listeningTitle: String {
    tvLocalized("Listening")
  }

  var detailRailTitle: String {
    tvLocalized("Your settings")
  }

  var detailRailPoints: [String] {
    [
      String(
        format: tvLocalized("Opens on: %@"),
        tvLocalized(startupPreference.titleKey)
      ),
      String(
        format: tvLocalized("Reciter: %@"),
        defaultReciter.displayName
      ),
      showListeningTranslationByDefault
          ? tvLocalized("Translation shown while listening")
          : tvLocalized("Translation hidden while listening"),
      showListeningTransliterationByDefault
          ? tvLocalized("Transliteration shown while listening")
          : tvLocalized("Transliteration hidden while listening"),
    ]
  }

  /// "Path of Nūr 1.3.0 (54)", so a tester can say which build they hold.
  var versionLine: String {
    let info = Bundle.main.infoDictionary
    let version = info?["CFBundleShortVersionString"] as? String ?? ""
    let build = info?["CFBundleVersion"] as? String ?? ""
    return "Path of Nūr \(version) (\(build))"
  }

  func selectStartupPreference(_ preference: TVStartupPreference) {
    startupPreference = preference
  }

  func selectDefaultReciter(_ reciter: TVQuranReciter) {
    defaultReciter = reciter
  }

  func setShowListeningTranslationByDefault(_ value: Bool) {
    showListeningTranslationByDefault = value
  }

  func setShowListeningTransliterationByDefault(_ value: Bool) {
    showListeningTransliterationByDefault = value
  }
}

final class TVProfilesViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.profilesHero()
  @Published private(set) var profiles: [TVHouseholdProfile] =
      TVSeedRepository.householdProfiles()
  @Published private(set) var continuityCards: [TVSessionContinuityCard] = []
  @Published private(set) var activeProfileId: String
  @Published private(set) var selectedProfileId: String
  @Published private(set) var selectedContinuityCardId: String
  @Published private(set) var lastRouteByProfileId: [String: TVRoute]
  @Published private(set) var lastOpenedAtByProfileId: [String: Date]

  init(
    activeProfileId: String?,
    lastRouteByProfileId: [String: TVRoute],
    lastOpenedAtByProfileId: [String: Date]
  ) {
    let seededProfiles = TVSeedRepository.householdProfiles()
    profiles = seededProfiles
    let resolvedActiveProfileId = seededProfiles.contains(where: { $0.id == activeProfileId })
        ? activeProfileId ?? seededProfiles.first?.id ?? ""
        : seededProfiles.first?.id ?? ""
    self.activeProfileId = resolvedActiveProfileId
    selectedProfileId = resolvedActiveProfileId
    selectedContinuityCardId = resolvedActiveProfileId

    var normalizedRoutes = lastRouteByProfileId
    for profile in seededProfiles where normalizedRoutes[profile.id] == nil {
      normalizedRoutes[profile.id] = profile.preferredRoute
    }
    self.lastRouteByProfileId = normalizedRoutes
    self.lastOpenedAtByProfileId = lastOpenedAtByProfileId

    rebuildContinuityCards()
  }

  var activeProfile: TVHouseholdProfile? {
    profiles.first(where: { $0.id == activeProfileId }) ?? profiles.first
  }

  var selectedProfile: TVHouseholdProfile? {
    profiles.first(where: { $0.id == selectedProfileId }) ?? activeProfile
  }

  var selectedContinuityCard: TVSessionContinuityCard? {
    continuityCards.first(where: { $0.id == selectedContinuityCardId }) ?? continuityCards.first
  }

  var primaryTitle: String {
    tvLocalized("Choose a household profile")
  }

  var primarySubtitle: String {
    tvLocalized("Switch the room into the right family context quickly, without turning Apple TV into a dense account-management surface.")
  }

  var continuityTitle: String {
    tvLocalized("Session continuity")
  }

  var continuitySubtitle: String {
    tvLocalized("Each profile keeps a calm return path so Qur'an, learning, and worship can resume from the strongest place for that part of the household.")
  }

  var detailRailTitle: String {
    tvLocalized("Active profile")
  }

  var continuityRailTitle: String {
    tvLocalized("Current session continuity")
  }

  var continuityRailMetaTitle: String {
    tvLocalized("Ready-to-resume signals")
  }

  func activateProfile(_ profile: TVHouseholdProfile, now: Date) -> TVRoute {
    activeProfileId = profile.id
    selectedProfileId = profile.id
    selectedContinuityCardId = profile.id
    lastOpenedAtByProfileId[profile.id] = now
    let route = lastRouteByProfileId[profile.id] ?? profile.preferredRoute
    lastRouteByProfileId[profile.id] = route
    rebuildContinuityCards()
    return route
  }

  func selectContinuityCard(_ card: TVSessionContinuityCard) {
    selectedContinuityCardId = card.id
    selectedProfileId = card.id
  }

  func routeForActiveProfile() -> TVRoute {
    lastRouteByProfileId[activeProfileId] ?? activeProfile?.preferredRoute ?? .home
  }

  func updateSession(route: TVRoute, now: Date) {
    guard !activeProfileId.isEmpty else { return }
    lastRouteByProfileId[activeProfileId] = route
    lastOpenedAtByProfileId[activeProfileId] = now
    selectedContinuityCardId = activeProfileId
    rebuildContinuityCards()
  }

  private func rebuildContinuityCards() {
    continuityCards = TVSeedRepository.sessionContinuityCards(
      profiles: profiles,
      activeProfileId: activeProfileId,
      lastRouteByProfileId: lastRouteByProfileId,
      lastOpenedAtByProfileId: lastOpenedAtByProfileId
    )
    if continuityCards.contains(where: { $0.id == selectedContinuityCardId }) == false {
      selectedContinuityCardId = continuityCards.first?.id ?? activeProfileId
    }
  }
}

final class TVFavoritesViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.favoritesHero()
  @Published private(set) var primaryItems: [TVLearnHubItem] =
      TVSeedRepository.favoritesPrimaryItems()
  @Published private(set) var savedItems: [TVSavedItemCard] =
      TVSeedRepository.favoritesSavedItems()
  @Published private(set) var selectedPrimaryItemId: String
  @Published private(set) var selectedSavedItemId: String

  init() {
    selectedPrimaryItemId = TVSeedRepository.favoritesPrimaryItems().first?.id ?? ""
    selectedSavedItemId = TVSeedRepository.favoritesSavedItems().first?.id ?? ""
  }

  var primaryTitle: String {
    tvLocalized("Choose a saved lane")
  }

  var primarySubtitle: String {
    tvLocalized("Start with one calm return path for the room: bookmarked ayahs, listening playlists, or watch-later learning picks.")
  }

  var savedItemsTitle: String {
    tvLocalized("Saved and ready to resume")
  }

  var savedItemsSubtitle: String {
    tvLocalized("Keep the strongest saved return close on TV so reading, listening, or reflection can resume without typing or list management.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected saved lane")
  }

  var savedItemRailTitle: String {
    tvLocalized("Current saved item")
  }

  var savedItemMetaTitle: String {
    tvLocalized("Resume signals")
  }

  var selectedPrimaryItem: TVLearnHubItem? {
    primaryItems.first(where: { $0.id == selectedPrimaryItemId }) ?? primaryItems.first
  }

  var selectedSavedItem: TVSavedItemCard? {
    savedItems.first(where: { $0.id == selectedSavedItemId }) ?? savedItems.first
  }

  func selectPrimaryItem(_ item: TVLearnHubItem) {
    selectedPrimaryItemId = item.id
  }

  func selectSavedItem(_ item: TVSavedItemCard) {
    selectedSavedItemId = item.id
  }
}

final class TVGamesViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.gamesHero()
  @Published private(set) var primaryItems: [TVLearnHubItem] =
      TVSeedRepository.gamesPrimaryItems()
  @Published private(set) var challengeCards: [TVGamesChallengeCard] =
      TVSeedRepository.gamesChallengeCards()
  @Published private(set) var selectedPrimaryItemId: String
  @Published private(set) var selectedChallengeId: String
  @Published private(set) var selectedOptionIdByChallenge: [String: String] = [:]

  init() {
    selectedPrimaryItemId = TVSeedRepository.gamesPrimaryItems().first?.id ?? ""
    selectedChallengeId = TVSeedRepository.gamesChallengeCards().first?.id ?? ""
  }

  var primaryTitle: String {
    tvLocalized("Choose a game path")
  }

  var primarySubtitle: String {
    tvLocalized("Start with one calm challenge lane for the room: trivia, matching, family rounds, or guided review.")
  }

  var challengeTitle: String {
    tvLocalized("Featured remote-friendly challenges")
  }

  var challengeSubtitle: String {
    tvLocalized("Use simple directional movement and one clear answer choice at a time instead of typing-heavy game patterns.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected game path")
  }

  var challengeRailTitle: String {
    tvLocalized("Current challenge")
  }

  var challengeAnswerTitle: String {
    tvLocalized("Choose one answer")
  }

  var challengeFeedbackTitle: String {
    tvLocalized("Challenge feedback")
  }

  var selectedPrimaryItem: TVLearnHubItem? {
    primaryItems.first(where: { $0.id == selectedPrimaryItemId }) ?? primaryItems.first
  }

  var selectedChallenge: TVGamesChallengeCard? {
    challengeCards.first(where: { $0.id == selectedChallengeId }) ?? challengeCards.first
  }

  var selectedOption: TVGamesChallengeOption? {
    guard
      let selectedChallenge,
      let selectedOptionId = selectedOptionIdByChallenge[selectedChallenge.id]
    else {
      return nil
    }
    return selectedChallenge.options.first(where: { $0.id == selectedOptionId })
  }

  func selectPrimaryItem(_ item: TVLearnHubItem) {
    selectedPrimaryItemId = item.id
  }

  func selectChallenge(_ challenge: TVGamesChallengeCard) {
    selectedChallengeId = challenge.id
  }

  func selectOption(_ option: TVGamesChallengeOption) {
    guard let selectedChallenge else { return }
    selectedOptionIdByChallenge[selectedChallenge.id] = option.id
  }
}

final class TVArabicViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.arabicHero()
  @Published private(set) var primaryItems: [TVLearnHubItem] =
      TVSeedRepository.arabicPrimaryItems()
  @Published private(set) var letterGroups: [TVArabicLetterGroup] =
      TVSeedRepository.arabicLetterGroups()
  @Published private(set) var selectedItemId: String
  @Published private(set) var selectedLetterGroupId: String

  init() {
    selectedItemId = TVSeedRepository.arabicPrimaryItems().first?.id ?? ""
    selectedLetterGroupId = TVSeedRepository.arabicLetterGroups().first?.id ?? ""
  }

  var primaryTitle: String {
    tvLocalized("Choose an Arabic path")
  }

  var primarySubtitle: String {
    tvLocalized("Start with one calm lane for TV: letter families, listening, first words, or a gentle Qur'an-readiness handoff.")
  }

  var letterGroupsTitle: String {
    tvLocalized("Letter groups")
  }

  var letterGroupsSubtitle: String {
    tvLocalized("Learn small families of letters with large forms, simple sound cues, and distance-friendly examples.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected Arabic path")
  }

  var selectedItem: TVLearnHubItem? {
    primaryItems.first(where: { $0.id == selectedItemId }) ?? primaryItems.first
  }

  var selectedLetterGroup: TVArabicLetterGroup? {
    letterGroups.first(where: { $0.id == selectedLetterGroupId }) ?? letterGroups.first
  }

  func selectItem(_ item: TVLearnHubItem) {
    selectedItemId = item.id
  }

  func selectLetterGroup(_ group: TVArabicLetterGroup) {
    selectedLetterGroupId = group.id
  }
}

final class TVPrayerViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent
  @Published private(set) var summaryLine: String = ""
  @Published private(set) var detailLine: String = ""
  @Published private(set) var prayerTimes: [TVPrayerTime] = []

  var currentNextTitle: String {
    tvLocalized("Now and next")
  }

  var scheduleTitle: String {
    tvLocalized("Today")
  }

  private let prayerService: TVPrayerService
  private var timer: Timer?
  private var changes: AnyCancellable?

  init(prayerService: TVPrayerService) {
    self.prayerService = prayerService
    hero = TVSeedRepository.prayerHero(
      today: prayerService.todayLabel(at: TVClock.now()), place: "", method: ""
    )
    refresh()
    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
    // A new place or authority is a new day of times: show it at once.
    changes = prayerService.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in self?.refresh() }
  }

  deinit {
    timer?.invalidate()
  }

  func refresh() {
    let now = TVClock.now()
    let snapshot = prayerService.snapshot(at: now)
    hero = TVSeedRepository.prayerHero(
      today: prayerService.todayLabel(at: now),
      place: snapshot.placeLine,
      method: snapshot.methodLine
    )
    summaryLine = snapshot.summaryLine
    detailLine = snapshot.detailLine
    prayerTimes = snapshot.prayerTimes
  }
}

final class TVDhikrViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.dhikrHero()
  @Published private(set) var routines: [TVDhikrRoutine] = TVDhikrRoutineData.routines
  /// The phrases of the phone's counter, each a routine of one step.
  @Published private(set) var phrases: [TVDhikrRoutine] = TVDhikrRoutineData.phrases
  /// How many times each phrase is counted: 33, 99, 100 or 500, as on the
  /// phone's counter.
  @Published private(set) var phraseTarget: Int = 33
  static let phraseTargets = [33, 99, 100, 500]
  static let phraseTargetKey = "PathOfNurTV.dhikr.phraseTarget"
  @Published var isRoutinePlayerPresented = false
  @Published private(set) var activeRoutine: TVDhikrRoutine?
  @Published private(set) var routineStepIndex = 0
  @Published private(set) var routineStepCount = 0
  @Published private(set) var isRoutinePacing = false
  @Published private(set) var routineCompletedAt: Date?
  /// The day it is, which turns while the app is open.
  @Published private(set) var today: String
  /// The routines completed on `completedDay`, and the one left part way
  /// through on `progress.day`. Both are of a day, and are nothing on the
  /// day after.
  @Published private(set) var completedRoutineIds: Set<String> = []
  @Published private(set) var progress: RoutineProgress?
  private var completedDay = ""
  private var routineStartedAt: Date?
  private var routinePaceTimer: Timer?
  private var dayTimer: Timer?
  private let userDefaults: UserDefaults
  static let completedRoutinesKey = "PathOfNurTV.dhikr.routinesCompleted"
  static let routineInProgressKey = "PathOfNurTV.dhikr.routineInProgress"

  /// Where a routine was left: the step, and the count within it.
  struct RoutineProgress: Equatable {
    let day: String
    let routineId: String
    let stepIndex: Int
    let stepCount: Int
  }

  var routinesTitle: String { tvLocalized("Routines") }

  var routinesSubtitle: String {
    tvLocalized("The same routines as your phone.")
  }

  var routineStep: TVDhikrRoutineStep? {
    guard let routine = activeRoutine, routine.steps.indices.contains(routineStepIndex) else {
      return nil
    }
    return routine.steps[routineStepIndex]
  }

  var routineNextStep: TVDhikrRoutineStep? {
    guard let routine = activeRoutine else { return nil }
    let next = routineStepIndex + 1
    return routine.steps.indices.contains(next) ? routine.steps[next] : nil
  }

  var isRoutineComplete: Bool { routineCompletedAt != nil }

  var routineElapsedLabel: String {
    guard let startedAt = routineStartedAt else { return "0:00" }
    let end = routineCompletedAt ?? Date()
    let seconds = max(Int(end.timeIntervalSince(startedAt).rounded()), 0)
    return String(format: "%d:%02d", seconds / 60, seconds % 60)
  }

  func isRoutineDoneToday(_ routine: TVDhikrRoutine) -> Bool {
    completedDay == today && completedRoutineIds.contains(routine.id)
  }

  /// How many remembrances of the routine have been said today, if it was
  /// left part way through.
  func remembrancesSaidToday(of routine: TVDhikrRoutine) -> Int? {
    guard
      let progress, progress.day == today, progress.routineId == routine.id,
      routine.steps.indices.contains(progress.stepIndex)
    else {
      return nil
    }
    let said = routine.steps[..<progress.stepIndex].reduce(0) { $0 + $1.count } + progress.stepCount
    return said > 0 ? said : nil
  }

  /// Opens a routine where it was left today, as the phone does, and at
  /// its beginning otherwise.
  func openRoutine(_ routine: TVDhikrRoutine) {
    stopRoutinePacing()
    refreshDay()
    activeRoutine = routine
    if remembrancesSaidToday(of: routine) != nil, let progress {
      routineStepIndex = progress.stepIndex
      routineStepCount = progress.stepCount
    } else {
      routineStepIndex = 0
      routineStepCount = 0
    }
    routineCompletedAt = nil
    routineStartedAt = Date()
    isRoutinePlayerPresented = true
  }

  func closeRoutinePlayer() {
    stopRoutinePacing()
    isRoutinePlayerPresented = false
    activeRoutine = nil
    routineCompletedAt = nil
  }

  /// The day may have turned since the app was opened.
  func refreshDay(now: Date = TVClock.now()) {
    let day = Self.dayKey(for: now)
    if day != today {
      today = day
    }
  }

  /// One remembrance: counts the current step, moves on when it is full.
  func countRoutine() {
    guard let routine = activeRoutine, let step = routineStep, !isRoutineComplete else { return }
    let next = routineStepCount + 1
    if next < step.count {
      routineStepCount = next
      keepProgress(of: routine)
      return
    }
    let isLast = routineStepIndex >= routine.steps.count - 1
    if isLast {
      routineStepCount = step.count
      completeRoutine(routine)
    } else {
      routineStepIndex += 1
      routineStepCount = 0
      keepProgress(of: routine)
    }
  }

  func skipRoutineStep() {
    guard let routine = activeRoutine, !isRoutineComplete else { return }
    let isLast = routineStepIndex >= routine.steps.count - 1
    if isLast {
      completeRoutine(routine)
    } else {
      routineStepIndex += 1
      routineStepCount = 0
      keepProgress(of: routine)
    }
  }

  func undoRoutine() {
    guard let routine = activeRoutine, !isRoutineComplete else { return }
    if routineStepCount > 0 {
      routineStepCount -= 1
    } else if routineStepIndex > 0 {
      routineStepIndex -= 1
      routineStepCount = max(routine.steps[routineStepIndex].count - 1, 0)
    }
    keepProgress(of: routine)
  }

  /// From the beginning, whatever was said before.
  func restartRoutine() {
    guard let routine = activeRoutine else { return }
    forgetProgress(of: routine)
    openRoutine(routine)
  }

  /// Lets the room follow along without a remote in hand: one count every
  /// few seconds, slower on the long duʿās.
  func toggleRoutinePacing() {
    if isRoutinePacing {
      stopRoutinePacing()
    } else {
      startRoutinePacing()
    }
  }

  private func startRoutinePacing() {
    guard !isRoutineComplete else { return }
    isRoutinePacing = true
    scheduleNextRoutineTick()
  }

  private func scheduleNextRoutineTick() {
    routinePaceTimer?.invalidate()
    guard isRoutinePacing, let step = routineStep else { return }
    let interval: TimeInterval = step.isLongText ? 18 : 3
    routinePaceTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
      guard let self, self.isRoutinePacing else { return }
      self.countRoutine()
      if self.isRoutineComplete {
        self.stopRoutinePacing()
      } else {
        self.scheduleNextRoutineTick()
      }
    }
  }

  private func stopRoutinePacing() {
    routinePaceTimer?.invalidate()
    routinePaceTimer = nil
    isRoutinePacing = false
  }

  private func completeRoutine(_ routine: TVDhikrRoutine) {
    routineCompletedAt = Date()
    stopRoutinePacing()
    refreshDay()
    // Yesterday's are not today's.
    if completedDay != today {
      completedRoutineIds = []
      completedDay = today
    }
    completedRoutineIds.insert(routine.id)
    userDefaults.set(
      ["date": completedDay, "ids": Array(completedRoutineIds).sorted()],
      forKey: Self.completedRoutinesKey
    )
    forgetProgress(of: routine)
  }

  private func keepProgress(of routine: TVDhikrRoutine) {
    refreshDay()
    let kept = RoutineProgress(
      day: today,
      routineId: routine.id,
      stepIndex: routineStepIndex,
      stepCount: routineStepCount
    )
    progress = kept
    userDefaults.set(
      [
        "date": kept.day,
        "routine": kept.routineId,
        "step": kept.stepIndex,
        "count": kept.stepCount,
      ],
      forKey: Self.routineInProgressKey
    )
  }

  private func forgetProgress(of routine: TVDhikrRoutine) {
    guard progress?.routineId == routine.id else { return }
    progress = nil
    userDefaults.removeObject(forKey: Self.routineInProgressKey)
  }

  private static func dayKey(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    today = Self.dayKey(for: TVClock.now())
    let target = userDefaults.integer(forKey: Self.phraseTargetKey)
    if Self.phraseTargets.contains(target) {
      phraseTarget = target
      phrases = Self.phrases(countedTo: target)
    }

    let completed = userDefaults.dictionary(forKey: Self.completedRoutinesKey)
    completedDay = completed?["date"] as? String ?? ""
    completedRoutineIds = Set(completed?["ids"] as? [String] ?? [])

    let left = userDefaults.dictionary(forKey: Self.routineInProgressKey)
    if
      let day = left?["date"] as? String,
      let routineId = left?["routine"] as? String,
      let stepIndex = left?["step"] as? Int,
      let stepCount = left?["count"] as? Int
    {
      progress = RoutineProgress(
        day: day, routineId: routineId, stepIndex: stepIndex, stepCount: stepCount
      )
    }

    // "Done today" is of the day: it is looked at again as the day goes.
    dayTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refreshDay()
    }
  }

  deinit {
    dayTimer?.invalidate()
    routinePaceTimer?.invalidate()
  }

  var phrasesTitle: String {
    tvLocalized("Phrases")
  }

  func selectPhraseTarget(_ target: Int) {
    guard Self.phraseTargets.contains(target), target != phraseTarget else { return }
    phraseTarget = target
    phrases = Self.phrases(countedTo: target)
    userDefaults.set(target, forKey: Self.phraseTargetKey)
  }

  /// The phone's phrases, each counted to `target`.
  static func phrases(countedTo target: Int) -> [TVDhikrRoutine] {
    TVDhikrRoutineData.phrases.map { phrase in
      TVDhikrRoutine(
        id: phrase.id,
        kind: phrase.kind,
        title: phrase.title,
        subtitle: phrase.subtitle,
        sourceRef: phrase.sourceRef,
        steps: phrase.steps.map { step in
          TVDhikrRoutineStep(
            id: step.id,
            title: step.title,
            arabic: step.arabic,
            transliteration: step.transliteration,
            translation: step.translation,
            count: target,
            sourceRef: step.sourceRef
          )
        }
      )
    }
  }

  var phrasesSubtitle: String {
    tvLocalized("The same phrases as your phone.")
  }
}

final class TVKidsViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.kidsHero()
  @Published private(set) var primaryItems: [TVLearnHubItem] =
      TVSeedRepository.kidsPrimaryItems()
  @Published private(set) var featuredStories: [TVLearnStoryEntry] =
      TVSeedRepository.kidsFeaturedStories()
  @Published private(set) var selectedItemId: String
  @Published private(set) var selectedStoryId: String

  init() {
    selectedItemId = TVSeedRepository.kidsPrimaryItems().first?.id ?? ""
    selectedStoryId = TVSeedRepository.kidsFeaturedStories().first?.id ?? ""
  }

  var primaryTitle: String {
    tvLocalized("Choose a kids path")
  }

  var primarySubtitle: String {
    tvLocalized("Start with one family-safe lane for the room: stories, Qur'an, Arabic letters, or a calm bedtime return.")
  }

  var featuredStoriesTitle: String {
    tvLocalized("Featured kids stories")
  }

  var featuredStoriesSubtitle: String {
    tvLocalized("Use short, safe, discussion-friendly stories that work for mixed ages and simple remote movement.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected kids path")
  }

  var selectedItem: TVLearnHubItem? {
    primaryItems.first(where: { $0.id == selectedItemId }) ?? primaryItems.first
  }

  var selectedStory: TVLearnStoryEntry? {
    featuredStories.first(where: { $0.id == selectedStoryId }) ?? featuredStories.first
  }

  func selectItem(_ item: TVLearnHubItem) {
    selectedItemId = item.id
  }

  func selectStory(_ story: TVLearnStoryEntry) {
    selectedStoryId = story.id
  }
}

final class TVHomeViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent
  @Published private(set) var prayerSummaryLine: String = ""
  @Published private(set) var prayerSummaryDetail: String = ""
  @Published private(set) var prayerTimes: [TVPrayerTime] = []

  /// Called with the time whenever Home looks at the clock, once a minute.
  var onRefresh: ((Date) -> Void)?

  var continueJourneySummaryTitle: String {
    tvLocalized("Continue")
  }

  private let prayerService: TVPrayerService
  private var timer: Timer?
  private var changes: AnyCancellable?

  init(prayerService: TVPrayerService) {
    self.prayerService = prayerService
    hero = TVSeedRepository.homeHero(today: prayerService.todayLabel(at: TVClock.now()))
    refresh()
    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
    changes = prayerService.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in self?.refresh() }
  }

  deinit {
    timer?.invalidate()
  }

  func refresh() {
    let now = TVClock.now()
    let snapshot = prayerService.snapshot(at: now)
    hero = TVSeedRepository.homeHero(today: prayerService.todayLabel(at: now))
    prayerSummaryLine = snapshot.summaryLine
    prayerSummaryDetail = snapshot.detailLine
    prayerTimes = snapshot.prayerTimes
    onRefresh?(now)
  }
}

final class TVLearnViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.learnHero()
  @Published private(set) var primaryItems: [TVLearnHubItem] =
      TVSeedRepository.learnPrimaryItems()
  @Published private(set) var sections: [TVLearnHubSection] =
      TVSeedRepository.learnSections()
  @Published private(set) var selectedItemId: String
  @Published private(set) var selectedStoryEntryId: String
  @Published private(set) var selectedVisualEntryId: String

  init() {
    let initialItemId = TVSeedRepository.learnPrimaryItems().first?.id ?? ""
    selectedItemId = initialItemId
    selectedStoryEntryId = TVSeedRepository.learnStoryCollection(for: initialItemId).entries.first?.id ?? ""
    selectedVisualEntryId = TVSeedRepository.learnVisualCollection(for: initialItemId).entries.first?.id ?? ""
  }

  var primarySectionTitle: String {
    tvLocalized("Start with a path")
  }

  var primarySectionSubtitle: String {
    tvLocalized("Use one clear entry point first, then browse the wider Learn shelves without leaving the route.")
  }

  var detailPanelTitle: String {
    tvLocalized("Selected learning path")
  }

  var storiesSectionTitle: String {
    activeStoryCollection.title
  }

  var storiesSectionSubtitle: String {
    activeStoryCollection.subtitle
  }

  var storiesSectionSupportingLine: String {
    activeStoryCollection.supportingLine
  }

  var storyDetailTitle: String {
    tvLocalized("Selected story")
  }

  var storyReflectionTitle: String {
    tvLocalized("Reflect together")
  }

  var visualsSectionTitle: String {
    activeVisualCollection.title
  }

  var visualsSectionSubtitle: String {
    activeVisualCollection.subtitle
  }

  var visualsSectionSupportingLine: String {
    activeVisualCollection.supportingLine
  }

  var visualDetailTitle: String {
    tvLocalized("Selected visual path")
  }

  var visualReflectionTitle: String {
    tvLocalized("Observe together")
  }

  var selectedItem: TVLearnHubItem? {
    allItems.first(where: { $0.id == selectedItemId }) ?? allItems.first
  }

  var activeStoryCollection: TVLearnStoryCollection {
    TVSeedRepository.learnStoryCollection(for: selectedItemId)
  }

  var selectedStoryEntry: TVLearnStoryEntry? {
    activeStoryCollection.entries.first(where: { $0.id == selectedStoryEntryId }) ??
        activeStoryCollection.entries.first
  }

  var activeVisualCollection: TVLearnVisualCollection {
    TVSeedRepository.learnVisualCollection(for: selectedItemId)
  }

  var selectedVisualEntry: TVLearnVisualEntry? {
    activeVisualCollection.entries.first(where: { $0.id == selectedVisualEntryId }) ??
        activeVisualCollection.entries.first
  }

  func selectItem(_ item: TVLearnHubItem) {
    selectedItemId = item.id
    selectedStoryEntryId = TVSeedRepository.learnStoryCollection(for: item.id).entries.first?.id ?? ""
    selectedVisualEntryId = TVSeedRepository.learnVisualCollection(for: item.id).entries.first?.id ?? ""
  }

  func selectStoryEntry(_ entry: TVLearnStoryEntry) {
    selectedStoryEntryId = entry.id
  }

  func selectVisualEntry(_ entry: TVLearnVisualEntry) {
    selectedVisualEntryId = entry.id
  }

  private var allItems: [TVLearnHubItem] {
    primaryItems + sections.flatMap(\.items)
  }
}

final class TVQuranViewModel: ObservableObject {
  static let placeStorageKey = "PathOfNurTV.quran.place"

  @Published private(set) var surahs: [TVQuranSurah] = TVSeedRepository.quranSurahs
  /// The verse the phone shows today.
  @Published private(set) var dailyVerse: TVQuranDailyVerse
  /// Where the viewer last was, reading or listening, kept between
  /// launches. There is none until something has been read.
  @Published private(set) var place: TVQuranPlace?
  @Published private(set) var browseCollections: [TVQuranBrowseCollection] =
      TVSeedRepository.quranBrowseCollections()
  @Published private(set) var selectedAyahs: [TVQuranAyah]
  @Published var selectedSurah: TVQuranSurah
  @Published var selectedAyahIndex: Int = 0
  @Published private(set) var selectedReciter: TVQuranReciter = .phoneDefault
  /// The meaning shown under the Arabic, everywhere the Qur'an is read.
  /// None is the Arabic and its reading alone.
  @Published private(set) var translation: TVQuranTranslation?
  @Published var isListeningModePresented = false
  @Published var isPlayerOptionsPresented = false
  @Published private(set) var showListeningTranslation = true
  @Published private(set) var showListeningTransliteration = true
  @Published private(set) var repeatMode: TVQuranRepeat = .off
  /// At the end of a surah the recitation goes on into the next.
  @Published private(set) var continuesIntoNextSurah: Bool
  @Published private(set) var speed: TVQuranSpeed
  @Published private(set) var sleepTimer: TVQuranSleepTimer = .off
  /// When a timed sleep timer stops the recitation.
  @Published private(set) var sleepTimerEnds: Date?
  /// Ayahs the viewer marked to come back to, the newest first.
  @Published private(set) var bookmarks: [TVQuranPlace]
  @Published private(set) var isPlaying = false
  /// Playing, and waiting for the recitation to arrive.
  @Published private(set) var isBuffering = false
  @Published private(set) var playbackErrorMessage: String?

  var onDiagnosticsEvent: ((String, [String: String]) -> Void)?
  var onDiagnosticsError: ((String, String, [String: String]) -> Void)?
  var onReciterChosen: ((TVQuranReciter) -> Void)?
  var onPlaceKept: ((TVQuranPlace) -> Void)?
  var onTranslationChosen: ((TVQuranTranslation?) -> Void)?
  /// The viewer showed or hid the translation or the reading while
  /// listening; what they chose is kept for the next time.
  var onListeningTextChosen: ((_ translation: Bool, _ transliteration: Bool) -> Void)?

  private let userDefaults: UserDefaults
  private var verseOfTheDayIndex: Int
  /// Plays the ayah being recited and holds the one after it ready, so that
  /// one follows the other without a pause while it is fetched.
  private let player = AVQueuePlayer()
  /// The ayah being recited: its item, and which ayah it is.
  private var current: (item: AVPlayerItem, ayahID: String)?
  /// The ayah waiting behind it in the queue.
  private var queued: (item: AVPlayerItem, surahNumber: Int, index: Int)?
  /// How many times the ayah being recited has been heard through.
  private var playsHeard = 0
  private var endObserver: NSObjectProtocol?
  private var failureObserver: NSObjectProtocol?
  private var itemStatusObservation: NSKeyValueObservation?
  private var timeControlObservation: NSKeyValueObservation?
  private var isAudioSessionActive = false
  private var sleepTimerTask: Timer?

  static let continuesStorageKey = "PathOfNurTV.quran.continuesIntoNextSurah"
  static let speedStorageKey = "PathOfNurTV.quran.speed"
  static let bookmarksStorageKey = "PathOfNurTV.quran.bookmarks"

  init(userDefaults: UserDefaults = .standard, now: Date = TVClock.now()) {
    self.userDefaults = userDefaults
    let translation = TVQuranTranslationChoice.load(from: userDefaults)
    self.translation = translation
    continuesIntoNextSurah = userDefaults.bool(forKey: Self.continuesStorageKey)
    speed = TVQuranSpeed(rawValue: userDefaults.double(forKey: Self.speedStorageKey)) ?? .normal
    bookmarks = (userDefaults.stringArray(forKey: Self.bookmarksStorageKey) ?? [])
      .compactMap { TVQuranPlace(key: $0) }
    // The reader opens where the viewer left it, and at the beginning the
    // first time.
    let kept = TVQuranPlace(key: userDefaults.string(forKey: Self.placeStorageKey))
    let surah = TVSeedRepository.surah(kept?.surahNumber ?? 1) ?? TVSeedRepository.quranSurahs.first!
    place = kept
    selectedSurah = surah
    selectedAyahs = TVSeedRepository.ayahs(for: surah.number, translation: translation)
    selectedAyahIndex = (kept?.ayahNumber ?? 1) - 1
    verseOfTheDayIndex = TVQuranVerseOfTheDay.dayIndex(for: now)
    dailyVerse = TVSeedRepository.dailyVerse(on: now, translation: translation)
    player.automaticallyWaitsToMinimizeStalling = true
    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      guard let self, let item = notification.object as? AVPlayerItem,
            item === self.current?.item else { return }
      self.ayahHeardThrough()
    }
    failureObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemFailedToPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      guard let self, let item = notification.object as? AVPlayerItem,
            item === self.current?.item || item === self.queued?.item else { return }
      self.reportPlaybackFailure()
    }
    timeControlObservation = player.observe(\.timeControlStatus) { [weak self] player, _ in
      let waiting = player.timeControlStatus == .waitingToPlayAtSpecifiedRate
      DispatchQueue.main.async {
        guard let self else { return }
        let buffering = waiting && self.isPlaying
        if self.isBuffering != buffering {
          self.isBuffering = buffering
        }
      }
    }
  }

  deinit {
    if let endObserver {
      NotificationCenter.default.removeObserver(endObserver)
    }
    if let failureObserver {
      NotificationCenter.default.removeObserver(failureObserver)
    }
    itemStatusObservation?.invalidate()
    timeControlObservation?.invalidate()
  }

  var selectedAyah: TVQuranAyah? {
    guard selectedAyahIndex >= 0 && selectedAyahIndex < selectedAyahs.count else {
      return nil
    }
    return selectedAyahs[selectedAyahIndex]
  }

  /// The place to go on from: where the viewer was, or the beginning.
  var continueReading: TVContinueReadingSummary {
    let place = self.place ?? TVQuranPlace(surahNumber: 1, ayahNumber: 1)
    return TVContinueReadingSummary(
      surahNumber: place.surahNumber,
      surahName: TVSeedRepository.surahName(place.surahNumber),
      ayahNumber: place.ayahNumber
    )
  }

  var continueReadingPlace: TVQuranPlace {
    TVQuranPlace(
      surahNumber: continueReading.surahNumber,
      ayahNumber: continueReading.ayahNumber
    )
  }

  var continueReadingLine: String {
    guard place != nil else {
      return continueReading.surahName
    }
    return String(
      format: tvLocalized("%@ %d:%d"),
      continueReading.surahName,
      continueReading.surahNumber,
      continueReading.ayahNumber
    )
  }

  var continueReadingSummaryTitle: String {
    place == nil ? tvLocalized("Start reading") : tvLocalized("Continue reading")
  }

  /// The viewer is at this ayah, reading it or hearing it recited. Any part
  /// of the ayah is the ayah: "2:282.p3" is 2:282.
  func keepPlace(ayahID: String) {
    let ayah = ayahID.split(separator: ".").first.map(String.init)
    guard let kept = TVQuranPlace(key: ayah), kept != place else { return }
    place = kept
    userDefaults.set(kept.key, forKey: Self.placeStorageKey)
    onPlaceKept?(kept)
  }

  /// Takes up what the phone changed. The place becomes where Continue
  /// reading goes, without moving a reader that is open.
  func applyShared(
    place: TVQuranPlace?,
    bookmarks: [TVQuranPlace]?,
    translation: TVQuranTranslation??
  ) {
    if let place, place != self.place {
      self.place = place
      userDefaults.set(place.key, forKey: Self.placeStorageKey)
    }
    if let bookmarks {
      replaceBookmarks(bookmarks)
    }
    if let translation {
      selectTranslation(translation)
    }
  }

  /// The verse of the day turns with the day.
  func refreshVerseOfTheDay(now: Date = TVClock.now()) {
    let index = TVQuranVerseOfTheDay.dayIndex(for: now)
    guard index != verseOfTheDayIndex else { return }
    verseOfTheDayIndex = index
    dailyVerse = TVSeedRepository.dailyVerse(on: now, translation: translation)
  }

  var dailyVerseSummaryTitle: String {
    tvLocalized("Today’s verse")
  }

  var readerSubtitle: String {
    let surah = selectedSurah
    return "\(surah.transliteratedName) · \(surah.englishName) · \(surah.revelationPlace)"
  }

  /// "Al-Fatihah 1:5" for the ayah in hand, or the surah line when there is none.
  var selectedAyahLine: String {
    guard let ayah = selectedAyah else {
      return readerSubtitle
    }
    return String(
      format: tvLocalized("%@ %d:%d"),
      selectedSurah.transliteratedName,
      selectedSurah.number,
      ayah.ayahNumber
    )
  }

  var listeningModeHeaderLine: String {
    selectedAyahLine
  }

  /// "Ayah 3 of 7"
  var ayahProgressLine: String {
    tvLocalized("Ayah %d of %d", selectedAyahIndex + 1, selectedAyahs.count)
  }

  /// "Playing · Mishary Rashid Alafasy", with the repeat when there is one.
  var listeningModeStatusLine: String {
    var line: [String] = []
    if isBuffering {
      line.append(tvLocalized("Loading"))
    } else {
      line.append(isPlaying ? tvLocalized("Playing") : tvLocalized("Paused"))
    }
    if repeatMode != .off {
      line.append(repeatMode.shortTitle)
    }
    if speed != .normal {
      line.append(String(format: "%g×", speed.rawValue))
    }
    if let sleep = sleepTimerLine() {
      line.append(sleep)
    }
    line.append(selectedReciter.displayName)
    return line.joined(separator: " · ")
  }

  /// The translation's name, or that there is none.
  var translationTitle: String {
    translation?.title ?? tvLocalized("No translation")
  }

  func collectionContainsSelectedSurah(_ collection: TVQuranBrowseCollection) -> Bool {
    collection.surahNumbers.contains(selectedSurah.number)
  }

  func selectBrowseCollection(_ collection: TVQuranBrowseCollection) {
    guard let firstSurah = TVSeedRepository.surahs(for: collection.surahNumbers).first else {
      return
    }
    selectSurah(firstSurah)
  }

  func selectSurah(_ surah: TVQuranSurah) {
    selectedSurah = surah
    selectedAyahs = TVSeedRepository.ayahs(for: surah.number, translation: translation)
    selectedAyahIndex = 0
    stopPlayback()
  }

  /// Opens a surah at one of its ayahs. A surah already open keeps its place
  /// in memory and is not read again.
  func select(surahNumber: Int, ayahNumber: Int = 1) {
    guard let surah = TVSeedRepository.surah(surahNumber) else { return }
    if surah.id != selectedSurah.id {
      selectSurah(surah)
    }
    selectAyah(at: ayahNumber - 1)
  }

  func selectAyah(at index: Int) {
    guard index >= 0 && index < selectedAyahs.count else { return }
    selectedAyahIndex = index
    stopPlayback()
  }

  /// What pressing an ayah does: it is recited from there on, and pressing
  /// the ayah being recited pauses it.
  func playOrPauseAyah(at index: Int) {
    guard index >= 0 && index < selectedAyahs.count else { return }
    if index == selectedAyahIndex && isPlaying {
      pausePlayback()
      return
    }
    if index == selectedAyahIndex, canResume {
      resumePlayback()
      return
    }
    selectedAyahIndex = index
    playSelectedAyah()
  }

  func selectReciter(_ reciter: TVQuranReciter) {
    guard reciter != selectedReciter else { return }
    selectedReciter = reciter
    onReciterChosen?(reciter)
    onDiagnosticsEvent?(
      "tvos_quran_reciter_selected",
      [
        "reciter": reciter.rawValue,
      ]
    )
    if isPlaying {
      playSelectedAyah()
    } else {
      // What was waiting to be resumed was in the other voice.
      clearQueue()
    }
  }

  /// Chooses the meaning shown under the Arabic, or none. It is kept on the
  /// device, and the ayahs on screen are read again in it; what is being
  /// recited carries on.
  func selectTranslation(_ translation: TVQuranTranslation?) {
    guard translation != self.translation else { return }
    self.translation = translation
    TVQuranTranslationChoice.save(translation, to: userDefaults)
    onTranslationChosen?(translation)
    selectedAyahs = TVSeedRepository.ayahs(for: selectedSurah.number, translation: translation)
    dailyVerse = TVSeedRepository.dailyVerse(on: TVClock.now(), translation: translation)
    onDiagnosticsEvent?(
      "tvos_quran_translation_selected",
      [
        "translation": translation?.id ?? TVQuranTranslationChoice.noneValue,
      ]
    )
    if translation != nil, !showListeningTranslation {
      // Choosing a translation is asking to see it.
      setShowListeningTranslation(true)
    }
  }

  func applyPreferenceDefaults(
    reciter: TVQuranReciter,
    showTranslation: Bool,
    showTransliteration: Bool
  ) {
    // Only a change of voice begins the ayah again. Showing or hiding a
    // line of text does not interrupt the recitation.
    let changesVoice = reciter != selectedReciter
    selectedReciter = reciter
    showListeningTranslation = showTranslation
    showListeningTransliteration = showTransliteration
    if isPlaying && changesVoice {
      playSelectedAyah()
    } else if changesVoice {
      clearQueue()
    }
  }

  func togglePlayback() {
    guard selectedAyah != nil else { return }
    if isPlaying {
      pausePlayback()
    } else if canResume {
      resumePlayback()
    } else {
      playSelectedAyah()
    }
  }

  func openListeningMode() {
    isListeningModePresented = true
    onDiagnosticsEvent?(
      "tvos_listening_mode_opened",
      [
        "surah": "\(selectedSurah.number)",
        "ayah": "\(selectedAyah?.ayahNumber ?? 0)",
      ]
    )
  }

  func closeListeningMode() {
    isListeningModePresented = false
    onDiagnosticsEvent?(
      "tvos_listening_mode_closed",
      [
        "surah": "\(selectedSurah.number)",
        "ayah": "\(selectedAyah?.ayahNumber ?? 0)",
      ]
    )
  }

  func selectRepeat(_ mode: TVQuranRepeat) {
    guard mode != repeatMode else { return }
    repeatMode = mode
    // The ayah in hand counts afresh, and what waits behind it may change.
    playsHeard = 0
    if isPlaying || canResume {
      prepareWhatFollows()
    }
  }

  func cycleRepeat() {
    selectRepeat(repeatMode.next)
  }

  func setShowListeningTranslation(_ value: Bool) {
    guard value != showListeningTranslation else { return }
    showListeningTranslation = value
    onListeningTextChosen?(showListeningTranslation, showListeningTransliteration)
  }

  func setShowListeningTransliteration(_ value: Bool) {
    guard value != showListeningTransliteration else { return }
    showListeningTransliteration = value
    onListeningTextChosen?(showListeningTranslation, showListeningTransliteration)
  }

  func toggleListeningTranslation() {
    setShowListeningTranslation(!showListeningTranslation)
  }

  func toggleListeningTransliteration() {
    setShowListeningTransliteration(!showListeningTransliteration)
  }

  /// The ayah before, which for the first ayah of a surah is the last of
  /// the surah before it.
  func playPreviousAyah() {
    step(by: -1, autoStart: isPlaying, crossesSurahs: true)
  }

  /// The ayah after, which for the last ayah of a surah is the first of
  /// the surah after it.
  func playNextAyah() {
    step(by: 1, autoStart: isPlaying, crossesSurahs: true)
  }

  /// Recites the ayah in hand from its beginning.
  func playSelectedAyah() {
    guard let ayah = selectedAyah else { return }
    guard let item = makeItem(surahNumber: ayah.surahNumber, ayahNumber: ayah.ayahNumber) else {
      reportPlaybackFailure()
      return
    }

    activateAudioSession()
    playbackErrorMessage = nil
    keepPlace(ayahID: ayah.id)
    player.pause()
    player.removeAllItems()
    queued = nil
    playsHeard = 0
    player.insert(item, after: nil)
    becomeCurrent(item, ayahID: ayah.id)
    prepareWhatFollows()
    startPlayer()
    isPlaying = true
    setScreenKeptAwake(true)
  }

  // MARK: - The recitation

  /// There is an ayah paused part of the way through, and it is the one in
  /// hand.
  private var canResume: Bool {
    guard let current, let ayah = selectedAyah else { return false }
    return current.ayahID == ayah.id && player.currentItem === current.item
  }

  private func resumePlayback() {
    activateAudioSession()
    playbackErrorMessage = nil
    startPlayer()
    isPlaying = true
    setScreenKeptAwake(true)
  }

  private func pausePlayback() {
    player.pause()
    isPlaying = false
    isBuffering = false
    setScreenKeptAwake(isListeningModePresented)
  }

  /// Plays at the speed chosen: `play()` alone would always be 1×.
  private func startPlayer() {
    player.rate = Float(speed.rawValue)
  }

  private func makeItem(surahNumber: Int, ayahNumber: Int) -> AVPlayerItem? {
    guard let url = TVSeedRepository.audioURL(
      reciter: selectedReciter,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber
    ) else {
      return nil
    }
    let item = AVPlayerItem(url: url)
    // A recitation is speech: the first seconds are enough to begin.
    item.preferredForwardBufferDuration = 4
    return item
  }

  private func becomeCurrent(_ item: AVPlayerItem, ayahID: String) {
    current = (item, ayahID)
    itemStatusObservation = item.observe(\.status) { [weak self] item, _ in
      guard item.status == .failed else { return }
      DispatchQueue.main.async {
        guard let self, item === self.current?.item else { return }
        self.reportPlaybackFailure()
      }
    }
  }

  /// Once the ayah in hand is heard for the last time, the queue moves on
  /// to what follows it; until then it waits at the end, to be heard again.
  private func prepareWhatFollows() {
    guard let ayah = selectedAyah else { return }
    let isLastHearing: Bool
    if let plays = repeatMode.playsPerAyah {
      isLastHearing = playsHeard + 1 >= plays
    } else {
      isLastHearing = false
    }

    guard isLastHearing, let next = nextPlace(after: ayah) else {
      player.actionAtItemEnd = .pause
      if let queued {
        player.remove(queued.item)
        self.queued = nil
      }
      return
    }
    player.actionAtItemEnd = .advance
    if let queued, queued.surahNumber == next.surahNumber, queued.index == next.index {
      return
    }
    if let queued {
      player.remove(queued.item)
      self.queued = nil
    }
    guard let item = makeItem(surahNumber: next.surahNumber, ayahNumber: next.index + 1) else {
      return
    }
    player.insert(item, after: current?.item)
    queued = (item, next.surahNumber, next.index)
  }

  /// Where the recitation goes when it is left to itself: the next ayah of
  /// the surah, and at its end the first again when the surah is repeated.
  /// It stops at the end of a surah otherwise, as the phone's does.
  private func nextPlace(after ayah: TVQuranAyah) -> (surahNumber: Int, index: Int)? {
    let index = ayah.ayahNumber
    if index < selectedAyahs.count {
      return (ayah.surahNumber, index)
    }
    if repeatMode.loopsSurah {
      return (ayah.surahNumber, 0)
    }
    if continuesIntoNextSurah, sleepTimer != .endOfSurah,
       TVSeedRepository.surah(ayah.surahNumber + 1) != nil {
      return (ayah.surahNumber + 1, 0)
    }
    return nil
  }

  /// The ayah in hand came to its end.
  private func ayahHeardThrough() {
    playsHeard += 1
    let plays = repeatMode.playsPerAyah
    if plays == nil || playsHeard < plays! {
      // Heard again: from its beginning, without fetching it again.
      player.seek(to: .zero) { [weak self] _ in
        guard let self, self.isPlaying else { return }
        self.startPlayer()
      }
      prepareWhatFollows()
      return
    }

    guard let queued else {
      // The end of the surah.
      stopPlayback()
      if sleepTimer == .endOfSurah {
        selectSleepTimer(.off)
      }
      return
    }
    // The queue has already moved on to it.
    self.queued = nil
    playsHeard = 0
    if queued.surahNumber != selectedSurah.number,
       let next = TVSeedRepository.surah(queued.surahNumber) {
      // Carried on into the next surah.
      selectedSurah = next
      selectedAyahs = TVSeedRepository.ayahs(for: next.number, translation: translation)
    }
    selectedAyahIndex = queued.index
    guard let ayah = selectedAyah else {
      stopPlayback()
      return
    }
    keepPlace(ayahID: ayah.id)
    becomeCurrent(queued.item, ayahID: ayah.id)
    prepareWhatFollows()
    if player.currentItem !== queued.item {
      // It was taken off the queue, or the queue stopped: begin it again.
      playSelectedAyah()
    } else if player.rate == 0 {
      startPlayer()
    }
  }

  /// The recitation is streamed, so it can fail on any ayah: say so where
  /// the viewer is looking, and stop showing the ayah as playing.
  private func reportPlaybackFailure() {
    stopPlayback()
    let message = tvLocalized("Couldn’t play this ayah. Check your connection and try again.")
    playbackErrorMessage = message
    onDiagnosticsError?(
      "tvos_playback_error",
      message,
      [
        "reciter": selectedReciter.rawValue,
        "surah": "\(selectedSurah.number)",
        "ayah": "\(selectedAyah?.ayahNumber ?? 0)",
      ]
    )
  }

  /// Moves an ayah on or back. At either end of a surah the viewer's own
  /// press crosses into its neighbour; the recitation, left to itself, stops
  /// there. At either end of the Qur'an there is nowhere further.
  private func step(by offset: Int, autoStart: Bool, crossesSurahs: Bool) {
    guard !selectedAyahs.isEmpty else { return }
    let index = selectedAyahIndex + offset
    if selectedAyahs.indices.contains(index) {
      selectedAyahIndex = index
    } else if crossesSurahs, let neighbour = TVSeedRepository.surah(selectedSurah.number + offset) {
      selectedSurah = neighbour
      selectedAyahs = TVSeedRepository.ayahs(for: neighbour.number, translation: translation)
      selectedAyahIndex = offset > 0 ? 0 : max(selectedAyahs.count - 1, 0)
    } else {
      stopPlayback()
      return
    }
    if autoStart {
      playSelectedAyah()
    } else {
      stopPlayback()
    }
  }

  private func stopPlayback() {
    player.pause()
    isPlaying = false
    isBuffering = false
    clearQueue()
    setScreenKeptAwake(isListeningModePresented)
  }

  // MARK: - Bookmarks

  func isBookmarked(_ ayah: TVQuranAyah) -> Bool {
    bookmarks.contains(TVQuranPlace(surahNumber: ayah.surahNumber, ayahNumber: ayah.ayahNumber))
  }

  /// Marks the ayah to come back to, or unmarks it.
  func toggleBookmark(_ ayah: TVQuranAyah) {
    let place = TVQuranPlace(surahNumber: ayah.surahNumber, ayahNumber: ayah.ayahNumber)
    if let index = bookmarks.firstIndex(of: place) {
      bookmarks.remove(at: index)
    } else {
      bookmarks.insert(place, at: 0)
    }
    saveBookmarks()
    onDiagnosticsEvent?("tvos_quran_bookmark_toggled", ["ayah": place.key])
  }

  /// Replaces the bookmarks, as another device kept them.
  func replaceBookmarks(_ places: [TVQuranPlace]) {
    guard places != bookmarks else { return }
    bookmarks = places
    saveBookmarks(notify: false)
  }

  var onBookmarksChanged: (([TVQuranPlace]) -> Void)?

  private func saveBookmarks(notify: Bool = true) {
    userDefaults.set(bookmarks.map(\.key), forKey: Self.bookmarksStorageKey)
    if notify {
      onBookmarksChanged?(bookmarks)
    }
  }

  /// "Al Baqarah 2:255"
  func line(for place: TVQuranPlace) -> String {
    String(
      format: tvLocalized("%@ %d:%d"),
      TVSeedRepository.surahName(place.surahNumber),
      place.surahNumber,
      place.ayahNumber
    )
  }

  // MARK: - Speed, the sleep timer, what follows a surah

  func selectSpeed(_ speed: TVQuranSpeed) {
    guard speed != self.speed else { return }
    self.speed = speed
    userDefaults.set(speed.rawValue, forKey: Self.speedStorageKey)
    if isPlaying {
      startPlayer()
    }
  }

  func setContinuesIntoNextSurah(_ value: Bool) {
    guard value != continuesIntoNextSurah else { return }
    continuesIntoNextSurah = value
    userDefaults.set(value, forKey: Self.continuesStorageKey)
    if isPlaying || canResume {
      prepareWhatFollows()
    }
  }

  func selectSleepTimer(_ timer: TVQuranSleepTimer) {
    sleepTimerTask?.invalidate()
    sleepTimerTask = nil
    sleepTimer = timer
    sleepTimerEnds = timer.duration.map { Date().addingTimeInterval($0) }
    if let duration = timer.duration {
      sleepTimerTask = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
        DispatchQueue.main.async {
          guard let self else { return }
          if self.isPlaying {
            self.pausePlayback()
          }
          self.sleepTimer = .off
          self.sleepTimerEnds = nil
        }
      }
    }
    if isPlaying || canResume {
      prepareWhatFollows()
    }
  }

  /// "Stops in 12 min", or at the end of the surah; nothing with no timer.
  func sleepTimerLine(now: Date = Date()) -> String? {
    switch sleepTimer {
    case .off:
      return nil
    case .endOfSurah:
      return tvLocalized("Stops at the end of the surah")
    default:
      guard let ends = sleepTimerEnds else { return nil }
      let minutes = max(Int((ends.timeIntervalSince(now) / 60).rounded(.up)), 1)
      return tvLocalized("Stops in %d min", minutes)
    }
  }


  private func clearQueue() {
    player.removeAllItems()
    current = nil
    queued = nil
    playsHeard = 0
    itemStatusObservation?.invalidate()
    itemStatusObservation = nil
  }

  /// The recitation is the point of playing, so it is heard with the
  /// television's sound whatever else is set, and speech is kept clear.
  private func activateAudioSession() {
    guard !isAudioSessionActive else { return }
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .spokenAudio)
      try session.setActive(true)
      isAudioSessionActive = true
    } catch {
      onDiagnosticsError?(
        "tvos_audio_session_error",
        error.localizedDescription,
        [:]
      )
    }
  }

  /// While the Qur'an is recited, or open full screen to be read, the
  /// television does not dim to its screen saver.
  func setScreenKeptAwake(_ awake: Bool) {
    #if canImport(UIKit)
    UIApplication.shared.isIdleTimerDisabled = awake || isPlaying
    #endif
  }
}
