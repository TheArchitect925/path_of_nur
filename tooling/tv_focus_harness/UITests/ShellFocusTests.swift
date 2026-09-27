import XCTest

/// How the focus travels in the sections beside the Qur'an, and between
/// them and the rail.
///
/// Before these were written every press to the left, anywhere in a
/// section, went to the rail, and no press to the right came back from it.
final class ShellFocusTests: TVFocusTestCase {
  func test60_homeMovesAlongItsRowAndToTheRail() {
    launch(["TV_SAMPLE_ROUTE": "home"])
    log("== Home")
    expect(focus, "home.continueJourney", "opens on the first card")
    expect(press(.right), "home.continueJourney.resume_listening", "right to the second")
    expect(press(.right), "home.continueJourney.dhikr_routines", "right to the third")
    expect(press(.left), "home.continueJourney.resume_listening", "left returns to the second")
    expect(press(.left), "home.continueJourney", "left returns to the first")
    expect(press(.left), "nav.home", "left from the first goes to the rail")
    expect(press(.right), "home.continueJourney", "right from the rail returns to the section")
    var stops: [String] = []
    for _ in 0..<8 where stops.last != "home.verse" {
      stops.append(press(.down))
    }
    note("down the page", stops.joined(separator: " "))
    expect(stops.first ?? "", "home.prayer.fajr", "down from the row reaches the first prayer")
    let prayers = stops.filter { $0.hasPrefix("home.prayer.") }.count
    log("\(prayers >= 3 ? "PASS" : "FAIL")  down passes through the prayer times, a row at a time: \(prayers) rows")
    XCTAssertGreaterThanOrEqual(prayers, 3, "the prayer times are passed through")
    expect(stops.last ?? "", "home.verse", "down reaches the verse")
    expect(press(.right), "home.verse", "right from the verse stays: nothing is beside it")
    expect(press(.menu), "nav.home", "Menu steps back to the rail")
    expect(press(.down), "nav.prayer", "down the rail")
    expect(press(.up), "nav.home", "and up")
  }

  func test61_homeInArabic() {
    launch(["TV_SAMPLE_ROUTE": "home"], arguments: ["-AppleLanguages", "(ar)", "-AppleLocale", "ar_SA"])
    log("== Home in Arabic")
    expect(focus, "home.continueJourney", "opens on the first card")
    expect(press(.left), "home.continueJourney.resume_listening", "left is along the row")
    expect(press(.right), "home.continueJourney", "right returns to the first")
    expect(press(.right), "nav.home", "right from the first goes to the rail")
    expect(press(.left), "home.continueJourney", "left from the rail returns to the section")
    shot("61-home-arabic")
  }

  func test62_prayer() {
    launch(["TV_SAMPLE_ROUTE": "prayer"])
    log("== Prayer")
    expect(focus, "prayer.currentNext", "opens on now and next")
    let summary: String = focusedElement.label
    let landed = press(.down)
    let card: String = focusedElement.label
    note("the card above says", summary)
    note("down lands on", "\(landed): \(card)")
    let name = card.split(separator: ",").first.map(String.init) ?? "?"
    let matches = summary.contains(name)
    log("\(matches ? "PASS" : "FAIL")  down lands on the prayer the card above speaks of: \(name)")
    XCTAssertTrue(matches, "down lands on the prayer in hand")
    let right = press(.right)
    expect(press(.left), landed, "right and then left returns")
    note("right was", right)
    var edge = landed
    for _ in 0..<6 where !edge.hasPrefix("nav.") {
      edge = press(.left)
    }
    expect(edge, "nav.prayer", "left past the first card goes to the rail")
    let back = press(.right)
    note("right from the rail", back)
    XCTAssertTrue(back.hasPrefix("prayer."), "right from the rail returns to the section")
    expect(press(.menu), "nav.prayer", "Menu steps back to the rail")
  }

  func test63_dhikr() {
    launch(["TV_SAMPLE_ROUTE": "dhikr"])
    log("== Dhikr")
    expect(focus, "dhikr.routines", "opens on the first routine")
    expect(press(.right), "dhikr.routines.morning", "right to the second")
    expect(press(.left), "dhikr.routines", "left returns to the first")
    expect(press(.left), "nav.dhikr", "left from the first goes to the rail")
    expect(press(.right), "dhikr.routines", "right from the rail returns to the section")
    let phrases = press(.down)
    note("down from the routines", phrases)
    XCTAssertTrue(phrases.hasPrefix("dhikr.modes"), "down reaches the phrases")
    expect(press(.up), "dhikr.routines", "up returns to the routines")
    press(.select)
    sleep(2)
    let inPlayer = focus
    note("in the routine", inPlayer)
    XCTAssertFalse(inPlayer.hasPrefix("dhikr.routines"), "pressing a routine opens it")
    shot("63-routine")
    press(.menu)
    sleep(2)
    expect(focus, "dhikr.routines", "Menu closes the routine, and the focus is on its card")
    expect(press(.menu), "nav.dhikr", "Menu again steps back to the rail")
  }

  func test64_settings() {
    launch(["TV_SAMPLE_ROUTE": "settings"])
    log("== Settings")
    expect(focus, "settings.startup", "opens on the first choice")
    expect(press(.right), "settings.startup.home", "right to the second")
    expect(press(.left), "settings.startup", "left returns to the first")
    expect(press(.left), "nav.settings", "left from the first goes to the rail")
    expect(press(.right), "settings.startup", "right from the rail returns to the section")
    var stops: [String] = [focus]
    for _ in 0..<10 {
      let next = press(.down)
      if next == stops.last { break }
      stops.append(next)
    }
    note("down the page", stops.joined(separator: " "))
    let reached = Set(stops.map { $0.split(separator: ".").prefix(2).joined(separator: ".") })
    for section in ["settings.startup", "settings.prayer", "settings.appearance", "settings.listening"] {
      let found = reached.contains(section)
      log("\(found ? "PASS" : "FAIL")  down the page passes through \(section)")
      XCTAssertTrue(found, "\(section) is reached")
    }
    shot("64-settings-bottom")
    expect(press(.menu), "nav.settings", "Menu steps back to the rail")
  }

  func test65_theRail() {
    launch(["TV_SAMPLE_ROUTE": "home"])
    log("== The rail")
    expect(press(.menu), "nav.home", "Menu from a section goes to the rail, at that section")
    expect(press(.down, 2), "nav.quran", "down to Qur’an")
    expect(press(.right), "home.continueJourney", "right enters the section that is open, which is still Home")
    expect(press(.left), "nav.home", "left returns to the rail at the section that is open")
    expect(press(.down, 2), "nav.quran", "down to Qur’an again")
    press(.select)
    sleep(2)
    expect(focus, "quran.browse.1", "pressing it opens the Qur’an")
    expect(press(.menu), "nav.quran", "Menu steps back to the rail")
    expect(press(.down, 2), "nav.settings", "down to Settings")
    press(.select)
    sleep(2)
    expect(focus, "settings.startup", "pressing it opens Settings")
  }
}
