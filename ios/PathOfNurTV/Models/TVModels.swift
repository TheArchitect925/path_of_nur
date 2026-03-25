import Foundation

enum TVTab: String, Hashable {
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
}

enum TVStartupPreference: String, CaseIterable, Hashable, Identifiable {
  case profiles
  case lastUsed
  case home
  case quran
  case prayer
  case learn

  var id: String { rawValue }

  var titleKey: String {
    switch self {
    case .profiles:
      return "Open Profiles first"
    case .lastUsed:
      return "Resume last household route"
    case .home:
      return "Start on Home"
    case .quran:
      return "Start on Qur'an"
    case .prayer:
      return "Start on Prayer"
    case .learn:
      return "Start on Learn"
    }
  }

  var subtitleKey: String {
    switch self {
    case .profiles:
      return "Let the room choose the household context before content begins."
    case .lastUsed:
      return "Return to the strongest route saved for the active household profile."
    case .home:
      return "Begin with prayer rhythm and continue-your-journey guidance."
    case .quran:
      return "Open directly into reading, browsing, and listening."
    case .prayer:
      return "Open directly into current and next salah guidance."
    case .learn:
      return "Open directly into the curated learning hub for shared study."
    }
  }

  var systemImage: String {
    switch self {
    case .profiles:
      return "person.3.fill"
    case .lastUsed:
      return "arrow.clockwise.circle.fill"
    case .home:
      return "house.fill"
    case .quran:
      return "book.closed.fill"
    case .prayer:
      return "clock.badge.checkmark.fill"
    case .learn:
      return "graduationcap.fill"
    }
  }

  func resolvedRoute(lastUsedRoute: TVRoute) -> TVRoute {
    switch self {
    case .profiles:
      return .profiles
    case .lastUsed:
      return lastUsedRoute
    case .home:
      return .home
    case .quran:
      return .quran
    case .prayer:
      return .prayer
    case .learn:
      return .learn
    }
  }
}

struct TVSettingsSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVDiagnosticsSummary: Hashable {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let chips: [String]
}

struct TVHeroContent: Hashable {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
}

struct TVShelfItem: Identifiable, Hashable {
  let id: String
  let title: String
  let subtitle: String
  let systemImage: String
}

struct TVPrayerTime: Identifiable, Hashable {
  let id: String
  let title: String
  let arabicTitle: String
  let timeLabel: String
  let statusLine: String
  let isCurrent: Bool
  let isNext: Bool
}

struct TVPrayerFocusCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVDhikrModeCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let focusPhrases: [String]
}

struct TVDhikrGuideStep: Identifiable, Hashable {
  let id: String
  let arabic: String
  let transliteration: String
  let translation: String
  let helperLine: String
}

struct TVDhikrSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVKidsSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVArabicLetterGroup: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let letters: [String]
  let exampleSound: String
  let focusPoints: [String]
}

struct TVArabicSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVGamesChallengeOption: Identifiable, Hashable {
  let id: String
  let title: String
  let supportingLine: String
  let isCorrect: Bool
  let feedbackTitle: String
  let feedbackBody: String
}

struct TVGamesChallengeCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let prompt: String
  let promptSupport: String
  let options: [TVGamesChallengeOption]
}

struct TVGamesSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVSavedItemCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let detailLine: String
  let systemImage: String
  let tags: [String]
}

struct TVFavoritesSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVHouseholdProfile: Identifiable, Hashable {
  let id: String
  let avatar: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let audienceLabel: String
  let syncLabel: String
  let detailPoints: [String]
  let preferredRoute: TVRoute
}

struct TVSessionContinuityCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let detailLine: String
  let systemImage: String
  let route: TVRoute
  let chips: [String]
}

struct TVHouseholdSupportCard: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVSystemStatusSnapshot: Hashable {
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let chips: [String]
}

struct TVHomeVerse: Hashable {
  let arabic: String
  let transliteration: String
  let translation: String
  let locationLabel: String
}

struct TVContinueReadingSummary: Hashable {
  let surahNumber: Int
  let surahName: String
  let ayahNumber: Int
}

struct TVContinueJourneyItem: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
}

struct TVQuranBrowseCollection: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let surahNumbers: [Int]
}

struct TVLearnHubItem: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let detailPoints: [String]
}

struct TVLearnHubSection: Identifiable, Hashable {
  let id: String
  let title: String
  let subtitle: String
  let items: [TVLearnHubItem]
}

struct TVLearnStoryEntry: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let takeawayPoints: [String]
  let reflectionPrompt: String
}

struct TVLearnStoryCollection: Identifiable, Hashable {
  let id: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let entries: [TVLearnStoryEntry]
}

struct TVLearnVisualEntry: Identifiable, Hashable {
  let id: String
  let eyebrow: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let accentLabel: String
  let takeawayPoints: [String]
  let observationPrompt: String
}

struct TVLearnVisualCollection: Identifiable, Hashable {
  let id: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let entries: [TVLearnVisualEntry]
}

struct TVQuranDailyVerse: Hashable {
  let surahNumber: Int
  let ayahNumber: Int
  let arabic: String
  let transliteration: String
  let translation: String
  let locationLabel: String
}

struct TVQuranSurah: Identifiable, Hashable {
  let id: Int
  let number: Int
  let arabicName: String
  let transliteratedName: String
  let englishName: String
  let verseCount: Int
  let revelationPlace: String
}

struct TVQuranAyah: Identifiable, Hashable {
  let id: String
  let surahNumber: Int
  let ayahNumber: Int
  let arabic: String
  let transliteration: String
  let translation: String
}

enum TVQuranReciter: String, CaseIterable {
  case husary
  case alafasy
  case abdulbasit

  var displayName: String {
    switch self {
    case .husary:
      return tvLocalized("Mahmoud Khalil Al-Husary")
    case .alafasy:
      return tvLocalized("Mishary Rashid Alafasy")
    case .abdulbasit:
      return tvLocalized("Abdul Basit Murattal")
    }
  }

  var shortLabel: String {
    switch self {
    case .husary:
      return tvLocalized("Husary")
    case .alafasy:
      return tvLocalized("Alafasy")
    case .abdulbasit:
      return tvLocalized("Basit")
    }
  }

  var baseURL: String {
    switch self {
    case .husary:
      return "https://everyayah.com/data/Husary_128kbps"
    case .alafasy:
      return "https://everyayah.com/data/Alafasy_128kbps"
    case .abdulbasit:
      return "https://everyayah.com/data/Abdul_Basit_Murattal_192kbps"
    }
  }
}
