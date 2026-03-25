import AVFoundation
import Foundation

final class TVAppViewModel: ObservableObject {
  @Published var selectedRoute: TVRoute
  @Published private(set) var activeColumn: TVShellColumn
  @Published private(set) var navigationItems: [TVNavigationItem]
  @Published private(set) var preferredContentSectionByRoute: [TVRoute: String]
  @Published private(set) var navigationFocusRequest = 0
  @Published private(set) var contentFocusRequest = 0

  let profilesViewModel: TVProfilesViewModel
  let homeViewModel = TVHomeViewModel()
  let quranViewModel = TVQuranViewModel()
  let favoritesViewModel = TVFavoritesViewModel()
  let settingsViewModel: TVSettingsViewModel
  let arabicViewModel = TVArabicViewModel()
  let learnViewModel = TVLearnViewModel()
  let gamesViewModel = TVGamesViewModel()
  let prayerViewModel = TVPrayerViewModel()
  let dhikrViewModel = TVDhikrViewModel()
  let kidsViewModel = TVKidsViewModel()
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    TVTelemetry.bootstrap(userDefaults: userDefaults)
    navigationItems = TVRoute.allCases.map(TVNavigationItem.init)
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
    selectedRoute = settingsViewModel.startupPreference.resolvedRoute(
      lastUsedRoute: profilesViewModel.routeForActiveProfile()
    )
    quranViewModel.onDiagnosticsEvent = { [weak self] name, metadata in
      guard let self else { return }
      TVTelemetry.logEvent(name, metadata: metadata, userDefaults: self.userDefaults)
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

  var systemStatusSnapshot: TVSystemStatusSnapshot {
    TVSeedRepository.systemStatus(for: selectedRoute)
  }

  func navigate(to route: TVRoute, preferredColumn: TVShellColumn = .content) {
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
  @Published private(set) var supportCards: [TVSettingsSupportCard] =
      TVSeedRepository.settingsSupportCards()
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
    startupPreference =
        TVStartupPreference(rawValue: startupPreferenceRawValue ?? "") ??
        .lastUsed
    defaultReciter =
        TVQuranReciter(rawValue: defaultReciterRawValue ?? "") ?? .husary
    self.showListeningTranslationByDefault =
        showListeningTranslationByDefault ?? true
    self.showListeningTransliterationByDefault =
        showListeningTransliterationByDefault ?? true
  }

  var startupTitle: String {
    tvLocalized("Startup behavior")
  }

  var startupSubtitle: String {
    tvLocalized(
      "Choose what the room should see first when Apple TV opens Path of Nūr."
    )
  }

  var listeningTitle: String {
    tvLocalized("Listening defaults")
  }

  var listeningSubtitle: String {
    tvLocalized(
      "Set the default reciter and verse helpers for full-screen Qur'an listening mode."
    )
  }

  var supportTitle: String {
    tvLocalized("tvOS settings note")
  }

  var supportSubtitle: String {
    tvLocalized(
      "Keep only television-safe preferences here and leave denser management to companion devices."
    )
  }

  var detailRailTitle: String {
    tvLocalized("Current tvOS defaults")
  }

  var detailRailSubtitle: String {
    tvLocalized(
      "These choices shape startup and listening behavior across the current Apple TV experience."
    )
  }

  var diagnosticsTitle: String {
    tvLocalized("Diagnostics and quality")
  }

  var diagnosticsSubtitle: String {
    tvLocalized("Keep route telemetry, crash buffering, and playback-failure visibility local-first on Apple TV.")
  }

  var diagnosticsSummary: TVDiagnosticsSummary {
    TVTelemetry.diagnosticsSummary()
  }

  var detailRailPoints: [String] {
    [
      String(
        format: tvLocalized("Startup route: %@"),
        tvLocalized(startupPreference.titleKey)
      ),
      String(
        format: tvLocalized("Default reciter: %@"),
        defaultReciter.displayName
      ),
      showListeningTranslationByDefault
          ? tvLocalized("Translation shows by default in listening mode.")
          : tvLocalized("Translation stays hidden by default in listening mode."),
      showListeningTransliterationByDefault
          ? tvLocalized("Transliteration shows by default in listening mode.")
          : tvLocalized(
              "Transliteration stays hidden by default in listening mode."
            ),
    ]
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
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.prayerHero()
  @Published private(set) var summaryLine: String = ""
  @Published private(set) var detailLine: String = ""
  @Published private(set) var prayerTimes: [TVPrayerTime] = []
  @Published private(set) var focusCards: [TVPrayerFocusCard] =
      TVSeedRepository.prayerFocusCards()

  var currentNextTitle: String {
    tvLocalized("Current and next salah")
  }

  var currentNextSubtitle: String {
    tvLocalized("Begin with the strongest immediate prayer signal, then settle into the rest of the day.")
  }

  var scheduleTitle: String {
    tvLocalized("Today's prayer rhythm")
  }

  var scheduleSubtitle: String {
    tvLocalized("Keep the full day visible without turning the route into a dense settings or calculation surface.")
  }

  var companionTitle: String {
    tvLocalized("Prayer companion")
  }

  var companionSubtitle: String {
    tvLocalized("Use calm reminders that guide preparation, presence, and return to worship after the screen is closed.")
  }

  private var timer: Timer?

  init() {
    refresh()
    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
  }

  deinit {
    timer?.invalidate()
  }

  func refresh() {
    let snapshot = TVSeedRepository.homePrayerSnapshot(date: Date())
    summaryLine = snapshot.summaryLine
    detailLine = snapshot.detailLine
    prayerTimes = snapshot.prayerTimes
  }
}

final class TVDhikrViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.dhikrHero()
  @Published private(set) var modes: [TVDhikrModeCard] = TVSeedRepository.dhikrModes()
  @Published private(set) var supportCards: [TVDhikrSupportCard] =
      TVSeedRepository.dhikrSupportCards()
  @Published private(set) var selectedModeId: String

  init() {
    selectedModeId = TVSeedRepository.dhikrModes().first?.id ?? ""
  }

  var modesTitle: String {
    tvLocalized("Choose a remembrance path")
  }

  var modesSubtitle: String {
    tvLocalized("Start with one calm mode built for the room: after prayer, seeking forgiveness, or a quiet family return.")
  }

  var guidedFlowTitle: String {
    tvLocalized("Guided remembrance mode")
  }

  var guidedFlowSubtitle: String {
    tvLocalized("Move phrase by phrase with large Arabic, simple meaning, and no counter-style pressure on the television.")
  }

  var companionTitle: String {
    tvLocalized("Dhikr companion")
  }

  var companionSubtitle: String {
    tvLocalized("Keep the route grounded in sincerity, calm pacing, and easy return after salah or at the end of the evening.")
  }

  var selectedMode: TVDhikrModeCard? {
    modes.first(where: { $0.id == selectedModeId }) ?? modes.first
  }

  var selectedModeSteps: [TVDhikrGuideStep] {
    guard let selectedMode else { return [] }
    return TVSeedRepository.dhikrSteps(for: selectedMode.id)
  }

  func selectMode(_ mode: TVDhikrModeCard) {
    selectedModeId = mode.id
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
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.homeHero()
  @Published private(set) var verse: TVHomeVerse = TVSeedRepository.homeVerse()
  @Published private(set) var prayerSummaryLine: String = ""
  @Published private(set) var prayerSummaryDetail: String = ""
  @Published private(set) var prayerTimes: [TVPrayerTime] = []
  @Published private(set) var continueJourneyItems: [TVContinueJourneyItem] =
      TVSeedRepository.homeContinueJourneyItems()
  @Published private(set) var actions: [TVShelfItem] = TVSeedRepository.homeActions()
  @Published private(set) var continueReading: TVContinueReadingSummary = TVSeedRepository.continueReading

  var continueJourneySummaryTitle: String {
    tvLocalized("Continue your journey")
  }

  var continueJourneySummarySubtitle: String {
    tvLocalized("Resume the strongest next step quickly: Qur'an reading, listening, or today's worship rhythm.")
  }

  var prayerSectionSubtitle: String {
    tvLocalized("Prayer remains the calm first glance on TV: current, next, then the full day.")
  }

  var dailyLightSubtitle: String {
    tvLocalized("Keep one verse close, then step back into the Qur'an when the room is ready.")
  }

  private var timer: Timer?

  init() {
    refresh()
    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
  }

  deinit {
    timer?.invalidate()
  }

  func refresh() {
    let snapshot = TVSeedRepository.homePrayerSnapshot(date: Date())
    prayerSummaryLine = snapshot.summaryLine
    prayerSummaryDetail = snapshot.detailLine
    prayerTimes = snapshot.prayerTimes
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
  @Published private(set) var surahs: [TVQuranSurah] = TVSeedRepository.quranSurahs
  @Published private(set) var dailyVerse: TVQuranDailyVerse = TVSeedRepository.dailyVerse
  @Published private(set) var continueReading: TVContinueReadingSummary = TVSeedRepository.continueReading
  @Published private(set) var browseCollections: [TVQuranBrowseCollection] =
      TVSeedRepository.quranBrowseCollections()
  @Published private(set) var selectedAyahs: [TVQuranAyah]
  @Published var selectedSurah: TVQuranSurah
  @Published var selectedAyahIndex: Int = 0
  @Published var selectedReciter: TVQuranReciter = .husary
  @Published var isListeningModePresented = false
  @Published var showListeningTranslation = true
  @Published var showListeningTransliteration = true
  @Published var repeatCurrentAyah = false
  @Published private(set) var isPlaying = false
  @Published private(set) var playbackErrorMessage: String?

  var onDiagnosticsEvent: ((String, [String: String]) -> Void)?
  var onDiagnosticsError: ((String, String, [String: String]) -> Void)?

  private let player = AVPlayer()
  private var endObserver: NSObjectProtocol?

  init() {
    selectedSurah = TVSeedRepository.quranSurahs.first!
    selectedAyahs = TVSeedRepository.ayahs(for: TVSeedRepository.quranSurahs.first!.number)
    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self else { return }
      if self.repeatCurrentAyah {
        self.playSelectedAyah()
      } else {
        self.playNextAyah(autoStart: true)
      }
    }
  }

  deinit {
    if let endObserver {
      NotificationCenter.default.removeObserver(endObserver)
    }
  }

  var selectedAyah: TVQuranAyah? {
    guard selectedAyahIndex >= 0 && selectedAyahIndex < selectedAyahs.count else {
      return nil
    }
    return selectedAyahs[selectedAyahIndex]
  }

  var continueReadingLine: String {
    String(
      format: tvLocalized("Continue with %@ %d:%d"),
      continueReading.surahName,
      continueReading.surahNumber,
      continueReading.ayahNumber
    )
  }

  var continueReadingSummaryTitle: String {
    tvLocalized("Continue your reading")
  }

  var continueReadingSummarySubtitle: String {
    tvLocalized("Return to the current reading path first, then browse or listen from the same place.")
  }

  var dailyVerseSummaryTitle: String {
    tvLocalized("Today's verse")
  }

  var dailyVerseSummarySubtitle: String {
    tvLocalized("Keep one ayah visible on TV, then step into reading with the same calm focus.")
  }

  var readerSubtitle: String {
    let surah = selectedSurah
    return "\(surah.transliteratedName) • \(surah.englishName) • \(surah.revelationPlace)"
  }

  var browseShelfSubtitle: String {
    tvLocalized("Choose a guided shelf first, then move into the full surah list without leaving the reading route.")
  }

  var readerStageTitle: String {
    tvLocalized("Reading now")
  }

  var readerStageSubtitle: String {
    if let ayah = selectedAyah {
      return String(
        format: tvLocalized("Selected ayah: %@ %d:%d"),
        selectedSurah.transliteratedName,
        selectedSurah.number,
        ayah.ayahNumber
      )
    }
    return readerSubtitle
  }

  var readerStageSupportingLine: String {
    tvLocalized("Browse on the left, then read on the right with large Arabic text, transliteration, and translation kept together.")
  }

  var playbackSectionSubtitle: String {
    tvLocalized("Playback supports the reading flow here, with full listening mode ready for focused recitation on TV.")
  }

  var listeningModeHeaderLine: String {
    guard let ayah = selectedAyah else {
      return readerSubtitle
    }
    return String(
      format: tvLocalized("Listening with %@ %d:%d"),
      selectedSurah.transliteratedName,
      selectedSurah.number,
      ayah.ayahNumber
    )
  }

  var listeningModeStatusLine: String {
    let playbackLine = isPlaying
        ? tvLocalized("Audio is playing")
        : tvLocalized("Audio is paused")
    if repeatCurrentAyah {
      return "\(playbackLine) • \(tvLocalized("Repeat current ayah is on"))"
    }
    return playbackLine
  }

  var listeningModeArabicText: String {
    selectedAyah?.arabic ?? tvLocalized("No ayah selected")
  }

  var listeningModeTransliterationText: String {
    selectedAyah?.transliteration ?? ""
  }

  var listeningModeTranslationText: String {
    selectedAyah?.translation ?? ""
  }

  var listeningModeTransportLine: String {
    tvLocalized("Stay in a calm full-screen listening flow while switching reciters or moving ayah by ayah.")
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

  var playbackSummary: String {
    guard let ayah = selectedAyah else {
      return tvLocalized("No ayah selected")
    }
    return String(
      format: tvLocalized("Playback summary: %@ %d:%d"),
      selectedSurah.transliteratedName,
      selectedSurah.number,
      ayah.ayahNumber
    )
  }

  func selectSurah(_ surah: TVQuranSurah) {
    selectedSurah = surah
    selectedAyahs = TVSeedRepository.ayahs(for: surah.number)
    selectedAyahIndex = 0
    stopPlayback()
  }

  func selectAyah(at index: Int) {
    guard index >= 0 && index < selectedAyahs.count else { return }
    selectedAyahIndex = index
    stopPlayback()
  }

  func selectReciter(_ reciter: TVQuranReciter) {
    selectedReciter = reciter
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
    selectedReciter = reciter
    showListeningTranslation = showTranslation
    showListeningTransliteration = showTransliteration
    if isPlaying {
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

  func playPreviousAyah() {
    playPreviousAyah(autoStart: isPlaying)
  }

  func playNextAyah() {
    playNextAyah(autoStart: isPlaying)
  }

  func playSelectedAyah() {
    guard let ayah = selectedAyah else { return }
    guard let url = TVSeedRepository.audioURL(
      reciter: selectedReciter,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber
    ) else {
      playbackErrorMessage = tvLocalized("Playback unavailable right now.")
      onDiagnosticsError?(
        "tvos_playback_error",
        playbackErrorMessage ?? tvLocalized("Playback unavailable right now."),
        [
          "reciter": selectedReciter.rawValue,
          "surah": "\(ayah.surahNumber)",
          "ayah": "\(ayah.ayahNumber)",
        ]
      )
      return
    }

    playbackErrorMessage = nil
    let item = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: item)
    player.play()
    isPlaying = true
  }

  private func playPreviousAyah(autoStart: Bool) {
    guard !selectedAyahs.isEmpty else { return }
    selectedAyahIndex = max(selectedAyahIndex - 1, 0)
    if autoStart {
      playSelectedAyah()
    } else {
      stopPlayback()
    }
  }

  private func playNextAyah(autoStart: Bool) {
    guard !selectedAyahs.isEmpty else { return }
    let nextIndex = min(selectedAyahIndex + 1, selectedAyahs.count - 1)
    guard nextIndex != selectedAyahIndex || !autoStart else {
      stopPlayback()
      return
    }
    selectedAyahIndex = nextIndex
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
