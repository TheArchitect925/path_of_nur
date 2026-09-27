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

  // MARK: - The day's prayers

  func test66_onAFridayDhuhrIsJumuah() {
    launch(["TV_SAMPLE_ROUTE": "prayer", "TV_SAMPLE_DATE": "2026-10-02T13:15"])
    log("== Prayer, a Friday before Jumu’ah")
    expect(focus, "prayer.currentNext", "opens on now and next")
    expect(focusedElement.label, "Next prayer: Jumu’ah", "which is Jumu’ah")
    expect(press(.down), "prayer.schedule.dhuhr", "down lands on it")
    let card: String = focusedElement.label
    note("the card", card)
    let shown = card.hasPrefix("Jumu’ah") && card.contains("1:30")
    log("\(shown ? "PASS" : "FAIL")  the card is Jumu’ah at half past one")
    XCTAssertTrue(shown, "Jumu’ah at 1:30")
    let counts = app.staticTexts.allElementsBoundByIndex.map(\.label).contains { $0.hasPrefix("Starts in") }
    log("\(counts ? "PASS" : "FAIL")  and says how long until it starts")
    XCTAssertTrue(counts, "a countdown is shown")
    shot("66-friday")
  }

  func test67_atNightItIsIshaAndThenTahajjud() {
    launch(["TV_SAMPLE_ROUTE": "prayer", "TV_SAMPLE_DATE": "2026-09-27T23:30"])
    log("== Prayer, at night")
    expect(focusedElement.label, "Current prayer: Isha", "before the last third of the night it is Isha")
    expect(press(.down), "prayer.schedule.isha", "down lands on it")
    expect(press(.right), "prayer.schedule.tahajjud", "and the night prayer follows it")
    let card: String = focusedElement.label
    note("the card", card)
    XCTAssertTrue(card.hasPrefix("Tahajjud"), "Tahajjud is the sixth card")
    expect(press(.right), "prayer.schedule.tahajjud", "it is the last")
    shot("67-night")
  }

  func test68_inTheLastThirdOfTheNightItIsTahajjud() {
    launch(["TV_SAMPLE_ROUTE": "prayer", "TV_SAMPLE_DATE": "2026-09-28T03:30"])
    log("== Prayer, before dawn")
    note("now and next", focusedElement.label)
    // The day's list is the new day's, whose own night prayer is a day
    // away: as on the phone, before Fajr it is no prayer's time.
    expect(focusedElement.label, "Next prayer: Fajr", "before Fajr the next prayer is Fajr")
    expect(press(.down), "prayer.schedule", "down lands on it")
  }

  // MARK: - Home and the Qur'an

  func test70_theFirstTimeThereIsNoPlaceToGoOnFrom() {
    launch(["TV_SAMPLE_ROUTE": "home"])
    log("== Home, before anything has been read")
    expect(focus, "home.continueJourney", "opens on the first card")
    let card: String = focusedElement.label
    note("the first card", card)
    let starts = card.contains("Start reading") && card.contains("Al Fatiha") && !card.contains("1:")
    log("\(starts ? "PASS" : "FAIL")  the first card offers to start reading, at Al Fatiha")
    XCTAssertTrue(starts, "the first card offers to start reading")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.1:1", "pressing it opens the reader at the beginning")
  }

  func test71_thePlaceIsKept() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "36"])
    log("== The place is kept")
    expect(focus, "quran.reader.36:1", "Yaseen is open")
    expect(press(.down, 6), "quran.reader.36:7", "down six ayahs")
    app.terminate()

    launch(["TV_SAMPLE_ROUTE": "home"], keeping: true)
    expect(focus, "home.continueJourney", "opened again, on Home")
    let card: String = focusedElement.label
    note("the first card", card)
    let goesOn = card.contains("Continue reading") && card.contains("36:7")
    log("\(goesOn ? "PASS" : "FAIL")  the first card goes on from 36:7")
    XCTAssertTrue(goesOn, "the first card goes on from 36:7")
    shot("71-home-with-a-place")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.36:7", "pressing it opens the reader there")
    expectFocusWithinPane("36:7 is wholly in the pane")
    expect(press(.left), "quran.browse.36", "and Yaseen is the surah in the list")
    app.terminate()

    launch(["TV_SAMPLE_ROUTE": "quran"], keeping: true)
    expect(focus, "quran.browse.36", "opened again on the Qur’an, the list is at Yaseen")
    expect(press(.right), "quran.reader.36:7", "and the reader at 36:7")
  }

  func test72_homeListensFromThePlace() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "67", "TV_SAMPLE_AYAH": "3"])
    log("== Home, Listen")
    expect(focus, "quran.reader.67:3", "Al Mulk is open at its third ayah")
    app.terminate()

    launch(["TV_SAMPLE_ROUTE": "home"], keeping: true)
    expect(press(.right), "home.continueJourney.resume_listening", "right to Listen")
    note("the card", focusedElement.label)
    press(.select)
    sleep(3)
    expect(focus, "listening.playPause", "pressing it opens listening mode")
    press(.select)
    sleep(1)
    expect("\(ayahInHeading)", "3", "at the ayah the viewer was on")
    let names = app.staticTexts.allElementsBoundByIndex.map(\.label).contains { $0.contains("67:3") }
    log("\(names ? "PASS" : "FAIL")  the heading names 67:3")
    XCTAssertTrue(names, "the heading names 67:3")
    shot("72-listening-from-home")
  }

  func test73_homeOpensTheVerseOfTheDay() {
    launch(["TV_SAMPLE_ROUTE": "home", "TV_SAMPLE_SECTION": "home.verse"])
    log("== Home, Today’s verse")
    expect(focus, "home.verse", "opens on the verse")
    let card: String = focusedElement.label
    note("the verse", card)
    // "Al Baqarah 2:263"
    let place = card.split(separator: " ").last.map(String.init) ?? ""
    XCTAssertTrue(place.contains(":"), "the verse says where it is from")
    let frame: CGRect = focusedElement.frame
    let fits = frame.minY >= 88 - 0.5 && frame.maxY <= Self.contentBottom + 0.5
    log("\(fits ? "PASS" : "FAIL")  the verse is wholly on the screen: \(Int(frame.minY))…\(Int(frame.maxY))")
    XCTAssertTrue(fits, "the verse is wholly on the screen")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.\(place)", "pressing it opens the reader at the verse")
    expect(press(.menu), "quran.browse.\(place.split(separator: ":").first ?? "")", "Menu returns to its surah")
  }

  func test78_aLongVerseOfTheDayFitsHome() {
    launch(["TV_SAMPLE_ROUTE": "home", "TV_SAMPLE_SECTION": "home.verse", "TV_SAMPLE_DATE": "2026-10-16"])
    log("== Home, a long verse of the day")
    expect(focus, "home.verse", "opens on the verse")
    expect(focusedElement.label, "Al Baqarah 2:282", "which on 16 October is 2:282")
    let frame: CGRect = focusedElement.frame
    let fits = frame.minY >= 88 - 0.5 && frame.maxY <= Self.contentBottom + 0.5
    log("\(fits ? "PASS" : "FAIL")  the verse is wholly on the screen: \(Int(frame.minY))…\(Int(frame.maxY))")
    XCTAssertTrue(fits, "the verse is wholly on the screen")
    let says = app.staticTexts["The rest is in the reader."].exists
        || (focusedElement.label + focusedElement.debugDescription).contains("The rest is in the reader.")
    log("\(says ? "PASS" : "FAIL")  the card says that the rest is in the reader")
    XCTAssertTrue(says, "the card says there is more")
    shot("78-home-2-282")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.2:282", "pressing it opens the reader at 2:282, part 1")
  }

  func test74_theQuranShowsTheSameVerseAsHome() {
    launch(["TV_SAMPLE_ROUTE": "home", "TV_SAMPLE_SECTION": "home.verse"])
    log("== One verse of the day")
    let home = (focusedElement.label as String).split(separator: " ").last.map(String.init) ?? "?"
    app.terminate()
    launch(["TV_SAMPLE_ROUTE": "quran"])
    press(.up)
    expect(press(.right), "quran.browse.shortcut.today", "the Qur’an’s own shortcut")
    let quran = "\(focusedElement.label) \(focusedElement.value as? String ?? "")"
    note("Home", home)
    note("Qur’an", quran)
    let same = quran.contains(home)
    log("\(same ? "PASS" : "FAIL")  the Qur’an names the verse Home shows: \(home)")
    XCTAssertTrue(same, "one verse of the day")
  }

  func test75_nextAndPreviousCrossIntoTheNextSurah() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "1", "TV_SAMPLE_AYAH": "7"])
    log("== From one surah into the next")
    expect(focus, "quran.reader.1:7", "opens at the last ayah of Al Fatiha")
    press(.left)
    press(.right)
    var presses = 0
    while focus != "quran.playback" && presses < 10 {
      press(.up)
      presses += 1
    }
    expect(press(.right), "quran.playback.next", "to next")
    press(.select)
    sleep(2)
    expect(focus, "quran.playback.next", "the focus stays on next")
    let opened = app.buttons["quran.reader.2:1"].exists
    log("\(opened ? "PASS" : "FAIL")  next from the last ayah opens the surah after, at its first")
    XCTAssertTrue(opened, "Al Baqarah is open")
    expect(value(of: "quran.browse.2"), "Selected", "and the list has moved to it")
    shot("75-crossed")
    expect(press(.left, 2), "quran.playback.previous", "to previous")
    press(.select)
    sleep(2)
    let back = app.buttons["quran.reader.1:7"].exists
    log("\(back ? "PASS" : "FAIL")  previous from the first ayah opens the surah before, at its last")
    XCTAssertTrue(back, "Al Fatiha is open at its last ayah")
    expect(press(.down), "quran.reader.1:7", "down from the controls is the ayah in hand")
  }

  func test76_theEndsOfTheQuran() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SURAH": "114", "TV_SAMPLE_AYAH": "6", "TV_SAMPLE_LISTENING": "1"])
    log("== The end of the Qur’an")
    expect(focus, "listening.playPause", "listening mode is open")
    press(.select)
    sleep(1)
    expect("\(ayahInHeading)", "6", "at the last ayah")
    expect(press(.right), "listening.next", "to next")
    press(.select)
    sleep(1)
    let stays = app.staticTexts.allElementsBoundByIndex.map(\.label).contains { $0.contains("114:6") }
    log("\(stays ? "PASS" : "FAIL")  next from the last ayah of the Qur’an stays there")
    XCTAssertTrue(stays, "there is nowhere further")
  }

  func test77_theReciterChosenIsKept() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.playback"])
    log("== The reciter is kept")
    expect(focus, "quran.playback", "opens on play, beside the reader")
    expect(press(.up), "quran.playback.listening", "up to the hero")
    expect(press(.left), "quran.playback.reciter.abdulbasit", "left to Basit")
    press(.select)
    sleep(1)
    expect(value(of: "quran.playback.reciter.abdulbasit"), "Selected", "pressing it chooses Basit")
    app.terminate()

    launch(["TV_SAMPLE_ROUTE": "quran"], keeping: true)
    expect(value(of: "quran.playback.reciter.abdulbasit"), "Selected", "opened again, Basit is still chosen")
    app.terminate()

    launch(["TV_SAMPLE_ROUTE": "settings", "TV_SAMPLE_SECTION": "settings.listening"], keeping: true)
    note("Settings opens on", focus)
    // Put it back, so that the next run starts as this one did.
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.playback"], keeping: true)
    press(.up)
    expect(press(.left, 2), "quran.playback.reciter.alafasy", "left to Alafasy")
    press(.select)
    sleep(1)
    expect(value(of: "quran.playback.reciter.alafasy"), "Selected", "Alafasy, the phone’s reciter, is chosen again")
  }
}
