import AVFoundation
import Combine
import Foundation

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
    if let routineId = ProcessInfo.processInfo.environment["TV_SAMPLE_ROUTINE"],
       let routine = dhikrViewModel.routines.first(where: { $0.id == routineId }) {
      dhikrViewModel.openRoutine(routine)
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
  @Published private(set) var supportCards: [TVHouseholdSupportCard] =
      TVSeedRepository.householdSupportCards()
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
    supportCards = TVSeedRepository.householdSupportCards()
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

  var supportTitle: String {
    tvLocalized("Shared-device guidance")
  }

  var supportSubtitle: String {
    tvLocalized("Profile switching on tvOS should stay simple, respectful, and safe for mixed-age family-room use.")
  }

  var detailRailTitle: String {
    tvLocalized("Active profile")
  }

  var detailRailNoteTitle: String {
    tvLocalized("tvOS household direction")
  }

  var detailRailNoteSubtitle: String {
    tvLocalized("Apple TV should handle fast switching and calm continuity, while account edits, backup controls, and deeper permissions stay on iPhone or iPad.")
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
  @Published private(set) var supportCards: [TVFavoritesSupportCard] =
      TVSeedRepository.favoritesSupportCards()
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

  var supportTitle: String {
    tvLocalized("Watch-later and playlist flow")
  }

  var supportSubtitle: String {
    tvLocalized("Television saves should favor low-friction resume behavior, while deeper editing and organizing stays on iPhone or iPad.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected saved lane")
  }

  var detailRailNoteTitle: String {
    tvLocalized("tvOS saved-items direction")
  }

  var detailRailNoteSubtitle: String {
    tvLocalized("Saved on TV should help the household return quickly to Qur'an, listening, and reflection without turning the route into a heavy library manager.")
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
  @Published private(set) var supportCards: [TVGamesSupportCard] =
      TVSeedRepository.gamesSupportCards()
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

  var supportTitle: String {
    tvLocalized("Family-room game guidance")
  }

  var supportSubtitle: String {
    tvLocalized("Keep games short, educational, and easy to leave so television play reinforces learning instead of stretching it thin.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected game path")
  }

  var detailRailNoteTitle: String {
    tvLocalized("tvOS games direction")
  }

  var detailRailNoteSubtitle: String {
    tvLocalized("Games on TV should reward recall, recognition, and discussion with the room, not speed tapping, typing, or noisy effects.")
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
  @Published private(set) var supportCards: [TVArabicSupportCard] =
      TVSeedRepository.arabicSupportCards()
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

  var supportTitle: String {
    tvLocalized("Arabic learning guidance")
  }

  var supportSubtitle: String {
    tvLocalized("Keep beginner Arabic on TV visual, repeatable, and easy to leave before fatigue replaces benefit.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected Arabic path")
  }

  var detailRailNoteTitle: String {
    tvLocalized("tvOS Arabic direction")
  }

  var detailRailNoteSubtitle: String {
    tvLocalized("Arabic on TV should help the room see, hear, and recognize with confidence before pushing speed, testing, or typing.")
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
  @Published private(set) var supportCards: [TVKidsSupportCard] =
      TVSeedRepository.kidsSupportCards()
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

  var supportTitle: String {
    tvLocalized("Family-safe guidance")
  }

  var supportSubtitle: String {
    tvLocalized("Keep the television calm, age-appropriate, and easy to leave without losing the benefit of the session.")
  }

  var detailRailTitle: String {
    tvLocalized("Selected kids path")
  }

  var detailRailNoteTitle: String {
    tvLocalized("tvOS kids direction")
  }

  var detailRailNoteSubtitle: String {
    tvLocalized("Kids mode on TV should stay visually clear, safe for shared use, and lighter than the full mobile kids ecosystem.")
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

  var layoutNoteTitle: String {
    tvLocalized("tvOS Learn direction")
  }

  var layoutNoteSubtitle: String {
    tvLocalized("This Learn hub is intentionally curated for television: large choices, simple focus movement, and no heavy typing or settings-first setup.")
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

  var storyDirectionTitle: String {
    tvLocalized("tvOS stories direction")
  }

  var storyDirectionSubtitle: String {
    tvLocalized("Stories and reflection should feel calm on TV: large choices, memorable lessons, and simple prompts that lead the room back into worship and character.")
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

  var visualDirectionTitle: String {
    tvLocalized("tvOS visual learning direction")
  }

  var visualDirectionSubtitle: String {
    tvLocalized("Visual Learn should use scale, atmosphere, and simple comparison to guide the room toward wonder, humility, and gratitude without turning TV into a dense study tool.")
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
  @Published var selectedReciter: TVQuranReciter = .phoneDefault
  @Published var isListeningModePresented = false
  @Published var showListeningTranslation = true
  @Published var showListeningTransliteration = true
  @Published var repeatCurrentAyah = false
  @Published private(set) var isPlaying = false
  @Published private(set) var playbackErrorMessage: String?

  var onDiagnosticsEvent: ((String, [String: String]) -> Void)?
  var onDiagnosticsError: ((String, String, [String: String]) -> Void)?
  var onReciterChosen: ((TVQuranReciter) -> Void)?

  private let userDefaults: UserDefaults
  private var verseOfTheDayIndex: Int
  private let player = AVPlayer()
  private var endObserver: NSObjectProtocol?
  private var failureObserver: NSObjectProtocol?
  private var itemStatusObservation: NSKeyValueObservation?

  init(userDefaults: UserDefaults = .standard, now: Date = TVClock.now()) {
    self.userDefaults = userDefaults
    // The reader opens where the viewer left it, and at the beginning the
    // first time.
    let kept = TVQuranPlace(key: userDefaults.string(forKey: Self.placeStorageKey))
    let surah = TVSeedRepository.surah(kept?.surahNumber ?? 1) ?? TVSeedRepository.quranSurahs.first!
    place = kept
    selectedSurah = surah
    selectedAyahs = TVSeedRepository.ayahs(for: surah.number)
    selectedAyahIndex = (kept?.ayahNumber ?? 1) - 1
    verseOfTheDayIndex = TVQuranVerseOfTheDay.dayIndex(for: now)
    dailyVerse = TVSeedRepository.dailyVerse(on: now)
    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      guard let self, self.isCurrentItem(notification.object) else { return }
      if self.repeatCurrentAyah {
        self.playSelectedAyah()
      } else {
        // The recitation stops at the end of a surah, as the phone's does.
        self.step(by: 1, autoStart: true, crossesSurahs: false)
      }
    }
    failureObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemFailedToPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      guard let self, self.isCurrentItem(notification.object) else { return }
      self.reportPlaybackFailure()
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
  }

  /// The verse of the day turns with the day.
  func refreshVerseOfTheDay(now: Date = TVClock.now()) {
    let index = TVQuranVerseOfTheDay.dayIndex(for: now)
    guard index != verseOfTheDayIndex else { return }
    verseOfTheDayIndex = index
    dailyVerse = TVSeedRepository.dailyVerse(on: now)
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

  /// "Playing · Repeating this ayah · Mahmoud Khalil Al-Husary"
  var listeningModeStatusLine: String {
    var line = [isPlaying ? tvLocalized("Playing") : tvLocalized("Paused")]
    if repeatCurrentAyah {
      line.append(tvLocalized("Repeating this ayah"))
    }
    line.append(selectedReciter.displayName)
    return line.joined(separator: " · ")
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
    selectedAyahs = TVSeedRepository.ayahs(for: surah.number)
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
      stopPlayback()
      return
    }
    selectedAyahIndex = index
    playSelectedAyah()
  }

  func selectReciter(_ reciter: TVQuranReciter) {
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
    }
  }

  func togglePlayback() {
    guard selectedAyah != nil else { return }
    if isPlaying {
      player.pause()
      isPlaying = false
      return
    }
    playSelectedAyah()
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

  func toggleRepeatCurrentAyah() {
    repeatCurrentAyah.toggle()
  }

  func toggleListeningTranslation() {
    showListeningTranslation.toggle()
  }

  func toggleListeningTransliteration() {
    showListeningTransliteration.toggle()
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

  func playSelectedAyah() {
    guard let ayah = selectedAyah else { return }
    guard let url = TVSeedRepository.audioURL(
      reciter: selectedReciter,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber
    ) else {
      playbackErrorMessage = tvLocalized("Couldn’t play this ayah. Check your connection and try again.")
      onDiagnosticsError?(
        "tvos_playback_error",
        playbackErrorMessage ?? tvLocalized("Couldn’t play this ayah. Check your connection and try again."),
        [
          "reciter": selectedReciter.rawValue,
          "surah": "\(ayah.surahNumber)",
          "ayah": "\(ayah.ayahNumber)",
        ]
      )
      return
    }

    playbackErrorMessage = nil
    keepPlace(ayahID: ayah.id)
    let item = AVPlayerItem(url: url)
    itemStatusObservation = item.observe(\.status) { [weak self] item, _ in
      guard item.status == .failed else { return }
      DispatchQueue.main.async {
        guard let self, self.isCurrentItem(item) else { return }
        self.reportPlaybackFailure()
      }
    }
    player.replaceCurrentItem(with: item)
    player.play()
    isPlaying = true
  }

  private func isCurrentItem(_ object: Any?) -> Bool {
    guard let item = object as? AVPlayerItem else { return false }
    return item === player.currentItem
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
      selectedAyahs = TVSeedRepository.ayahs(for: neighbour.number)
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
  }
}
