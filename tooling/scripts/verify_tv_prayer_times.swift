//
// Holds the television's prayer calculation to the phone's.
//
//   bash scripts/verify_tv_prayer_times.sh
//
// Compiled together with ios/PathOfNurTV/Data/TVPrayerCalculator.swift. Reads
// tools/tv_prayer_reference.json, the answers of the Dart package the phone
// calculates with, and asks the Swift port the same questions. Every time
// must agree to the minute.

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

if failures.isEmpty {
  print("\(checked) days agree with the phone to the minute")
  exit(0)
}
for failure in failures.prefix(40) {
  print(failure)
}
print("\(failures.count) differences in \(checked) days")
exit(1)
