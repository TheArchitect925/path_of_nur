import Foundation

enum TVTab: String, Hashable {
  case home
  case quran
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
