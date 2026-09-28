//
// Holds the television's Qur'an reader to the files it reads, and the way it
// sets a long ayah to the ayah itself.
//
//   bash scripts/verify_tv_quran_library.sh
//
// Compiled together with the app's own TVQuranLibrary, TVQuranData,
// TVQuranAyahLayout and models.
//
// 1. The library reads a surah by its line. This reads each whole file the
//    ordinary way and asks the library for every surah in turn. The two must
//    agree verse for verse, and every surah must be as long as the list of
//    surahs says it is.
// 2. An ayah too tall for the room it is read in is set in parts. Every ayah
//    is planned here, in every language, for the reader and for listening
//    mode. The parts put back together must be the ayah, word for word, and
//    no part may be taller than its room.
//
// 3. The verse of the day is chosen as the phone chooses it. The phone's
//    answer for every day of a year is in
//    tools/tv_verse_of_the_day_reference.json, written by the phone's own
//    repository, and the Swift must give the same.
//
// test/features/tvos/tvos_quran_parity_test.dart holds the files themselves
// to the phone's sources.

import AppKit
import CoreText
import Foundation

let arguments = CommandLine.arguments
let directory = URL(
  fileURLWithPath: arguments.count > 1 ? arguments[1] : "ios/PathOfNurTV/Data/Quran"
)
let fonts = URL(fileURLWithPath: arguments.count > 2 ? arguments[2] : "assets/fonts")
let verseOfTheDay = arguments.count > 3 ? arguments[3] : "tools/tv_verse_of_the_day_reference.json"

let texts: [TVQuranLibrary.Text] =
  [.arabic, .transliteration]
  + TVQuranTranslation.all.map { .translation(id: $0.id) }

var failures: [String] = []

// MARK: - 1. The library against the files

var verses = 0

if TVQuranData.surahs.map(\.number) != Array(1...TVQuranTextFile.surahCount) {
  failures.append("the list of surahs is not 1 to \(TVQuranTextFile.surahCount) in order")
}

let library = TVQuranLibrary(directory: directory)

for text in texts {
  let name = "\(text.resourceName).json"
  guard
    let data = FileManager.default.contents(
      atPath: directory.appendingPathComponent(name).path
    ),
    let whole = try? JSONSerialization.jsonObject(with: data) as? [[String]]
  else {
    failures.append("\(name): cannot be read as a whole")
    continue
  }
  if whole.count != TVQuranData.surahs.count {
    failures.append("\(name): \(whole.count) surahs")
    continue
  }
  for surah in TVQuranData.surahs {
    let read = library.verses(text, inSurah: surah.number)
    if read != whole[surah.number - 1] {
      failures.append("\(name): surah \(surah.number) is not read as it is written")
    }
    if read.count != surah.verseCount {
      failures.append(
        "\(name): surah \(surah.number) has \(read.count) verses, the list says \(surah.verseCount)"
      )
    }
    if read.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
      failures.append("\(name): surah \(surah.number) has an empty verse")
    }
    verses += read.count
  }
}

for number in [0, -1, TVQuranTextFile.surahCount + 1] {
  if !library.verses(.arabic, inSurah: number).isEmpty {
    failures.append("surah \(number) does not exist and was read")
  }
}
if TVQuranTranslation.standard(forLanguage: "de")?.id != "en" {
  failures.append("a language without a translation does not fall back to English")
}
if TVQuranTranslation.standard(forLanguage: "ar") != nil {
  failures.append("an Arabic reader is given a translation they did not choose")
}
if Set(TVQuranTranslation.all.map(\.id)).count != TVQuranTranslation.all.count {
  failures.append("two translations share an id")
}

// MARK: - 2. The parts against the ayah

for name in ["AmiriQuran-Regular.ttf", "Figtree-Medium.ttf"] {
  var error: Unmanaged<CFError>?
  let url = fonts.appendingPathComponent(name) as CFURL
  if !CTFontManagerRegisterFontsForURL(url, .process, &error) {
    failures.append("\(name): cannot be registered, so nothing can be measured")
  }
}

// The rooms as they are on the television: 1920 by 1080, less the rail and
// the margins. The app measures them where it stands; these are what it
// finds (TVTheme.focusScale, railBleed less railFeather, and the frames
// scripts/verify_tv_focus.sh reads back from the simulator).
let focusScale: CGFloat = 1.045
let inset: CGFloat = 16
let pane = CGSize(width: 692, height: 676)
let stage = CGSize(width: 1632, height: 692)

func joined(_ parts: [TVQuranAyahPart], _ text: KeyPath<TVQuranAyahPart, String>) -> String {
  parts.map { $0[keyPath: text] }.filter { !$0.isEmpty }.joined(separator: " ")
}

func check(
  _ parts: [TVQuranAyahPart],
  of ayah: TVQuranAyah,
  metrics: TVQuranAyahMetrics,
  in room: String
) {
  let label = "\(room) \(ayah.id)"
  if parts.isEmpty {
    failures.append("\(label): no parts")
    return
  }
  if joined(parts, \.arabic) != ayah.arabic {
    failures.append("\(label): the Arabic in parts is not the Arabic")
  }
  if joined(parts, \.transliteration) != ayah.transliteration {
    failures.append("\(label): the reading in parts is not the reading")
  }
  if joined(parts, \.translation) != ayah.translation {
    failures.append("\(label): the meaning in parts is not the meaning")
  }
  if parts.map(\.index) != Array(0..<parts.count)
    || parts.contains(where: { $0.count != parts.count })
    || Set(parts.map(\.id)).count != parts.count
    || parts[0].id != ayah.id {
    failures.append("\(label): the parts are not numbered in order")
  }
  for part in parts {
    let piece = TVQuranAyah(
      id: part.id,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      arabic: part.arabic,
      transliteration: part.transliteration,
      translation: part.translation
    )
    let height = TVQuranAyahPlanner.height(of: piece, metrics: metrics)
    if height > metrics.maxHeight {
      failures.append(
        "\(label): part \(part.index + 1) stands \(Int(height)) in a room of \(Int(metrics.maxHeight))"
      )
    }
  }
}

var planned = 0
var inParts: [String: Int] = [:]
var mostParts: [String: (count: Int, ayah: String)] = [:]

func tally(_ room: String, _ parts: [TVQuranAyahPart], _ ayah: TVQuranAyah) {
  planned += 1
  if parts.count > 1 {
    inParts[room, default: 0] += 1
  }
  if parts.count > (mostParts[room]?.count ?? 0) {
    mostParts[room] = (parts.count, ayah.id)
  }
}

// Every translation a viewer can choose, with the reading, and the Arabic
// alone. The interface's language sets only the Urdu line spacing.
let readings: [(name: String, translation: TVQuranTranslation?, language: String)] =
  TVQuranTranslation.all.map { ($0.id, $0, $0.id == "ur" ? "ur" : "en") }
  + [("arabic alone", nil, "ar")]
for (name, translation, language) in readings {
  for surah in TVQuranData.surahs {
    let ayahs = library.ayahs(
      inSurah: surah.number,
      translation: translation,
      showsTransliteration: language != "ar"
    )
    if ayahs.count != surah.verseCount {
      failures.append("\(name): surah \(surah.number) gives \(ayahs.count) ayahs")
    }
    let reader = TVQuranAyahMetrics.reader(
      pane: pane,
      inset: inset,
      focusScale: focusScale,
      language: language
    )
    for ayah in ayahs {
      let read = TVQuranAyahPlanner.plan(ayah, metrics: reader)
      check(read, of: ayah, metrics: reader, in: "reader \(name)")
      tally("reader \(name)", read, ayah)

      let heard = TVQuranAyahPlanner.listeningPlan(
        for: ayah,
        stage: stage,
        inset: inset,
        focusScale: focusScale,
        language: language
      )
      check(heard.parts, of: ayah, metrics: heard.metrics, in: "listening \(name)")
      tally("listening \(name)", heard.parts, ayah)
    }
  }
}

// MARK: - 3. The verse of the day against the phone's

var days = 0
if
  let data = FileManager.default.contents(atPath: verseOfTheDay),
  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
  let byDay = root["byDayIndex"] as? [String]
{
  for (day, expected) in byDay.enumerated() {
    let place = TVQuranVerseOfTheDay.place(dayIndex: day)
    if place.key != expected {
      failures.append("verse of the day: day \(day) is \(place.key), the phone says \(expected)")
    }
    days += 1
  }
} else {
  failures.append("\(verseOfTheDay): cannot be read")
}
if TVQuranVerseOfTheDay.place(dayIndex: 6236).key != "1:1" {
  failures.append("verse of the day: the Qur’an does not go round again at its end")
}

// The days counted, in a place that changes its clocks. The phone counts
// the time since the year began in whole days, so in summer time the first
// hour after midnight is still the day before.
var toronto = Calendar(identifier: .gregorian)
toronto.timeZone = TimeZone(identifier: "America/Toronto")!
func moment(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
  toronto.date(
    from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
  )!
}
let counted: [(Date, Int, String)] = [
  (moment(2026, 1, 1, 0, 0), 0, "midnight as the year begins"),
  (moment(2026, 1, 1, 23, 59), 0, "the last minute of the first day"),
  (moment(2026, 1, 2, 0, 0), 1, "midnight, in winter time"),
  (moment(2026, 9, 27, 12, 0), 269, "noon on 27 September"),
  (moment(2026, 7, 1, 0, 30), 180, "half past midnight in summer time, still the day before"),
  (moment(2026, 7, 1, 1, 0), 181, "one in the morning in summer time"),
  (moment(2028, 12, 31, 12, 0), 365, "the last day of a leap year"),
]
for (date, expected, what) in counted {
  let index = TVQuranVerseOfTheDay.dayIndex(for: date, calendar: toronto)
  if index != expected {
    failures.append("verse of the day: \(what) is day \(index), not \(expected)")
  }
}

for (key, isPlace) in [("2:255", true), ("2:287", false), ("115:1", false), ("0:1", false), ("", false), ("abc", false), ("114:6", true)] {
  if (TVQuranPlace(key: key) != nil) != isPlace {
    failures.append("place: “\(key)” is read \(isPlace ? "as no place" : "as a place")")
  }
}

// MARK: - 4. The document shared with the phone

if let raw = try? String(contentsOfFile: "tools/tv_quran_shared_reference.json", encoding: .utf8) {
  let shared = TVQuranSharedState(json: raw)
  var utc = Calendar(identifier: .gregorian)
  utc.timeZone = TimeZone(identifier: "UTC")!
  func moment(_ hour: Int, _ minute: Int = 0, _ second: Int = 0) -> Date {
    utc.date(from: DateComponents(year: 2026, month: 9, day: 27, hour: hour, minute: minute, second: second))!
  }
  if shared.place != "36:12" || shared.bookmarks != ["67:1", "2:255"]
    || shared.reciter != "husary" || shared.translation != "ur.urdu" {
    failures.append("shared: the phone's document is not read as the phone wrote it")
  }
  if let placeAt = shared.placeAt {
    if abs(placeAt.timeIntervalSince(moment(11, 30, 5)) - 0.25) > 0.001 {
      failures.append("shared: the place's moment is read as \(placeAt)")
    }
  } else {
    failures.append("shared: the place's moment cannot be read")
  }
  if shared.bookmarksAt != moment(11) || shared.reciterAt != moment(10) || shared.translationAt != moment(9) {
    failures.append("shared: a moment is not read as the phone wrote it")
  }
  if TVQuranSharedState(json: shared.json) != shared {
    failures.append("shared: the document does not survive being written again")
  }
  let newer = TVQuranSharedState(reciter: "sudais", reciterAt: moment(12))
  if shared.merged(with: newer).reciter != "sudais" || newer.merged(with: shared).place != "36:12" {
    failures.append("shared: the newer change of a field does not win")
  }
  if case .some(.some(let urdu)) = TVQuranTranslationCodes.translation(for: "ur.urdu"), urdu.id == "ur" {
  } else {
    failures.append("shared: ur.urdu is not the Urdu translation")
  }
  for translation in TVQuranTranslation.all {
    if case .some(.some(let back)) = TVQuranTranslationCodes.translation(
      for: TVQuranTranslationCodes.code(for: translation)
    ), back == translation {
      continue
    }
    failures.append("shared: \(translation.id) does not come back from its code")
  }
} else {
  failures.append("tools/tv_quran_shared_reference.json: cannot be read")
}

if failures.isEmpty {
  print("Apple TV Qur’an: \(verses) verses read across \(texts.count) files, a surah at a time.")
  print("Apple TV Qur’an: the verse of the day is the phone’s on all \(days) days.")
  print("Apple TV Qur’an: the document shared with the phone is read and written as the phone does.")
  print("Apple TV Qur’an: \(planned) ayahs set, every word in place, every part within its room.")
  for room in inParts.keys.sorted() {
    let most = mostParts[room]!
    print("  \(room): \(inParts[room]!) in parts, at most \(most.count) (\(most.ayah))")
  }
  exit(0)
}

for failure in failures.prefix(40) {
  FileHandle.standardError.write(Data("\(failure)\n".utf8))
}
FileHandle.standardError.write(Data("\(failures.count) failures\n".utf8))
exit(1)
