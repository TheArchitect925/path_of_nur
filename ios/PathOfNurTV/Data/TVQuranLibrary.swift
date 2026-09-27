import Foundation

/// One of the generated Qur'an resources, read a surah at a time.
///
/// `tvos_quran_export.dart` writes each resource as a JSON array of 114
/// arrays, a surah to a line. A JSON string cannot hold a raw line break, so
/// every line break in the file stands between two surahs. The file is mapped,
/// not read, and asking for a surah parses that one line and no other.
final class TVQuranTextFile {
  static let surahCount = 114

  private let data: Data
  /// The bytes of each surah's line, brackets included, by surah number - 1.
  private let lines: [Range<Int>]

  init?(url: URL) {
    guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
      return nil
    }
    let comma = UInt8(ascii: ",")
    var lines: [Range<Int>] = []
    lines.reserveCapacity(Self.surahCount)
    data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
      guard let base = bytes.baseAddress else { return }
      var start = 0
      var lineNumber = 0
      while start < bytes.count,
            let found = memchr(base + start, Int32(UInt8(ascii: "\n")), bytes.count - start) {
        let index = base.distance(to: UnsafeRawPointer(found))
        // The first line opens the document and the last one closes it.
        if lineNumber >= 1 && lineNumber <= Self.surahCount {
          var end = index
          if end > start && bytes[end - 1] == comma {
            end -= 1
          }
          lines.append(start..<end)
        }
        lineNumber += 1
        start = index + 1
      }
    }
    guard lines.count == Self.surahCount else {
      return nil
    }
    self.data = data
    self.lines = lines
  }

  /// The verses of a surah in order, or nothing if there is no such surah.
  func verses(inSurah number: Int) -> [String] {
    guard number >= 1 && number <= lines.count else {
      return []
    }
    let line = lines[number - 1]
    let slice = data.subdata(
      in: (data.startIndex + line.lowerBound)..<(data.startIndex + line.upperBound)
    )
    return (try? JSONSerialization.jsonObject(with: slice)) as? [String] ?? []
  }
}

/// A translation of the meaning the Apple TV carries: the phone's bundled
/// set (`quranTranslationResources`), and the French the phone reads in
/// French. `id` names its file, `TVQuranTranslation_<id>.json`.
struct TVQuranTranslation: Hashable, Identifiable {
  let id: String
  /// The language it is in, in that language.
  let languageName: String
  /// Whose translation it is, where the source names them.
  let source: String
  /// Set right to left.
  var isRightToLeft = false

  static let all: [TVQuranTranslation] = [
    TVQuranTranslation(id: "en", languageName: "English", source: "Sahih International"),
    TVQuranTranslation(id: "en_clear", languageName: "English", source: "The Clear Quran"),
    TVQuranTranslation(id: "fr", languageName: "Français", source: "Muhammad Hamidullah"),
    TVQuranTranslation(id: "ur", languageName: "اردو", source: "", isRightToLeft: true),
    TVQuranTranslation(id: "bn", languageName: "বাংলা", source: ""),
    TVQuranTranslation(id: "id", languageName: "Bahasa Indonesia", source: ""),
    TVQuranTranslation(id: "tr", languageName: "Türkçe", source: ""),
    TVQuranTranslation(id: "fa", languageName: "دری", source: "", isRightToLeft: true),
  ]

  static func withID(_ id: String?) -> TVQuranTranslation? {
    all.first { $0.id == id }
  }

  /// The translation a viewer reading in `language` is shown until they
  /// choose one: their own where there is one, English where there is not,
  /// and none for a viewer who reads the Arabic itself.
  static func standard(forLanguage language: String) -> TVQuranTranslation? {
    if language == "ar" {
      return nil
    }
    return withID(language) ?? withID("en")
  }

  /// "English · Sahih International"
  var title: String {
    source.isEmpty ? languageName : "\(languageName) · \(source)"
  }
}

/// The translation the viewer chose, kept on the device. Until they choose,
/// it is `TVQuranTranslation.standard` for their language.
enum TVQuranTranslationChoice {
  static let storageKey = "PathOfNurTV.quran.translation"
  /// Kept for a viewer who chose to read without a translation.
  static let noneValue = "none"

  static func load(
    from userDefaults: UserDefaults = .standard,
    language: String = Locale.current.languageCode ?? "en"
  ) -> TVQuranTranslation? {
    guard let stored = userDefaults.string(forKey: storageKey) else {
      return .standard(forLanguage: language)
    }
    if stored == noneValue {
      return nil
    }
    return .withID(stored) ?? .standard(forLanguage: language)
  }

  static func save(_ translation: TVQuranTranslation?, to userDefaults: UserDefaults = .standard) {
    userDefaults.set(translation?.id ?? noneValue, forKey: storageKey)
  }
}

/// The Qur'an the Apple TV shows: the Arabic, its reading, and its meaning in
/// the languages the phone's sources carry.
final class TVQuranLibrary {
  enum Text: Hashable {
    case arabic
    case transliteration
    case translation(id: String)

    var resourceName: String {
      switch self {
      case .arabic:
        return "TVQuranArabic"
      case .transliteration:
        return "TVQuranTransliteration"
      case .translation(let id):
        return "TVQuranTranslation_\(id)"
      }
    }
  }

  static let shared = TVQuranLibrary(directory: Bundle.main.resourceURL)

  private let directory: URL?
  private var files: [Text: TVQuranTextFile] = [:]
  private var missing: Set<Text> = []

  init(directory: URL?) {
    self.directory = directory
  }

  func verses(_ text: Text, inSurah number: Int) -> [String] {
    file(for: text)?.verses(inSurah: number) ?? []
  }

  /// The ayahs of one surah with the reading and the meaning chosen. No
  /// translation is the Arabic and its reading alone.
  func ayahs(
    inSurah number: Int,
    translation: TVQuranTranslation?,
    showsTransliteration: Bool = true
  ) -> [TVQuranAyah] {
    let arabic = verses(.arabic, inSurah: number)
    let transliteration = showsTransliteration ? verses(.transliteration, inSurah: number) : []
    let meaning = translation.map { verses(.translation(id: $0.id), inSurah: number) } ?? []
    return arabic.enumerated().map { index, verse in
      TVQuranAyah(
        id: "\(number):\(index + 1)",
        surahNumber: number,
        ayahNumber: index + 1,
        arabic: verse,
        transliteration: index < transliteration.count ? transliteration[index] : "",
        translation: index < meaning.count ? meaning[index] : ""
      )
    }
  }

  /// The ayahs of one surah as a viewer reading in `language` is first
  /// shown them (`TVQuranTranslation.standard`). An Arabic reader is shown
  /// the Arabic alone.
  func ayahs(inSurah number: Int, language: String) -> [TVQuranAyah] {
    ayahs(
      inSurah: number,
      translation: TVQuranTranslation.standard(forLanguage: language),
      showsTransliteration: language != "ar"
    )
  }

  private func file(for text: Text) -> TVQuranTextFile? {
    if let file = files[text] {
      return file
    }
    guard !missing.contains(text), let directory else {
      return nil
    }
    let url = directory.appendingPathComponent("\(text.resourceName).json")
    guard let file = TVQuranTextFile(url: url) else {
      missing.insert(text)
      return nil
    }
    files[text] = file
    return file
  }
}

/// A place in the Qur'an: a surah and an ayah of it.
struct TVQuranPlace: Hashable {
  let surahNumber: Int
  let ayahNumber: Int

  /// "2:255", as it is kept on the device.
  var key: String { "\(surahNumber):\(ayahNumber)" }

  init(surahNumber: Int, ayahNumber: Int) {
    self.surahNumber = surahNumber
    self.ayahNumber = ayahNumber
  }

  /// A place read back from its key, if it is a place in the Qur'an.
  init?(key: String?, surahs: [TVQuranSurah] = TVQuranData.surahs) {
    let parts = (key ?? "").split(separator: ":").compactMap { Int($0) }
    guard
      parts.count == 2,
      let surah = surahs.first(where: { $0.number == parts[0] }),
      parts[1] >= 1, parts[1] <= surah.verseCount
    else {
      return nil
    }
    self.init(surahNumber: parts[0], ayahNumber: parts[1])
  }
}

/// The verse of the day, chosen the way the phone chooses it
/// (`QuranRepository.getDailyVerse`), so that the phone and the television
/// in one room show one verse.
enum TVQuranVerseOfTheDay {
  /// The days that have passed since the year began, as the phone counts
  /// them: the time since midnight on 1 January, in whole days. While
  /// summer time is kept that is an hour short of the clock, so for the
  /// first hour after midnight it is still the day before. The phone's
  /// count is kept as it is: the two must agree.
  static func dayIndex(for date: Date, calendar: Calendar = .current) -> Int {
    let year = calendar.component(.year, from: date)
    guard let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else {
      return 0
    }
    return max(Int((date.timeIntervalSince(start) / 86_400).rounded(.down)), 0)
  }

  /// The verse that many verses into the Qur'an, going round again at its
  /// end.
  static func place(
    dayIndex: Int,
    surahs: [TVQuranSurah] = TVQuranData.surahs
  ) -> TVQuranPlace {
    let total = surahs.reduce(0) { $0 + $1.verseCount }
    guard total > 0 else {
      return TVQuranPlace(surahNumber: 1, ayahNumber: 1)
    }
    var remaining = dayIndex % total
    for surah in surahs {
      if remaining < surah.verseCount {
        return TVQuranPlace(surahNumber: surah.number, ayahNumber: remaining + 1)
      }
      remaining -= surah.verseCount
    }
    return TVQuranPlace(surahNumber: 1, ayahNumber: 1)
  }

  static func place(on date: Date, calendar: Calendar = .current) -> TVQuranPlace {
    place(dayIndex: dayIndex(for: date, calendar: calendar))
  }
}
