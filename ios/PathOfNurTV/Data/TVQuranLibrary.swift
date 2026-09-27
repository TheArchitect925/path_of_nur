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

/// The Qur'an the Apple TV shows: the Arabic, its reading, and its meaning in
/// the languages the phone's sources carry.
final class TVQuranLibrary {
  enum Text: Hashable {
    case arabic
    case transliteration
    case translation(language: String)

    var resourceName: String {
      switch self {
      case .arabic:
        return "TVQuranArabic"
      case .transliteration:
        return "TVQuranTransliteration"
      case .translation(let language):
        return "TVQuranTranslation_\(language)"
      }
    }
  }

  /// English is what a language without a translation of its own falls back to.
  static let translationLanguages = ["en", "fr", "ur"]

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

  /// The ayahs of one surah as a viewer reading in `language` is shown
  /// them. The translation is in that language where the phone's sources
  /// carry one, and in English where they do not. An Arabic reader is shown
  /// the Arabic alone.
  func ayahs(inSurah number: Int, language: String) -> [TVQuranAyah] {
    let arabic = verses(.arabic, inSurah: number)
    let readsArabic = language == "ar"
    let transliteration = readsArabic ? [] : verses(.transliteration, inSurah: number)
    let translation = readsArabic
      ? []
      : verses(Self.translation(forLanguage: language), inSurah: number)
    return arabic.enumerated().map { index, verse in
      TVQuranAyah(
        id: "\(number):\(index + 1)",
        surahNumber: number,
        ayahNumber: index + 1,
        arabic: verse,
        transliteration: index < transliteration.count ? transliteration[index] : "",
        translation: index < translation.count ? translation[index] : ""
      )
    }
  }

  /// The translation a viewer reading in `language` is shown.
  static func translation(forLanguage language: String) -> Text {
    .translation(
      language: translationLanguages.contains(language) ? language : "en"
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
