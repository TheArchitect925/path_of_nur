import Foundation

enum TVShellColumn: String, Hashable {
  case navigation
  case content
}

enum TVRoute: String, CaseIterable, Hashable, Identifiable {
  case home
  case profiles
  case quran
  case favorites
  case settings
  case arabic
  case learn
  case games
  case prayer
  case dhikr
  case kids

  var id: String { rawValue }

  var tab: TVTab {
    switch self {
    case .home:
      return .home
    case .profiles:
      return .profiles
    case .quran:
      return .quran
    case .favorites:
      return .favorites
    case .settings:
      return .settings
    case .arabic:
      return .arabic
    case .learn:
      return .learn
    case .games:
      return .games
    case .prayer:
      return .prayer
    case .dhikr:
      return .dhikr
    case .kids:
      return .kids
    }
  }

  var titleKey: String {
    switch self {
    case .home:
      return "Home"
    case .profiles:
      return "Profiles"
    case .quran:
      return "Qur'an"
    case .favorites:
      return "Saved"
    case .settings:
      return "Settings"
    case .arabic:
      return "Arabic"
    case .learn:
      return "Learn"
    case .games:
      return "Games"
    case .prayer:
      return "Prayer"
    case .dhikr:
      return "Dhikr"
    case .kids:
      return "Kids"
    }
  }

  var subtitleKey: String {
    switch self {
    case .home:
      return "Prayer-first daily guidance with quick return into the Qur'an."
    case .profiles:
      return "Household switching, shared-device safety, and resume continuity rebuilt for television."
    case .quran:
      return "Reading, browsing, and listening in one calm large-screen flow."
    case .favorites:
      return "Bookmarks, saved reflections, playlists, and watch-later continuity rebuilt for calm television return."
    case .settings:
      return "Television-safe startup, listening, and family-room preferences rebuilt for Apple TV."
    case .arabic:
      return "Letters, sounds, and beginner Qur'anic Arabic rebuilt for large-screen guided learning."
    case .learn:
      return "Journey-first learning and broad knowledge shelves adapted for calm TV browsing."
    case .games:
      return "Remote-friendly quizzes, matching, and guided challenge play adapted for the family room."
    case .prayer:
      return "Current, next, and full-day salah guidance rebuilt for calm television viewing."
    case .dhikr:
      return "Guided remembrance and calm phrase-by-phrase dhikr rebuilt for television."
    case .kids:
      return "Family-safe stories, Qur'an, and beginner learning rebuilt for shared television use."
    }
  }

  var systemImage: String {
    switch self {
    case .home:
      return "house.fill"
    case .profiles:
      return "person.3.fill"
    case .quran:
      return "book.closed.fill"
    case .favorites:
      return "bookmark.fill"
    case .settings:
      return "gearshape.fill"
    case .arabic:
      return "textformat.abc.dottedunderline"
    case .learn:
      return "graduationcap.fill"
    case .games:
      return "gamecontroller.fill"
    case .prayer:
      return "clock.badge.checkmark.fill"
    case .dhikr:
      return "sparkles"
    case .kids:
      return "person.2.crop.square.stack.fill"
    }
  }

  var pathLabelKey: String {
    switch self {
    case .home:
      return "/home"
    case .profiles:
      return "/accounts-sync/profiles"
    case .quran:
      return "/quran"
    case .favorites:
      return "/quran/bookmarks"
    case .settings:
      return "/settings"
    case .arabic:
      return "/quran/arabic"
    case .learn:
      return "/learn"
    case .games:
      return "/learn/games"
    case .prayer:
      return "/worship/prayer"
    case .dhikr:
      return "/worship/dhikr"
    case .kids:
      return "/learn/kids/fun-learning"
    }
  }

  var defaultContentSection: String {
    switch self {
    case .home:
      return TVFocusSectionId.homeContinueJourney
    case .profiles:
      return TVFocusSectionId.profilesPrimary
    case .quran:
      return TVFocusSectionId.quranBrowse
    case .favorites:
      return TVFocusSectionId.favoritesPrimary
    case .settings:
      return TVFocusSectionId.settingsStartup
    case .arabic:
      return TVFocusSectionId.arabicPrimary
    case .learn:
      return TVFocusSectionId.learnPrimary
    case .games:
      return TVFocusSectionId.gamesPrimary
    case .prayer:
      return TVFocusSectionId.prayerCurrentNext
    case .dhikr:
      return TVFocusSectionId.dhikrModes
    case .kids:
      return TVFocusSectionId.kidsPrimary
    }
  }

  var supportedContentSections: [String] {
    switch self {
    case .home:
      return [
        TVFocusSectionId.homeContinueJourney,
        TVFocusSectionId.homeVerse,
      ]
    case .profiles:
      return [
        TVFocusSectionId.profilesPrimary,
        TVFocusSectionId.profilesContinuity,
        TVFocusSectionId.profilesSupport,
      ]
    case .quran:
      return [
        TVFocusSectionId.quranPlayback,
        TVFocusSectionId.quranBrowse,
        TVFocusSectionId.quranReader,
      ]
    case .favorites:
      return [
        TVFocusSectionId.favoritesPrimary,
        TVFocusSectionId.favoritesSaved,
        TVFocusSectionId.favoritesSupport,
      ]
    case .settings:
      return [
        TVFocusSectionId.settingsStartup,
        TVFocusSectionId.settingsListening,
        TVFocusSectionId.settingsSupport,
      ]
    case .arabic:
      return [
        TVFocusSectionId.arabicPrimary,
        TVFocusSectionId.arabicLetters,
        TVFocusSectionId.arabicSupport,
      ]
    case .learn:
      return [
        TVFocusSectionId.learnPrimary,
        TVFocusSectionId.learnShelf,
        TVFocusSectionId.learnStory,
        TVFocusSectionId.learnVisual,
      ]
    case .games:
      return [
        TVFocusSectionId.gamesPrimary,
        TVFocusSectionId.gamesChallenge,
        TVFocusSectionId.gamesSupport,
      ]
    case .prayer:
      return [
        TVFocusSectionId.prayerCurrentNext,
        TVFocusSectionId.prayerSchedule,
        TVFocusSectionId.prayerCompanion,
      ]
    case .dhikr:
      return [
        TVFocusSectionId.dhikrModes,
        TVFocusSectionId.dhikrGuidedFlow,
        TVFocusSectionId.dhikrCompanion,
      ]
    case .kids:
      return [
        TVFocusSectionId.kidsPrimary,
        TVFocusSectionId.kidsStory,
        TVFocusSectionId.kidsSupport,
      ]
    }
  }
}

struct TVNavigationItem: Identifiable, Hashable {
  let route: TVRoute
  let titleKey: String
  let subtitleKey: String
  let systemImage: String
  let pathLabelKey: String

  init(route: TVRoute) {
    self.route = route
    titleKey = route.titleKey
    subtitleKey = route.subtitleKey
    systemImage = route.systemImage
    pathLabelKey = route.pathLabelKey
  }

  var id: TVRoute { route }
}

enum TVFocusSectionId {
  static let homeContinueJourney = "home.continueJourney"
  static let homeVerse = "home.verse"
  static let profilesPrimary = "profiles.primary"
  static let profilesContinuity = "profiles.continuity"
  static let profilesSupport = "profiles.support"
  static let quranPlayback = "quran.playback"
  static let quranBrowse = "quran.browse"
  static let quranReader = "quran.reader"
  static let favoritesPrimary = "favorites.primary"
  static let favoritesSaved = "favorites.saved"
  static let favoritesSupport = "favorites.support"
  static let settingsStartup = "settings.startup"
  static let settingsListening = "settings.listening"
  static let settingsSupport = "settings.support"
  static let arabicPrimary = "arabic.primary"
  static let arabicLetters = "arabic.letters"
  static let arabicSupport = "arabic.support"
  static let learnPrimary = "learn.primary"
  static let learnShelf = "learn.shelf"
  static let learnStory = "learn.story"
  static let learnVisual = "learn.visual"
  static let gamesPrimary = "games.primary"
  static let gamesChallenge = "games.challenge"
  static let gamesSupport = "games.support"
  static let prayerCurrentNext = "prayer.currentNext"
  static let prayerSchedule = "prayer.schedule"
  static let prayerCompanion = "prayer.companion"
  static let dhikrModes = "dhikr.modes"
  static let dhikrGuidedFlow = "dhikr.guidedFlow"
  static let dhikrCompanion = "dhikr.companion"
  static let kidsPrimary = "kids.primary"
  static let kidsStory = "kids.story"
  static let kidsSupport = "kids.support"

  static func quranSurahRow(_ surahId: Int) -> String {
    "quran.browse.\(surahId)"
  }

  static func quranAyah(_ ayahId: String) -> String {
    "quran.reader.\(ayahId)"
  }
}
