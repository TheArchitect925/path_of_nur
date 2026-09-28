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

  /// The sections this build shows, in rail order. The other six are built
  /// on sample content and stay out of the rail until each one is real.
  static let released: [TVRoute] = [.home, .prayer, .quran, .dhikr, .settings]

  var isReleased: Bool { Self.released.contains(self) }

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
      return "Qur’an"
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
      return "Today’s prayers and verse"
    case .profiles:
      return "Household switching, shared-device safety, and resume continuity rebuilt for television."
    case .quran:
      return "Read and listen"
    case .favorites:
      return "Bookmarks, saved reflections, playlists, and watch-later continuity rebuilt for calm television return."
    case .settings:
      return "Appearance and listening"
    case .arabic:
      return "Letters, sounds, and beginner Qur'anic Arabic rebuilt for large-screen guided learning."
    case .learn:
      return "Journey-first learning and broad knowledge shelves adapted for calm TV browsing."
    case .games:
      return "Remote-friendly quizzes, matching, and guided challenge play adapted for the family room."
    case .prayer:
      return "Today’s prayer times"
    case .dhikr:
      return "Remembrance, phrase by phrase"
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
      return TVFocusSectionId.dhikrRoutines
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
      ]
    case .settings:
      return [
        TVFocusSectionId.settingsStartup,
        TVFocusSectionId.settingsPrayer,
        TVFocusSectionId.settingsAppearance,
        TVFocusSectionId.settingsListening,
      ]
    case .arabic:
      return [
        TVFocusSectionId.arabicPrimary,
        TVFocusSectionId.arabicLetters,
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
      ]
    case .prayer:
      return [
        TVFocusSectionId.prayerCurrentNext,
        TVFocusSectionId.prayerSchedule,
      ]
    case .dhikr:
      return [
        TVFocusSectionId.dhikrRoutines,
        TVFocusSectionId.dhikrPhrases,
      ]
    case .kids:
      return [
        TVFocusSectionId.kidsPrimary,
        TVFocusSectionId.kidsStory,
      ]
    }
  }
}

struct TVNavigationItem: Identifiable, Hashable {
  let route: TVRoute
  let titleKey: String
  let subtitleKey: String
  let systemImage: String

  init(route: TVRoute) {
    self.route = route
    titleKey = route.titleKey
    subtitleKey = route.subtitleKey
    systemImage = route.systemImage
  }

  var id: TVRoute { route }
}

enum TVFocusSectionId {
  static let homeContinueJourney = "home.continueJourney"
  static let homeVerse = "home.verse"
  static let profilesPrimary = "profiles.primary"
  static let profilesContinuity = "profiles.continuity"
  static let quranPlayback = "quran.playback"
  static let quranBrowse = "quran.browse"
  static let quranReader = "quran.reader"
  static let favoritesPrimary = "favorites.primary"
  static let favoritesSaved = "favorites.saved"
  static let settingsStartup = "settings.startup"
  static let settingsPrayer = "settings.prayer"
  static let settingsAppearance = "settings.appearance"
  static let settingsListening = "settings.listening"
  static let arabicPrimary = "arabic.primary"
  static let arabicLetters = "arabic.letters"
  static let learnPrimary = "learn.primary"
  static let learnShelf = "learn.shelf"
  static let learnStory = "learn.story"
  static let learnVisual = "learn.visual"
  static let gamesPrimary = "games.primary"
  static let gamesChallenge = "games.challenge"
  static let prayerCurrentNext = "prayer.currentNext"
  static let prayerSchedule = "prayer.schedule"
  static let dhikrRoutines = "dhikr.routines"
  static let dhikrPhrases = "dhikr.phrases"
  static let kidsPrimary = "kids.primary"
  static let kidsStory = "kids.story"

  static func quranSurahRow(_ surahId: Int) -> String {
    "quran.browse.\(surahId)"
  }

  /// The first part of an ayah, which is the whole of most.
  static func quranAyah(_ ayahId: String) -> String {
    "quran.reader.\(ayahId)"
  }

  /// A part's id is its ayah's id for the first part, and the ayah's id with
  /// the part's number after it for the rest.
  static func quranAyahPart(_ partId: String) -> String {
    "quran.reader.\(partId)"
  }

  static func quranCollection(_ collectionId: String) -> String {
    "quran.browse.collection.\(collectionId)"
  }

  static let quranContinueReading = "quran.browse.shortcut.continue"
  static let quranTodaysVerse = "quran.browse.shortcut.today"
  static let quranPlaybackPrevious = "quran.playback.previous"
  static let quranPlaybackNext = "quran.playback.next"
  static let quranPlaybackListening = "quran.playback.listening"

  static let quranPlaybackOptions = "quran.playback.options"
  static let quranGoTo = "quran.browse.shortcut.goto"
}
