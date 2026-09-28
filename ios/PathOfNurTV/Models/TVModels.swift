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

  /// A phrase of the counter, which is a routine of one step.
  var isPhrase: Bool { kind == "phrase" }

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

struct TVHouseholdProfile: Identifiable, Hashable {
  let id: String
  let avatar: String
  let title: String
  let subtitle: String
  let supportingLine: String
  let systemImage: String
  let audienceLabel: String
  let syncLabel: String
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

/// A voice the Qur'an is heard in. Every one reads each ayah on its own
/// from EveryAyah, as the phone's three do (`QuranAudioRepository`). The
/// raw values of the phone's three are the phone's reciter ids.
enum TVQuranReciter: String, CaseIterable, Identifiable {
  case alafasy
  case husary
  case husaryMuallim = "husary_muallim"
  case abdulbasit
  case abdulbasitMujawwad = "abdulbasit_mujawwad"
  case minshawi
  case minshawiMujawwad = "minshawi_mujawwad"
  case sudais
  case shuraim
  case maher
  case ghamdi
  case hudhaify
  case ayyub
  case dossari
  case shatri
  case ajmi
  case basfar
  case jibreel
  case budair
  case fares
  case rifai
  case qatami

  /// The reciter a new viewer hears, which is the phone's
  /// (`QuranAudioRepository.defaultReciterId`).
  static let phoneDefault = TVQuranReciter.alafasy

  var id: String { rawValue }

  enum Style {
    /// Measured, as in prayer.
    case murattal
    /// Slow and melodic, as in a gathering.
    case mujawwad
    /// Slowly, for learning.
    case teaching
  }

  var style: Style {
    switch self {
    case .abdulbasitMujawwad, .minshawiMujawwad:
      return .mujawwad
    case .husaryMuallim:
      return .teaching
    default:
      return .murattal
    }
  }

  /// The reciter's name in Latin letters.
  var latinName: String {
    switch self {
    case .alafasy: return "Mishary Rashid Alafasy"
    case .husary, .husaryMuallim: return "Mahmoud Khalil Al-Husary"
    case .abdulbasit, .abdulbasitMujawwad: return "Abdul Basit Abdus-Samad"
    case .minshawi, .minshawiMujawwad: return "Mohamed Siddiq Al-Minshawi"
    case .sudais: return "Abdur-Rahman As-Sudais"
    case .shuraim: return "Saud Ash-Shuraim"
    case .maher: return "Maher Al-Muaiqly"
    case .ghamdi: return "Saad Al-Ghamdi"
    case .hudhaify: return "Ali Al-Hudhaify"
    case .ayyub: return "Muhammad Ayyub"
    case .dossari: return "Yasser Ad-Dossari"
    case .shatri: return "Abu Bakr Ash-Shatri"
    case .ajmi: return "Ahmed Al-Ajmi"
    case .basfar: return "Abdullah Basfar"
    case .jibreel: return "Muhammad Jibreel"
    case .budair: return "Salah Al-Budair"
    case .fares: return "Fares Abbad"
    case .rifai: return "Hani Ar-Rifai"
    case .qatami: return "Nasser Al-Qatami"
    }
  }

  /// The reciter's name in Arabic.
  var arabicName: String {
    switch self {
    case .alafasy: return "مشاري راشد العفاسي"
    case .husary, .husaryMuallim: return "محمود خليل الحصري"
    case .abdulbasit, .abdulbasitMujawwad: return "عبد الباسط عبد الصمد"
    case .minshawi, .minshawiMujawwad: return "محمد صديق المنشاوي"
    case .sudais: return "عبد الرحمن السديس"
    case .shuraim: return "سعود الشريم"
    case .maher: return "ماهر المعيقلي"
    case .ghamdi: return "سعد الغامدي"
    case .hudhaify: return "علي الحذيفي"
    case .ayyub: return "محمد أيوب"
    case .dossari: return "ياسر الدوسري"
    case .shatri: return "أبو بكر الشاطري"
    case .ajmi: return "أحمد بن علي العجمي"
    case .basfar: return "عبد الله بصفر"
    case .jibreel: return "محمد جبريل"
    case .budair: return "صلاح البدير"
    case .fares: return "فارس عباد"
    case .rifai: return "هاني الرفاعي"
    case .qatami: return "ناصر القطامي"
    }
  }

  /// The name as the viewer reads it: in Arabic letters where the interface
  /// is in Arabic or Urdu, in Latin letters elsewhere.
  var name: String {
    let language = Locale.current.languageCode ?? "en"
    return language == "ar" || language == "ur" ? arabicName : latinName
  }

  var styleLabel: String {
    switch style {
    case .murattal:
      return tvLocalized("Murattal")
    case .mujawwad:
      return tvLocalized("Mujawwad")
    case .teaching:
      return tvLocalized("Teaching pace")
    }
  }

  /// "Mahmoud Khalil Al-Husary · Teaching pace", where one reciter is heard
  /// in two ways; the name alone where there is one.
  var displayName: String {
    let twoWays: Set<TVQuranReciter> = [
      .husary, .husaryMuallim, .abdulbasit, .abdulbasitMujawwad, .minshawi, .minshawiMujawwad,
    ]
    return twoWays.contains(self) ? "\(name) · \(styleLabel)" : name
  }

  /// The EveryAyah collection the ayahs are streamed from.
  var baseURL: String {
    let folder: String
    switch self {
    case .alafasy: folder = "Alafasy_128kbps"
    case .husary: folder = "Husary_128kbps"
    case .husaryMuallim: folder = "Husary_Muallim_128kbps"
    case .abdulbasit: folder = "Abdul_Basit_Murattal_192kbps"
    case .abdulbasitMujawwad: folder = "Abdul_Basit_Mujawwad_128kbps"
    case .minshawi: folder = "Minshawy_Murattal_128kbps"
    case .minshawiMujawwad: folder = "Minshawy_Mujawwad_192kbps"
    case .sudais: folder = "Abdurrahmaan_As-Sudais_192kbps"
    case .shuraim: folder = "Saood_ash-Shuraym_128kbps"
    case .maher: folder = "MaherAlMuaiqly128kbps"
    case .ghamdi: folder = "Ghamadi_40kbps"
    case .hudhaify: folder = "Hudhaify_128kbps"
    case .ayyub: folder = "Muhammad_Ayyoub_128kbps"
    case .dossari: folder = "Yasser_Ad-Dussary_128kbps"
    case .shatri: folder = "Abu_Bakr_Ash-Shaatree_128kbps"
    case .ajmi: folder = "Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net"
    case .basfar: folder = "Abdullah_Basfar_192kbps"
    case .jibreel: folder = "Muhammad_Jibreel_128kbps"
    case .budair: folder = "Salah_Al_Budair_128kbps"
    case .fares: folder = "Fares_Abbad_64kbps"
    case .rifai: folder = "Hani_Rifai_192kbps"
    case .qatami: folder = "Nasser_Alqatami_128kbps"
    }
    return "https://everyayah.com/data/\(folder)"
  }
}

/// How often an ayah is heard before the recitation moves on.
enum TVQuranRepeat: String, CaseIterable, Identifiable {
  case off
  case ayahThree = "ayah3"
  case ayahFive = "ayah5"
  case ayahAlways = "ayah"
  case surah

  var id: String { rawValue }

  /// Times each ayah is heard; nothing for an ayah heard until the viewer
  /// moves on.
  var playsPerAyah: Int? {
    switch self {
    case .off, .surah:
      return 1
    case .ayahThree:
      return 3
    case .ayahFive:
      return 5
    case .ayahAlways:
      return nil
    }
  }

  /// Whether the surah begins again at its end.
  var loopsSurah: Bool { self == .surah }

  var title: String {
    switch self {
    case .off:
      return tvLocalized("No repeat")
    case .ayahThree:
      return tvLocalized("Each ayah 3 times")
    case .ayahFive:
      return tvLocalized("Each ayah 5 times")
    case .ayahAlways:
      return tvLocalized("This ayah, again and again")
    case .surah:
      return tvLocalized("The whole surah, again")
    }
  }

  /// The short form, beside the play button.
  var shortTitle: String {
    switch self {
    case .off:
      return tvLocalized("Repeat off")
    case .ayahThree:
      return tvLocalized("Ayah ×3")
    case .ayahFive:
      return tvLocalized("Ayah ×5")
    case .ayahAlways:
      return tvLocalized("Ayah ∞")
    case .surah:
      return tvLocalized("Surah ∞")
    }
  }

  var systemImage: String {
    switch self {
    case .off:
      return "repeat"
    case .ayahAlways, .ayahThree, .ayahFive:
      return "repeat.1"
    case .surah:
      return "repeat.circle.fill"
    }
  }

  /// The next setting, for the one button that steps through them.
  var next: TVQuranRepeat {
    let all = Self.allCases
    return all[(all.firstIndex(of: self)! + 1) % all.count]
  }
}

/// When the recitation stops by itself.
enum TVQuranSleepTimer: String, CaseIterable, Identifiable {
  case off
  case fifteen
  case thirty
  case sixty
  case endOfSurah

  var id: String { rawValue }

  /// How long it plays for, where it is a length of time.
  var duration: TimeInterval? {
    switch self {
    case .fifteen: return 15 * 60
    case .thirty: return 30 * 60
    case .sixty: return 60 * 60
    case .off, .endOfSurah: return nil
    }
  }

  var title: String {
    switch self {
    case .off:
      return tvLocalized("No sleep timer")
    case .fifteen:
      return tvLocalized("Stop after 15 minutes")
    case .thirty:
      return tvLocalized("Stop after 30 minutes")
    case .sixty:
      return tvLocalized("Stop after an hour")
    case .endOfSurah:
      return tvLocalized("Stop at the end of the surah")
    }
  }
}

/// How fast the recitation is played. Slower helps a learner follow it.
enum TVQuranSpeed: Double, CaseIterable, Identifiable {
  case slower = 0.75
  case normal = 1.0
  case faster = 1.25

  var id: Double { rawValue }

  var title: String {
    switch self {
    case .slower:
      return tvLocalized("Slower (0.75×)")
    case .normal:
      return tvLocalized("Normal speed")
    case .faster:
      return tvLocalized("Faster (1.25×)")
    }
  }
}
