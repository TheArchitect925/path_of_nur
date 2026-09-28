// Writes the Umm al-Qura calendar as a table the phone and the television
// both read, and holds the table that is written to the calendar.
//
//   bash scripts/verify_hijri_table.sh           holds the files to the calendar
//   bash scripts/verify_hijri_table.sh --write   writes them
//
// The calendar is the system's own (`Calendar(identifier: .islamicUmmAlQura)`,
// which is ICU's islamic-umalqura). It is a table of observed and announced
// months and not a rule, so it cannot be worked out: it is copied. Dart has
// no such calendar, and the television is to name the day as the phone does
// whatever system it runs on, so both carry the copy.
//
// Three files are written:
//
//   lib/shared/utils/umm_al_qura_table.dart      the phone's table
//   ios/PathOfNurTV/Data/TVUmmAlQuraTable.swift  the television's
//   tools/hijri_umm_al_qura_reference.json       what the calendar answers,
//     day by day from 2020 to 2040 and for the first of every month of the
//     table, for test/shared/utils/hijri_date_utils_test.dart to hold the
//     phone's reading of the table to

import Foundation

let firstYear = 1300
let lastYear = 1600
let referenceFrom = (year: 2020, month: 1, day: 1)
let referenceTo = (year: 2040, month: 12, day: 31)

let dartPath = "lib/shared/utils/umm_al_qura_table.dart"
let swiftPath = "ios/PathOfNurTV/Data/TVUmmAlQuraTable.swift"
let referencePath = "tools/hijri_umm_al_qura_reference.json"

let utc = TimeZone(identifier: "UTC")!
var islamic = Calendar(identifier: .islamicUmmAlQura)
islamic.timeZone = utc
var gregorian = Calendar(identifier: .gregorian)
gregorian.timeZone = utc

/// Days from 1 January 1970 to the day `date` falls on.
func epochDay(of date: Date) -> Int {
  Int((date.timeIntervalSince1970 / 86_400).rounded(.down))
}

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data((message + "\n").utf8))
  exit(1)
}

// MARK: - The calendar, read

var firstDay = 0
var years: [Int] = []
var monthStarts: [Int] = []
var expected: Int?

for year in firstYear...lastYear {
  var months = 0
  for month in 1...12 {
    guard
      let first = islamic.date(
        from: DateComponents(year: year, month: month, day: 1, hour: 12)
      ),
      let length = islamic.range(of: .day, in: .month, for: first)?.count
    else {
      fail("the calendar has no \(month)/\(year)")
    }
    guard length == 29 || length == 30 else {
      fail("\(month)/\(year) has \(length) days")
    }
    let start = epochDay(of: first)
    if let expected, expected != start {
      fail("\(month)/\(year) begins on day \(start), and the month before it ends on \(expected - 1)")
    }
    expected = start + length
    if year == firstYear && month == 1 {
      firstDay = start
    }
    if length == 30 {
      months |= 1 << (month - 1)
    }
    monthStarts.append(start)
  }
  years.append(months)
}

// MARK: - The files

func hex(_ value: Int) -> String {
  "0x" + String(value, radix: 16, uppercase: true).leftPadded(to: 3)
}

extension String {
  func leftPadded(to length: Int) -> String {
    String(repeating: "0", count: max(length - count, 0)) + self
  }
}

/// A year to a line, which is how `dart format` leaves a list that ends in
/// a comma: the file is written as the formatter would have it, so that
/// formatting it does not make it another file.
func rows(_ values: [Int], indent: String) -> String {
  values.enumerated().map { index, months in
    "\(indent)\(hex(months)), // \(firstYear + index)"
  }.joined(separator: "\n")
}

let dart = """
// GENERATED FILE — do not edit by hand.
// Source: the system's Umm al-Qura calendar (ICU's islamic-umalqura).
// Regenerate: bash scripts/verify_hijri_table.sh --write

/// The first Hijri year of the table, and the last.
const int ummAlQuraFirstYear = \(firstYear);
const int ummAlQuraLastYear = \(lastYear);

/// The day 1 Muharram [ummAlQuraFirstYear] fell on, counted from
/// 1 January 1970.
const int ummAlQuraFirstDay = \(firstDay);

/// The months of each year, a year to a number. Bit 0 is Muharram, and a bit
/// that is set is a month of 30 days; the others have 29.
const List<int> ummAlQuraMonths = <int>[
\(rows(years, indent: "  "))
];

"""

let swift = """
// GENERATED FILE — do not edit by hand.
// Source: the system's Umm al-Qura calendar (ICU's islamic-umalqura).
// Regenerate: bash scripts/verify_hijri_table.sh --write

import Foundation

/// The Umm al-Qura calendar as the phone carries it
/// (`lib/shared/utils/umm_al_qura_table.dart`), so that the television names
/// the day as the phone does on whatever system it runs.
enum TVUmmAlQuraTable {
  /// The first Hijri year of the table, and the last.
  static let firstYear = \(firstYear)
  static let lastYear = \(lastYear)

  /// The day 1 Muharram `firstYear` fell on, counted from 1 January 1970.
  static let firstDay = \(firstDay)

  /// The months of each year, a year to a number. Bit 0 is Muharram, and a
  /// bit that is set is a month of 30 days; the others have 29.
  static let months: [Int] = [
\(rows(years, indent: "    "))
  ]
}

"""

var reference = "{\n"
reference += "  \"source\": \"Calendar(identifier: .islamicUmmAlQura)\",\n"
reference += "  \"from\": \"\(referenceFrom.year)-\(String(referenceFrom.month).leftPadded(to: 2))-\(String(referenceFrom.day).leftPadded(to: 2))\",\n"
reference += "  \"days\": [\n"
let from = gregorian.date(
  from: DateComponents(
    year: referenceFrom.year, month: referenceFrom.month, day: referenceFrom.day, hour: 12
  )
)!
let to = gregorian.date(
  from: DateComponents(
    year: referenceTo.year, month: referenceTo.month, day: referenceTo.day, hour: 12
  )
)!
var day = from
var days: [String] = []
while day <= to {
  let named = islamic.dateComponents([.year, .month, .day], from: day)
  days.append("    \"\(named.year!)-\(named.month!)-\(named.day!)\"")
  day = day.addingTimeInterval(86_400)
}
reference += days.joined(separator: ",\n") + "\n  ],\n"
reference += "  \"firstYear\": \(firstYear),\n"
reference += "  \"monthStarts\": [\n"
reference += stride(from: 0, to: monthStarts.count, by: 12).map { start in
  "    " + monthStarts[start..<start + 12].map(String.init).joined(separator: ", ")
}.joined(separator: ",\n")
reference += "\n  ]\n}\n"

// MARK: - Written, or held

let files = [(dartPath, dart), (swiftPath, swift), (referencePath, reference)]

if CommandLine.arguments.contains("--write") {
  for (path, contents) in files {
    do {
      try contents.write(toFile: path, atomically: true, encoding: .utf8)
    } catch {
      fail("cannot write \(path): \(error.localizedDescription)")
    }
    print("wrote \(path)")
  }
} else {
  var stale: [String] = []
  for (path, contents) in files {
    guard let written = FileManager.default.contents(atPath: path) else {
      stale.append("\(path) is missing")
      continue
    }
    if written != Data(contents.utf8) {
      stale.append("\(path) is not what the calendar says")
    }
  }
  if !stale.isEmpty {
    stale.forEach { FileHandle.standardError.write(Data(($0 + "\n").utf8)) }
    fail(
      "The system's Umm al-Qura calendar and the table do not agree. If the "
        + "calendar has been revised, run bash scripts/verify_hijri_table.sh --write "
        + "and read the difference before it is committed."
    )
  }
}

print(
  "\(years.count) years of the Umm al-Qura calendar, \(firstYear) to \(lastYear), "
    + "and \(days.count) days named by it"
)
