//
// Holds the television's prayer calculation to the phone's.
//
//   bash scripts/verify_tv_prayer_times.sh
//
// Compiled together with ios/PathOfNurTV/Data/TVPrayerCalculator.swift. Reads
// tools/tv_prayer_reference.json, the answers of the Dart package the phone
// calculates with, and asks the Swift port the same questions. Every time
// must agree to the minute. Then the same for the Hijri date, against
// tools/tv_hijri_reference.json.

import Foundation

struct Reference {
  let place: String
  let date: [Int]
  let method: String
  let asr: String
  let times: [Int]?
}

let path = CommandLine.arguments.count > 1
  ? CommandLine.arguments[1]
  : "tools/tv_prayer_reference.json"

guard
  let data = FileManager.default.contents(atPath: path),
  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
  let places = root["places"] as? [String: [Double]],
  let order = root["order"] as? [String],
  let rows = root["cases"] as? [[Any]]
else {
  FileHandle.standardError.write(Data("cannot read \(path)\n".utf8))
  exit(2)
}

var failures: [String] = []
var checked = 0

for row in rows {
  guard
    row.count == 5,
    let place = row[0] as? String,
    let date = row[1] as? [Int],
    let methodKey = row[2] as? String,
    let asrKey = row[3] as? String,
    let coordinates = places[place],
    let method = TVPrayerMethod(rawValue: methodKey),
    let asr = TVAsrRule(rawValue: asrKey)
  else {
    failures.append("unreadable case: \(row)")
    continue
  }
  let expected = row[4] as? [Int]

  let day = TVPrayerCalculator.day(
    year: date[0], month: date[1], day: date[2],
    latitude: coordinates[0], longitude: coordinates[1],
    method: method, asr: asr
  )
  let actual = day.map { day in
    [day.fajr, day.sunrise, day.dhuhr, day.asr, day.maghrib, day.isha]
      .map { Int($0.timeIntervalSince1970 / 60) }
  }
  checked += 1

  let label = "\(place) \(date[0])-\(date[1])-\(date[2]) \(methodKey) \(asrKey)"
  switch (expected, actual) {
  case (nil, nil):
    continue
  case let (expected?, actual?):
    for (index, name) in order.enumerated() where expected[index] != actual[index] {
      failures.append(
        "\(label): \(name) is \(actual[index] - expected[index]) min from the phone"
      )
    }
  default:
    failures.append("\(label): one side has times and the other has none")
  }
}

// The Hijri date, day by day, against the phone's
// (tools/tv_hijri_reference.json).
let hijriPath = CommandLine.arguments.count > 2
  ? CommandLine.arguments[2]
  : "tools/tv_hijri_reference.json"
var named = 0
var systemDiffers = 0
if
  let data = FileManager.default.contents(atPath: hijriPath),
  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
  let days = root["days"] as? [String]
{
  var gregorian = Calendar(identifier: .gregorian)
  gregorian.timeZone = TimeZone(identifier: "UTC")!
  // The system's own Umm al-Qura calendar, which the table was copied
  // from, on the system this runs on: they differ only if that calendar has
  // been revised since (scripts/verify_hijri_table.sh).
  var system = Calendar(identifier: .islamicUmmAlQura)
  system.timeZone = gregorian.timeZone
  let first = gregorian.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 12))!
  for (offset, expected) in days.enumerated() {
    let date = gregorian.date(byAdding: .day, value: offset, to: first)!
    let hijri = TVHijriCalendar.date(of: date, in: gregorian)
    let actual = "\(hijri.year)-\(hijri.month)-\(hijri.day)"
    if actual != expected {
      let day = gregorian.dateComponents([.year, .month, .day], from: date)
      failures.append(
        "Hijri: \(day.year!)-\(day.month!)-\(day.day!) is \(actual), the phone says \(expected)"
      )
    }
    let bySystem = system.dateComponents([.year, .month, .day], from: date)
    if "\(bySystem.year!)-\(bySystem.month!)-\(bySystem.day!)" != expected {
      systemDiffers += 1
    }
    named += 1
  }
} else {
  failures.append("cannot read \(hijriPath)")
}

// The day laid out, and the prayer it is time for, against the phone's
// (tools/tv_prayer_schedule_reference.json).
let schedulePath = CommandLine.arguments.count > 3
  ? CommandLine.arguments[3]
  : "tools/tv_prayer_schedule_reference.json"
var laidOut = 0
var moments = 0
if
  let data = FileManager.default.contents(atPath: schedulePath),
  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
  let cases = root["cases"] as? [[String: Any]],
  let method = TVPrayerMethod(rawValue: root["method"] as? String ?? ""),
  let asr = TVAsrRule(rawValue: root["asr"] as? String ?? "")
{
  var utc = Calendar(identifier: .gregorian)
  utc.timeZone = TimeZone(identifier: "UTC")!
  for entry in cases {
    guard
      let place = entry["place"] as? String,
      let coordinates = entry["coordinates"] as? [Double],
      let date = entry["date"] as? [Int],
      let expected = entry["windows"] as? [[Any]],
      let expectedMoments = entry["moments"] as? [[Any]],
      let noon = utc.date(from: DateComponents(year: date[0], month: date[1], day: date[2], hour: 12)),
      let after = utc.date(byAdding: .day, value: 1, to: noon)
    else {
      failures.append("schedule: unreadable case")
      continue
    }
    let label = "\(place) \(date[0])-\(date[1])-\(date[2])"
    let next = utc.dateComponents([.year, .month, .day], from: after)
    guard
      let day = TVPrayerCalculator.day(
        year: date[0], month: date[1], day: date[2],
        latitude: coordinates[0], longitude: coordinates[1],
        method: method, asr: asr
      ),
      let following = TVPrayerCalculator.day(
        year: next.year!, month: next.month!, day: next.day!,
        latitude: coordinates[0], longitude: coordinates[1],
        method: method, asr: asr
      )
    else {
      failures.append("schedule: \(label) has no times")
      continue
    }
    let windows = TVPrayerSchedule.windows(day: day, following: following)
    laidOut += 1
    if windows.count != expected.count {
      failures.append("schedule: \(label) has \(windows.count) windows, the phone \(expected.count)")
      continue
    }
    for (window, row) in zip(windows, expected) {
      let id = row[0] as? String ?? ""
      let start = row[1] as? Int ?? 0
      let end = row[2] as? Int ?? 0
      if window.id != id
        || Int(window.start.timeIntervalSince1970) != start
        || Int(window.end.timeIntervalSince1970) != end {
        failures.append(
          "schedule: \(label) \(window.id) is \(Int(window.start.timeIntervalSince1970))…\(Int(window.end.timeIntervalSince1970)), the phone says \(id) \(start)…\(end)"
        )
      }
    }
    for row in expectedMoments {
      let now = Date(timeIntervalSince1970: Double(row[0] as? Int ?? 0))
      let current = row[1] as? String
      let nextID = row[2] as? String ?? ""
      let nextStart = row[3] as? Int ?? 0
      guard let context = TVPrayerSchedule.context(windows, at: now) else {
        failures.append("schedule: \(label) has no context")
        continue
      }
      moments += 1
      if context.current != current
        || context.next != nextID
        || Int(context.nextStart.timeIntervalSince1970) != nextStart {
        failures.append(
          "schedule: \(label) at \(Int(now.timeIntervalSince1970)) is \(context.current ?? "none") then \(context.next) at \(Int(context.nextStart.timeIntervalSince1970)), the phone says \(current ?? "none") then \(nextID) at \(nextStart)"
        )
      }
    }
  }
} else {
  failures.append("cannot read \(schedulePath)")
}

// Jumu'ah is shown at half past one by the clock of the place.
do {
  var toronto = Calendar(identifier: .gregorian)
  toronto.timeZone = TimeZone(identifier: "America/Toronto")!
  let friday = toronto.date(from: DateComponents(year: 2026, month: 10, day: 2, hour: 13, minute: 30))!
  let dhuhr = toronto.date(from: DateComponents(year: 2026, month: 10, day: 2, hour: 13, minute: 7))!
  let asr = toronto.date(from: DateComponents(year: 2026, month: 10, day: 2, hour: 16, minute: 20))!
  let shown = TVPrayerSchedule.showingJumuah(
    [TVPrayerWindow(id: "dhuhr", start: dhuhr, end: asr), TVPrayerWindow(id: "asr", start: asr, end: asr.addingTimeInterval(3600))],
    at: friday
  )
  if shown[0].start != friday || shown[0].end != asr || shown[1].start != asr {
    failures.append("schedule: Jumu’ah is not shown at its own hour, to the end of Dhuhr")
  }
  if TVPrayerSchedule.context(shown, at: dhuhr.addingTimeInterval(600))?.current != nil {
    failures.append("schedule: between Dhuhr and Jumu’ah on a Friday it is no prayer’s time, as on the phone")
  }
}

// The sky, against the phone's (tools/tv_sky_phase_reference.json).
let skyPath = CommandLine.arguments.count > 4
  ? CommandLine.arguments[4]
  : "tools/tv_sky_phase_reference.json"
var skies = 0
if
  let data = FileManager.default.contents(atPath: skyPath),
  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
  let cases = root["cases"] as? [[String: Any]]
{
  for entry in cases {
    guard
      let fajr = entry["fajr"] as? Int,
      let maghrib = entry["maghrib"] as? Int,
      let isha = entry["isha"] as? Int,
      let rows = entry["moments"] as? [[Any]]
    else {
      failures.append("sky: unreadable case")
      continue
    }
    let times = TVSkyPhase.Times(
      fajr: Date(timeIntervalSince1970: Double(fajr)),
      maghrib: Date(timeIntervalSince1970: Double(maghrib)),
      isha: Date(timeIntervalSince1970: Double(isha))
    )
    for row in rows {
      let moment = row[0] as? Int ?? 0
      let expected = row[1] as? String ?? ""
      let phase = TVSkyPhase.at(Date(timeIntervalSince1970: Double(moment)), times: times)
      skies += 1
      if phase.rawValue != expected {
        failures.append("sky: at \(moment) it is \(phase.rawValue), the phone says \(expected)")
      }
    }
  }
} else {
  failures.append("cannot read \(skyPath)")
}

// Where there are no prayer times, by the hour of the place.
do {
  var toronto = Calendar(identifier: .gregorian)
  toronto.timeZone = TimeZone(identifier: "America/Toronto")!
  for (hour, minute, expected) in [(4, 59, "night"), (5, 0, "dawn"), (7, 59, "dawn"), (8, 0, "day"), (17, 29, "day"), (17, 30, "maghrib"), (20, 59, "maghrib"), (21, 0, "night")] {
    let now = toronto.date(from: DateComponents(year: 2026, month: 9, day: 27, hour: hour, minute: minute))!
    let phase = TVSkyPhase.at(now, times: nil, calendar: toronto)
    if phase.rawValue != expected {
      failures.append("sky: by the hour, \(hour):\(minute) is \(phase.rawValue), not \(expected)")
    }
  }
}

if failures.isEmpty {
  print("\(checked) days agree with the phone to the minute")
  print("\(skies) moments of the sky are the phone's")
  print("\(laidOut) days are laid out as the phone lays them out, and \(moments) moments in them fall to the same prayer")
  print("\(named) days are named in the Hijri year as the phone names them")
  print("  (this system's Umm al-Qura calendar names \(systemDiffers) of them otherwise)")
  exit(0)
}
for failure in failures.prefix(40) {
  print(failure)
}
print("\(failures.count) differences in \(checked) days")
exit(1)
