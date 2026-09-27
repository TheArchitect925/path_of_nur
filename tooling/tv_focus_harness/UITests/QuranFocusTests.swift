import XCTest

/// How the focus travels in the Apple TV Qur'an, checked by pressing the
/// remote's buttons in the simulator and reading back where the focus is.
///
///   bash scripts/verify_tv_focus.sh
///
/// What this cannot show is the touch surface: a swipe, its momentum, the
/// feel of a long list under the thumb. That wants a person with a remote.
final class QuranFocusTests: TVFocusTestCase {
  // MARK: - The list and the reader

  func test01_theTwoPanesHandTheFocusToEachOther() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== The list and the reader")
    expect(focus, "quran.browse.1", "opens on the selected surah")
    expect(press(.down, 2), "quran.browse.3", "down twice in the list")
    expect(press(.right), "quran.reader.1:1", "right from the list lands on the ayah in hand")
    expect(press(.down, 2), "quran.reader.1:3", "down twice in the reader")
    expect(press(.left), "quran.browse.1", "left from the reader returns to the selected surah")
    expect(press(.right), "quran.reader.1:3", "right again returns to the viewer's place")
    expect(press(.menu), "quran.browse.1", "Menu from the reader returns to the selected surah")
    expect(press(.down, 2), "quran.browse.3", "down to Al Imran")
    press(.select)
    sleep(1)
    expect(focus, "quran.reader.3:1", "choosing a surah moves into the reader at its first ayah")
    shot("01-al-imran-chosen")
    expect(press(.menu), "quran.browse.3", "Menu returns to the surah now selected")
    expect(press(.left), "nav.quran", "left from the list goes to the rail")
    press(.right)
    sleep(1)
    expect(focus, "quran.browse.3", "right from the rail returns to the selected surah")
  }

  func test02_deepInTheListTheReaderIsBesideIt() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== Deep in the list")
    expect(press(.down, 60), "quran.browse.61", "down sixty surahs")
    expectFocusWithinPane("surah 61 is wholly in the list")
    shot("02-list-at-61")
    expect(press(.right), "quran.reader.1:1", "right from deep in the list finds the reader")
    expect(press(.left), "quran.browse.1", "left returns to the selected surah")
    sleep(1)
    expect(focus, "quran.browse.1", "and stays there")
    expect(press(.down, 30), "quran.browse.31", "down thirty surahs")
    expect(press(.left), "nav.quran", "left from deep in the list goes to the rail")
    press(.right)
    sleep(1)
    expect(focus, "quran.browse.1", "back from the rail to the selected surah")
  }

  func test03_deepInTheReaderTheListIsBesideIt() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "2"])
    log("== Deep in the reader")
    expect(focus, "quran.reader.2:1", "opens in the reader at the first ayah")
    let deep = press(.down, 45)
    note("after 45 presses down", deep)
    XCTAssertTrue(deep.hasPrefix("quran.reader.2:"), "still in the reader")
    shot("03-reader-deep")
    expect(press(.left), "quran.browse.2", "left from deep in the reader finds the selected surah")
    expectFocusWithinPane("the selected surah is wholly in the list")
    shot("03-list-from-deep-reader")
    expect(press(.right), deep, "right returns to the viewer's place")
  }

  func test04_theLastSurahIsReached() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== The end of the list")
    expect(press(.down, 113), "quran.browse.114", "down to the last surah")
    expect(press(.down), "quran.browse.114", "and no further")
    expectFocusWithinPane("surah 114 is wholly in the list")
    press(.select)
    sleep(1)
    expect(focus, "quran.reader.114:1", "An Naas opens at its first ayah")
    expect(press(.down, 5), "quran.reader.114:6", "down to its last")
    expect(press(.down), "quran.reader.114:6", "and no further")
    shot("04-an-naas")
  }

  func test05_leavingTheQuranAndComingBack() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== To another section and back")
    press(.down, 2)
    press(.select)
    sleep(1)
    expect(focus, "quran.reader.3:1", "Al Imran is open")
    expect(press(.down, 3), "quran.reader.3:4", "down three ayahs")
    expect(press(.left), "quran.browse.3", "left to the list")
    expect(press(.left), "nav.quran", "left to the rail")
    expect(press(.up), "nav.prayer", "up to Prayer")
    press(.select)
    sleep(2)
    note("in Prayer", focus)
    var presses = 0
    while !focus.hasPrefix("nav.") && presses < 4 {
      press(.left)
      presses += 1
    }
    expect(press(.down), "nav.quran", "back on the rail, down to Qur’an")
    press(.select)
    sleep(2)
    expect(focus, "quran.browse.3", "the Qur’an opens on the surah that was being read")
    expect(press(.right), "quran.reader.3:1", "and the reader has it open")
  }

  // MARK: - A long ayah

  func test10_aLongAyahIsReadPartByPart() {
    launch([
      "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader",
      "TV_SAMPLE_SURAH": "2", "TV_SAMPLE_AYAH": "282",
    ])
    log("== The longest ayah")
    expect(focus, "quran.reader.2:282", "opens at 2:282")
    expectFocusWithinPane("part 1 is wholly in the pane")
    shot("10-2-282-part-1")
    // How many parts there are is the planner's to say, and depends on the
    // width of the pane: what is held here is that they follow in order.
    var parts = 1
    var next = press(.down)
    while next == "quran.reader.2:282.p\(parts + 1)" && parts < 12 {
      parts += 1
      log("PASS  down to part \(parts): \(next)")
      expectFocusWithinPane("part \(parts) is wholly in the pane")
      shot("10-2-282-part-\(parts)")
      next = press(.down)
    }
    note("parts of 2:282", "\(parts)")
    XCTAssertGreaterThan(parts, 2, "2:282 is in parts")
    expect(next, "quran.reader.2:283", "down from the last part to the next ayah")
    expect(press(.up), "quran.reader.2:282.p\(parts)", "up returns to the last part")
    expect(press(.left), "quran.browse.2", "left from a part returns to the list")
  }

  func test11_nothingWalkedRunsPastThePane() {
    walk(
      from: (2, 275), toTheEndOf: 286, presses: 40,
      title: "Walking the end of Al Baqarah", language: nil
    )
  }

  func test12_nothingWalkedRunsPastThePaneInUrdu() {
    walk(
      from: (2, 275), toTheEndOf: 286, presses: 50,
      title: "Walking the end of Al Baqarah in Urdu", language: ("ur", "ur_PK")
    )
  }

  func test13_nothingWalkedRunsPastThePaneInArabic() {
    walk(
      from: (4, 10), toTheEndOf: 14, presses: 12,
      title: "Walking An Nisa in Arabic", language: ("ar", "ar_SA")
    )
  }

  func test14_theReaderOpensFarIntoASurah() {
    log("== Opening far into a surah")
    // Among them ayahs read whole, and ayahs in parts that together stand
    // shorter than the pane (2:54), about as tall (2:25) and far taller.
    for (surah, ayah) in [(2, 25), (2, 54), (2, 84), (2, 100), (2, 200), (2, 275), (7, 150), (26, 200), (37, 120)] {
      launch([
        "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader",
        "TV_SAMPLE_SURAH": "\(surah)", "TV_SAMPLE_AYAH": "\(ayah)",
      ])
      expect(focus, "quran.reader.\(surah):\(ayah)", "opens at \(surah):\(ayah)")
      expectFocusWithinPane("\(surah):\(ayah) is wholly in the pane")
      expect(press(.left), "quran.browse.\(surah)", "left finds surah \(surah) in the list")
      expectFocusWithinPane("surah \(surah) is wholly in the list")
    }
  }

  // MARK: - The ways into the list

  func test15_anAyahInPartsOpensAtItsFirst() {
    log("== Opening at an ayah in parts")
    // In Arabic these are read in two parts, which together stand within a
    // few points of the pane's own height, and a little over it.
    for ayah in [85, 61] {
      launch(
        [
          "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader",
          "TV_SAMPLE_SURAH": "2", "TV_SAMPLE_AYAH": "\(ayah)",
        ],
        arguments: ["-AppleLanguages", "(ar)", "-AppleLocale", "ar_SA"]
      )
      expect(focus, "quran.reader.2:\(ayah)", "opens at 2:\(ayah), its first part")
      note("which reads", focusedElement.label)
      expectFocusWithinPane("part 1 of 2:\(ayah) is wholly in the pane")
      shot("15-2-\(ayah)-ar")
      expect(press(.down), "quran.reader.2:\(ayah).p2", "down is its second part")
      expectFocusWithinPane("part 2 of 2:\(ayah) is wholly in the pane")
    }
  }

  func test20_todaysVerseOpensAtItsAyah() {
    // On 1 April, ninety days into the year, the verse of the day is Al
    // Baqarah 2:84.
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_DATE": "2026-04-01"])
    log("== Today’s verse")
    expect(press(.up), "quran.browse.shortcut.continue", "up from the first surah")
    expect(press(.right), "quran.browse.shortcut.today", "right along the row")
    expect(focusedElement.value as? String ?? "", "Al Baqarah 2:84", "which on 1 April is 2:84")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.2:84", "Today’s verse opens at its ayah")
    expectFocusWithinPane("2:84 is wholly in the pane")
    shot("20-todays-verse")
    expect(press(.menu), "quran.browse.2", "Menu returns to its surah in the list")
    expectFocusWithinPane("surah 2 is wholly in the list")
  }

  func test21_continueReadingOpensAtThePlaceKept() {
    launch([
      "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader",
      "TV_SAMPLE_SURAH": "36", "TV_SAMPLE_AYAH": "7",
    ])
    log("== Continue reading, from another surah")
    expect(focus, "quran.reader.36:7", "the viewer is at 36:7")
    app.terminate()

    // Opened again with another surah in the reader, and the focus in the
    // list: the place is still where the viewer was.
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SURAH": "2"], keeping: true)
    expect(focus, "quran.browse.2", "opened again on Al Baqarah, in the list")
    expect(press(.up, 2), "quran.browse.shortcut.continue", "up to the row of shortcuts")
    let card = "\(focusedElement.label) \(focusedElement.value as? String ?? "")"
    note("the card", card)
    XCTAssertTrue(card.contains("36:7"), "the card names the place kept")
    press(.select)
    sleep(2)
    expect(focus, "quran.reader.36:7", "Continue reading opens the place kept")
    expectFocusWithinPane("36:7 is wholly in the pane")
    expect(press(.left), "quran.browse.36", "left returns to its surah in the list")
  }

  func test22_aGroupOpensTheListAtItsFirstSurah() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== A group of surahs")
    press(.up)
    expect(press(.right, 2), "quran.browse.collection.short_surahs", "right to the first group")
    press(.select)
    sleep(2)
    expect(focus, "quran.browse.112", "a group opens the list at its first surah")
    sleep(1)
    expect(focus, "quran.browse.112", "and stays there")
    shot("22-short-surahs")
    expect(press(.down), "quran.browse.113", "down from there")
    expect(press(.right), "quran.reader.112:1", "right into the surah the group opened")
  }

  // MARK: - The controls, and recitation

  func test30_theControlsAboveThePanes() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader"])
    log("== The controls")
    expect(focus, "quran.reader.1:1", "opens in the reader")
    expect(press(.up), "quran.playback", "up from the first ayah is play")
    expect(press(.left), "quran.playback.previous", "left is previous")
    expect(press(.left), "quran.browse.1", "left again returns to the list")
    expect(press(.right), "quran.reader.1:1", "right returns to the reader")
    press(.up)
    expect(press(.up), "quran.playback.listening", "up twice is the hero")
    expect(press(.left, 3), "quran.playback.reciter.husary", "left along the reciters")
    expect(press(.left), "nav.quran", "left from the first goes to the rail")
  }

  /// Needs the network: the recitation is streamed.
  func test31_pressingAnAyahRecitesItAndTheReaderFollows() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "112"])
    log("== Recitation")
    expect(focus, "quran.reader.112:1", "opens at 112:1")
    expect(press(.down), "quran.reader.112:2", "down to the second ayah")
    press(.select)
    sleep(1)
    expect(playControl, "Pause audio", "pressing an ayah starts the recitation")
    expect(value(of: "quran.reader.112:2"), "Playing", "and the ayah is marked as playing")
    shot("31-playing")
    var followed = focus
    for _ in 0..<40 where followed == "quran.reader.112:2" {
      sleep(1)
      followed = focus
    }
    expect(followed, "quran.reader.112:3", "the focus follows the recitation to the next ayah")
    press(.playPause)
    sleep(1)
    expect(playControl, "Play audio", "Play/Pause on the remote pauses")
    press(.playPause)
    sleep(1)
    expect(playControl, "Pause audio", "and plays again")
    press(.select)
    sleep(1)
    expect(playControl, "Play audio", "pressing the ayah being recited pauses it")
  }

  /// Needs the network: the recitation is streamed.
  func test32_aViewerReadingAheadIsLeftWhereTheyAre() {
    launch(["TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SECTION": "quran.reader", "TV_SAMPLE_SURAH": "112"])
    log("== Reading ahead of the recitation")
    expect(focus, "quran.reader.112:1", "opens at 112:1")
    press(.select)
    expect(press(.down, 3), "quran.reader.112:4", "down three ayahs while the first is recited")
    var recited = value(of: "quran.reader.112:2")
    for _ in 0..<40 where recited != "Playing" {
      sleep(1)
      recited = value(of: "quran.reader.112:2")
    }
    expect(recited, "Playing", "the recitation has moved on to the second ayah")
    expect(focus, "quran.reader.112:4", "and the focus is where the viewer put it")
  }

  // MARK: - Listening mode

  func test40_listeningModeFromTheHero() {
    launch(["TV_SAMPLE_ROUTE": "quran"])
    log("== Listening mode, opened from the hero")
    press(.up)
    expect(press(.up), "quran.playback.reciter.husary", "up from the row of shortcuts is the hero")
    expect(press(.right, 3), "quran.playback.listening", "right along the hero")
    press(.select)
    sleep(3)
    expect(focus, "listening.playPause", "listening mode opens on play and pause")
    shot("40-listening")
    expect(press(.right), "listening.next", "right to next")
    expect(press(.left, 2), "listening.previous", "left to previous")
    expect(press(.left), "listening.transliteration", "left again to the switches")
    expect(press(.up), "listening.exit", "up finds Close")
    expect(press(.down), "listening.playPause", "down returns to play and pause")
    press(.menu)
    sleep(2)
    expect(focus, "quran.playback.listening", "Menu closes it, and the focus is where it was opened from")
  }

  func test41_listeningModeMovesAyahByAyah() {
    launch([
      "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SURAH": "1", "TV_SAMPLE_AYAH": "2",
      "TV_SAMPLE_LISTENING": "1",
    ])
    log("== Listening mode, ayah by ayah")
    expect(focus, "listening.playPause", "opens on play and pause")
    // Paused first: a short ayah is soon over, and the recitation would
    // move on by itself while this looks.
    press(.select)
    sleep(1)
    expect(label(of: "listening.playPause"), "Play audio", "pressing it pauses")
    let opened = ayahInHeading
    note("the ayah in the heading", "\(opened)")
    XCTAssertGreaterThan(opened, 0, "the heading names the ayah")
    expect(press(.right), "listening.next", "right to next")
    press(.select)
    sleep(1)
    expect("\(ayahInHeading)", "\(opened + 1)", "next moves to the ayah after")
    expect(focus, "listening.next", "the focus stays on next")
    expect(press(.left, 2), "listening.previous", "left to previous")
    press(.select)
    sleep(1)
    expect("\(ayahInHeading)", "\(opened)", "previous moves back")
  }

  func test42_listeningModeSwitches() {
    launch([
      "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SURAH": "2", "TV_SAMPLE_AYAH": "255",
      "TV_SAMPLE_LISTENING": "1",
    ])
    log("== Listening mode, its switches")
    sleep(2)
    expect(focus, "listening.playPause", "opens on play and pause")
    shot("42-2-255-with-everything")
    expect(press(.left, 3), "listening.translation", "left to the translation switch")
    expect(label(of: "listening.translation"), "Translation on", "which is on")
    press(.select)
    sleep(1)
    expect(label(of: "listening.translation"), "Translation off", "pressing it turns it off")
    expect(press(.right), "listening.transliteration", "right to the transliteration switch")
    press(.select)
    sleep(1)
    expect(label(of: "listening.transliteration"), "Transliteration off", "pressing it turns it off")
    shot("42-2-255-arabic-alone")
    expect(press(.left, 2), "listening.repeat", "left to the repeat switch")
    press(.select)
    sleep(1)
    expect(label(of: "listening.repeat"), "Repeat ayah on", "pressing it turns it on")
  }

  func test43_listeningModeWithAnAyahInParts() {
    launch([
      "TV_SAMPLE_ROUTE": "quran", "TV_SAMPLE_SURAH": "2", "TV_SAMPLE_AYAH": "282",
      "TV_SAMPLE_LISTENING": "1",
    ])
    log("== Listening mode, the longest ayah")
    sleep(2)
    expect(focus, "listening.playPause", "opens on play and pause")
    expect(press(.up), "listening.part.0", "up from the controls begins the ayah")
    expectFocusWithinPane("part 1 is wholly on the stage")
    shot("43-2-282-listening")
    var parts = 1
    var next = press(.down)
    while next == "listening.part.\(parts)" && parts < 12 {
      parts += 1
      log("PASS  down to part \(parts): \(next)")
      expectFocusWithinPane("part \(parts) is wholly on the stage")
      next = press(.down)
    }
    note("parts of 2:282 on the stage", "\(parts)")
    XCTAssertGreaterThan(parts, 1, "2:282 is in parts on the stage")
    expect(next, "listening.playPause", "down from the last part to the controls")
    expect(press(.left, 4), "listening.repeat", "left along the controls")
    expect(press(.up), "listening.part.0", "up from the first control begins the ayah")
    expect(press(.up), "listening.exit", "up from the ayah to Close")
    press(.select)
    sleep(2)
    XCTAssertFalse(focus.hasPrefix("listening."), "Close closes listening mode")
  }

  // MARK: - Arabic

  func test50_inArabicTheInterfaceIsTurned() {
    launch(
      ["TV_SAMPLE_ROUTE": "quran"],
      arguments: ["-AppleLanguages", "(ar)", "-AppleLocale", "ar_SA"]
    )
    log("== Arabic")
    expect(focus, "quran.browse.1", "opens on the selected surah")
    shot("50-arabic")
    expect(press(.down), "quran.browse.2", "down in the list")
    expect(press(.left), "quran.reader.1:1", "left from the list is into the reader")
    expect(press(.down), "quran.reader.1:2", "down in the reader")
    expect(press(.right), "quran.browse.1", "right from the reader returns to the selected surah")
    expect(press(.right), "nav.quran", "right from the list goes to the rail")
    press(.left)
    sleep(1)
    expect(focus, "quran.browse.1", "left from the rail returns to the list")
    expect(press(.left), "quran.reader.1:2", "left again returns to the viewer's place in the reader")
    expect(press(.up, 2), "quran.playback", "up from the first ayah is play")
    expect(press(.right), "quran.playback.next", "right is next, as it is drawn")
    expect(press(.right), "quran.browse.1", "right again returns to the list")
  }
}
