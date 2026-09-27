import XCTest

/// What the focus tests share: the app, the remote, where the focus is, the
/// pane that holds it, and the record of each step.
///
/// The app names every control it can focus: its focus id
/// (`TVFocusSectionId`) is its accessibility identifier. It is opened on the
/// state a test starts from by the launch overrides in
/// `ios/PathOfNurTV/README.md`.
class TVFocusTestCase: XCTestCase {
  // As the app has them (TVTheme.railFeather, railGap), and the bottom of
  // the room the shell lays a screen out in: the screen, less the margin
  // tvOS keeps and the shell's own.
  static let reachAbove: CGFloat = 28
  static let reachBelow: CGFloat = 20
  static let contentBottom: CGFloat = 1080 - 60 - 28

  let app = XCUIApplication(bundleIdentifier: "com.shahab.pathOfNur")
  let remote = XCUIRemote.shared

  /// Where the log and the screenshots are written: TV_FOCUS_OUT, which
  /// the script passes as TEST_RUNNER_TV_FOCUS_OUT.
  static let output: URL = {
    let path = ProcessInfo.processInfo.environment["TV_FOCUS_OUT"] ?? NSTemporaryDirectory()
    let url = URL(fileURLWithPath: path, isDirectory: true)
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
  }()

  override func setUp() {
    continueAfterFailure = true
  }

  // MARK: - Driving the app

  func launch(_ environment: [String: String], arguments: [String] = []) {
    app.launchEnvironment = [
      "TV_SAMPLE_CITY": "toronto",
      "TV_SAMPLE_THEME": "midnight",
    ].merging(environment) { $1 }
    app.launchArguments = arguments
    app.launch()
    sleep(3)
  }

  var focusedElement: XCUIElement {
    app.descendants(matching: .any)
      .matching(NSPredicate(format: "hasFocus == true"))
      .firstMatch
  }

  /// The name of what is in focus.
  var focus: String {
    let element = focusedElement
    guard element.waitForExistence(timeout: 2) else { return "<none>" }
    return element.identifier.isEmpty ? "label:\(element.label)" : element.identifier
  }

  /// The ayah listening mode names in its heading: 3 for "Al Fatiha 1:3".
  var ayahInHeading: Int {
    for text in app.staticTexts.allElementsBoundByIndex {
      let label: String = text.label
      guard let colon = label.lastIndex(of: ":"), label.contains(" ") else { continue }
      if let ayah = Int(label[label.index(after: colon)...]) {
        return ayah
      }
    }
    return 0
  }

  /// What the reader's play control says it will do.
  var playControl: String {
    label(of: "quran.playback")
  }

  func label(of identifier: String) -> String {
    let element = app.buttons[identifier]
    return element.exists ? element.label : "<none>"
  }

  func value(of identifier: String) -> String {
    let element = app.buttons[identifier]
    return element.exists ? (element.value as? String ?? "") : "<none>"
  }

  @discardableResult
  func press(_ button: XCUIRemote.Button, _ times: Int = 1) -> String {
    for _ in 0..<times {
      remote.press(button)
      usleep(500_000)
    }
    return focus
  }

  /// Walks down the reader a press at a time and holds every stop to its
  /// pane.
  func walk(
    from start: (surah: Int, ayah: Int),
    toTheEndOf last: Int,
    presses: Int,
    title: String,
    language: (code: String, locale: String)?
  ) {
    launch(
      [
        "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader",
        "TV_SAMPLE_SURAH": "\(start.surah)", "TV_SAMPLE_AYAH": "\(start.ayah)",
      ],
      arguments: language.map { ["-AppleLanguages", "(\($0.code))", "-AppleLocale", $0.locale] } ?? []
    )
    log("== \(title)")
    let ending = "quran.reader.\(start.surah):\(last)"
    var stops: [String] = [focus]
    var outside = 0
    for _ in 0..<presses {
      let frame: CGRect = focusedElement.frame
      if let pane = paneOfFocus(), !Self.holds(pane, frame) {
        outside += 1
        log("FAIL  \(stops.last ?? "?") at \(Int(frame.minY))…\(Int(frame.maxY)) is outside its pane \(Int(pane.minY))…\(Int(pane.maxY))")
      }
      let next = press(.down)
      // The end of the surah, or past the last ayah asked for.
      if next == stops.last || Self.ayah(of: next) > last {
        break
      }
      stops.append(next)
    }
    note("walked", stops.joined(separator: " "))
    expect(stops.first ?? "", "quran.reader.\(start.surah):\(start.ayah)", "the walk begins where the reader was opened")
    let reached = (stops.last ?? "").hasPrefix(ending)
    log("\(reached ? "PASS" : "FAIL")  the walk reaches \(start.surah):\(last): \(stops.last ?? "")")
    XCTAssertTrue(reached, "the walk reaches \(start.surah):\(last)")
    log("\(outside == 0 ? "PASS" : "FAIL")  every stop of the walk was wholly in the pane (\(stops.count) stops)")
    XCTAssertEqual(outside, 0, "stops outside the pane")
    shot(title.lowercased().replacingOccurrences(of: " ", with: "-"))
  }

  // MARK: - Panes

  /// The pane that holds what is in focus, as it is seen: the smallest
  /// scroll view that holds its middle, less what the pane reaches past its
  /// own edges to fade in. A scroll view is never seen below where its mask
  /// ends, whatever frame it reports.
  func paneOfFocus() -> CGRect? {
    let frame: CGRect = focusedElement.frame
    let middle = CGPoint(x: frame.midX, y: frame.midY)
    var smallest: CGRect?
    for view in app.scrollViews.allElementsBoundByIndex {
      let reach: CGRect = view.frame
      // A card grows when it takes the focus, so it may stand a little
      // wider than the pane that holds it.
      let holdsAcross: Bool = reach.minX <= frame.minX + 48 && reach.maxX >= frame.maxX - 48
      let isPane: Bool = reach.height > 300 && reach.height < 1000
      guard reach.contains(middle), holdsAcross, isPane else { continue }
      if let current = smallest, current.width * current.height <= reach.width * reach.height {
        continue
      }
      smallest = reach
    }
    guard let reach = smallest else { return nil }
    let top: CGFloat = reach.minY + Self.reachAbove
    let bottom: CGFloat = min(reach.maxY - Self.reachBelow, Self.contentBottom)
    return CGRect(x: reach.minX, y: top, width: reach.width, height: bottom - top)
  }

  /// The ayah a part of the reader belongs to: 282 for
  /// "quran.reader.2:282.p3".
  static func ayah(of focus: String) -> Int {
    let place = focus.replacingOccurrences(of: "quran.reader.", with: "")
    let ayah = place.split(separator: ":").dropFirst().first ?? ""
    return Int(ayah.split(separator: ".").first ?? "") ?? 0
  }

  static func holds(_ pane: CGRect, _ frame: CGRect) -> Bool {
    frame.minY >= pane.minY - 0.5 && frame.maxY <= pane.maxY + 0.5
  }

  /// What is in focus is wholly on screen inside its pane, top to bottom.
  func expectFocusWithinPane(_ step: String) {
    let frame: CGRect = focusedElement.frame
    guard let pane = paneOfFocus() else {
      log("FAIL  \(step): no pane holds the focus at \(frame)")
      XCTFail("\(step): no pane")
      return
    }
    let fits = Self.holds(pane, frame)
    log("\(fits ? "PASS" : "FAIL")  \(step): \(Int(frame.minY))…\(Int(frame.maxY)) in a pane of \(Int(pane.minY))…\(Int(pane.maxY)), \(Int(frame.width / 1.045)) wide")
    XCTAssertTrue(fits, step)
  }

  // MARK: - The record

  /// Logs the step and holds it to what is expected.
  func expect(_ actual: String, _ expected: String, _ step: String) {
    let passed = actual == expected
    log("\(passed ? "PASS" : "FAIL")  \(step): \(actual)\(passed ? "" : "  (expected \(expected))")")
    XCTAssertEqual(actual, expected, step)
  }

  func note(_ step: String, _ value: String) {
    log("note  \(step): \(value)")
  }

  func shot(_ name: String) {
    let data = XCUIScreen.main.screenshot().pngRepresentation
    try? data.write(to: Self.output.appendingPathComponent("\(name).png"))
  }

  func log(_ line: String) {
    let url = Self.output.appendingPathComponent("focus.log")
    let data = Data((line + "\n").utf8)
    if let handle = try? FileHandle(forWritingTo: url) {
      handle.seekToEndOfFile()
      handle.write(data)
      handle.closeFile()
    } else {
      try? data.write(to: url)
    }
  }
}
