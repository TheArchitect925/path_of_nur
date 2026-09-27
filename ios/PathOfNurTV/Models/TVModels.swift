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

  /// The choices Settings offers: the ones that open a released section.
  static var released: [TVStartupPreference] {
    allCases.filter { $0 == .lastUsed || $0.resolvedRoute(lastUsedRoute: .home).isReleased }
  }

  var titleKey: String {
    switch self {
    case .profiles:
      return "Open Profiles first"
    case .lastUsed:
      return "Where you left off"
    case .home:
      return "Home"
    case .quran:
      return "Qur’an"
    case .prayer:
      return "Prayer"
    case .learn:
      return "Start on Learn"
    }
  }

  var subtitleKey: String {
    switch self {
    case .profiles:
      return "Let the room choose the household context before content begins."
    case .lastUsed:
      return "Opens the last section you used."
    case .home:
      return "Opens on today’s prayers and verse."
    case .quran:
      return "Opens on the reader."
    case .prayer:
      return "Opens on today’s prayer times."
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

  /// Where the app opens. A stored choice can name a section this build
  /// does not show, so the answer is checked before it is used.
  func openingRoute(lastUsedRoute: TVRoute) -> TVRoute {
    let route = resolvedRoute(lastUsedRoute: lastUsedRoute)
    return route.isReleased ? route : .home
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

struct TVDhikrRoutineStep: Identifiable, Hashable {
  let id: String
  let title: String
  let arabic: String
  let transliteration: String
  let translation: String
  let count: Int
  let sourceRef: String

  /// Long duʿās read as a paragraph; the player paces them slower.
  var isLongText: Bool { arabic.count > 70 }
}

/// A guided routine mirrored from the phone catalog (generated data).
struct TVDhikrRoutine: Identifiable, Hashable {
  let id: String
  let kind: String
  let title: String
  let subtitle: String
  let sourceRef: String
  let steps: [TVDhikrRoutineStep]

  var totalCount: Int { steps.reduce(0) { $0 + $1.count } }

  var estimatedMinutes: Int {
    let seconds = steps.reduce(0) { $0 + $1.count * ($1.isLongText ? 20 : 2) }
    return max(1, Int((Double(seconds) / 60).rounded(.up)))
  }

  var systemImage: String {
    switch kind {
    case "afterSalah": return "hands.sparkles.fill"
    case "morning": return "sun.max.fill"
    case "evening": return "moon.stars.fill"
    case "sleep": return "bed.double.fill"
    default: return "heart.fill"
    }
  }
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

/// One focus stop of an ayah. Most ayahs are a single part. One too long to
/// be read in the room it is given is set in several, each of which fits:
/// the Arabic first, then its reading and its meaning.
struct TVQuranAyahPart: Identifiable, Hashable {
  let ayahID: String
  let ayahNumber: Int
  /// From zero.
  let index: Int
  let count: Int
  let arabic: String
  let transliteration: String
  let translation: String

  var id: String {
    index == 0 ? ayahID : "\(ayahID).p\(index + 1)"
  }

  var heading: String {
    count > 1
      ? tvLocalized("Ayah %d, part %d of %d", ayahNumber, index + 1, count)
      : tvLocalized("Ayah %d", ayahNumber)
  }
}

enum TVQuranReciter: String, CaseIterable {
  case husary
  case alafasy
  case abdulbasit

  /// The reciter a new viewer hears, which is the phone's
  /// (`QuranAudioRepository.defaultReciterId`).
  static let phoneDefault = TVQuranReciter.alafasy

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
