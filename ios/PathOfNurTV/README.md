# PathOfNurTV

Canonical tvOS source for Path of Nūr lives in this folder and is compiled by the existing `PathOfNurTV` target inside `ios/Runner.xcodeproj`.

## Current status

Five sections are in the rail: Home, Prayer, Qur’an, Dhikr and Settings
(`TVRoute.released`). The other six screens (Profiles, Saved, Arabic, Learn,
Games, Kids) are still compiled but cannot be reached: they run on sample
content, and each one joins the rail when its content is real.

What is real today:

- prayer times, calculated on the Apple TV for its own location or a chosen
  city, under the five authorities and two Asr rules the phone offers
- Dhikr routines, generated from the phone's catalog and guarded by
  `test/features/tvos/tvos_dhikr_routines_parity_test.dart`. A routine left
  part way is taken up where it was left that day, as on the phone, and
  "Done today" is of the day
- the Qur’an, all 114 surahs, with recitation streamed ayah by ayah
- the viewer's place in the Qur’an, kept between launches, and the verse of
  the day, which is the verse the phone shows that day. An app set to open
  on the Qur’an opens in the reader at that place, as Settings says it does
- appearance, startup, listening and prayer preferences, kept on the device

What is not yet:

- Dhikr's Phrases. The three groups and their phrases are written in
  `TVSeedRepository`, not generated from the phone, and their cards do
  nothing when pressed. They want the phone's own phrases and a counter.
- anything shared with the phone. The Apple TV keeps its own place, its own
  settings and its own record of the day's routines: it reads nothing the
  phone has written. The phone itself shares prayer logs and dhikr between
  devices and not its place in the Qur’an or its prayer settings, so there is
  nothing yet for the television to read.

## Qur’an text

The Qur’an on the Apple TV is generated, never typed. The Arabic, the surah
names and the translations come from `package:quran`, the transliteration from
the phone's bundled table: the same sources the phone reads.

| File | Holds |
| --- | --- |
| `Data/TVQuranData.swift` | the 114 surahs by name, length and place |
| `Data/Quran/TVQuranArabic.json` | the Arabic |
| `Data/Quran/TVQuranTransliteration.json` | the reading |
| `Data/Quran/TVQuranTranslation_en.json`, `_fr`, `_ur` | the meaning |

```
REGENERATE_TV_QURAN=1 flutter test test/features/tvos/tvos_quran_parity_test.dart
```

The verses are resources and not Swift because 6,236 verses in five texts are
5 MB of source. Each file is a JSON array of 114 arrays written a surah to a
line, and `Data/TVQuranLibrary.swift` maps the file and parses the one line it
is asked for, so opening the app reads one surah and not the Qur’an.

Two checks hold this, and the macOS preflight runs both:

- `test/features/tvos/tvos_quran_parity_test.dart` reads the files back and
  holds every verse to the phone's sources, and the files to the target's
  Resources phase.
- `bash scripts/verify_tv_quran_library.sh` compiles the library and the
  planner below on the Mac, reads every surah through the library against a
  plain parse of the whole file, and plans every ayah in every language.

The translation follows the Apple TV's language where the sources carry one
(English, French, Urdu) and is English otherwise. In Arabic the ayah stands
alone.

The verse of the day is chosen as the phone chooses it
(`TVQuranVerseOfTheDay`, from `QuranRepository.getDailyVerse`): the days
since the year began, counted into the Qur’an from its first verse. The
phone's answer for every day of a year is written to
`tools/tv_verse_of_the_day_reference.json` by the same parity test, and the
Swift is held to it. The phone counts whole days of elapsed time, so while
summer time is kept the first hour after midnight still shows the verse of
the day before. The television does the same, since the two must agree.

## The reader

`Screens/TVQuranScreen.swift` is two panes under a compact hero: the list of
surahs and the surah being read. Each scrolls by itself and neither is taller
than the screen, so a viewer deep in one still finds the other beside them.

- Choosing a surah moves the focus into the reader at its first ayah. Menu,
  or a move toward the list, returns to the list at the surah being read.
  Moving back into the reader returns to the viewer's place in it.
- Pressing an ayah recites from there, and pressing the ayah being recited
  pauses it. The remote's Play/Pause does the same for the ayah in focus. The
  focus follows the recitation while it rests on the ayah being recited.
- The recitation stops at the end of a surah, as the phone's does. Next
  from the last ayah of a surah, and previous from the first, are the
  viewer's own and cross into the surah beside it.
- Where the focus rests in the reader, and what is recited, is the viewer's
  place (`TVQuranViewModel.keepPlace`, kept under
  `PathOfNurTV.quran.place`). The app opens there, Home's Continue reading
  and Listen go on from there, and before anything has been read Home offers
  to start reading.
- The reciter chosen beside the reader is the reciter from then on, as the
  one chosen in Settings is. A new viewer hears the phone's
  (`TVQuranReciter.phoneDefault`).
- **Nothing that takes the focus is taller than its pane.** tvOS scrolls to
  what is in focus and cannot scroll within it, so the part of a card below
  the pane would never be seen. `Support/TVQuranAyahLayout.swift` measures
  each ayah in the type and width it is set in. One that fits is one card.
  One that does not is set in parts ("Ayah 282, part 2 of 6"): the Arabic,
  divided at a pause mark where one is near, then the reading and the
  meaning. No word is dropped or moved. In English 379 of the 6,236 ayahs
  are set this way, the longest (2:282) in six parts.
- Listening mode sets the ayah as large as its stage allows (56, 46 or 38
  point Arabic) and in parts only when the smallest is still too tall.
- The panes wear `tvPane()`, the rail's feathered edge on a list that fills
  its height, and stand `TVTheme.railBleed` apart so that what fades at the
  side of one does not fade across the cards of the other.
- A row of a lazy list cannot take the focus until it is built, and a lazy
  list finds a far row by estimate. `TVFocusSeeker` brings the target into
  view and asks for the focus until it lands.
- **An ayah the reader is sent to is brought to the top of the pane, and
  carries its margin with it.** The television leaves a card it finds on
  the screen where it is, and the top of a pane's scroll view is under the
  pane's fading edge. So each ayah's row has the margin above it inside the
  row, and the rows close up by as much (`ayahLead`). Three other ways were
  tried and are not to be tried again: a row's own parts cannot be scrolled
  to by name; held by its middle, an ayah in two parts about as tall as the
  pane has its first part under the edge; and held by a point worked out to
  put the first part in the middle, a far row is missed altogether, because
  the list guesses the row's height and the point multiplies the guess.

## Prayer times

`Data/TVPrayerCalculator.swift` is a port of the `adhan` Dart package, the
library the phone calculates with, so the television and the phone in the same
room show the same minute. It is held there two ways:

- `tools/tv_prayer_reference.json` is what the Dart package answers for 4,340
  days: fourteen places from the equator to the edge of the polar day, a year
  and a leap day, every method, both Asr rules.
  `test/features/tvos/tvos_prayer_reference_test.dart` fails if the package
  stops answering that way.
- `bash scripts/verify_tv_prayer_times.sh` compiles the Swift port on its own
  and checks it against every one of those days, to the minute. The macOS
  preflight runs it.

The day is laid out as the phone lays it out (`TVPrayerSchedule`, from
`buildCalculatedPrayerScheduleForDate` and `derivePrayerScheduleContext`):
five prayers and Tahajjud after them, Isha having the first 66 parts in a
hundred of the night; on a Friday Jumu’ah in Dhuhr's place, at half past one
by the clock of the place, which is where the phone shows it until a viewer
gives it their mosque's own time. The prayer it is time for and the prayer
that is next are the phone's too: between sunrise and Dhuhr, and between
midnight and Fajr, it is no prayer's time. The phone's answers for 25 days
and 650 moments in them are in `tools/tv_prayer_schedule_reference.json`
(`test/features/tvos/tvos_prayer_schedule_reference_test.dart`), and the same
script holds the Swift to them.

The automatic look turns with the same times (`TVSkyPhase`, from
`noorSkyPhaseAt`): night from Isha to Fajr, dawn for the hour and a half
after Fajr, and Maghrib's sky from three quarters of an hour before it. Until
the television has a place it turns by the hour, as the phone does.
`tools/tv_sky_phase_reference.json` is the phone's answer for every five
minutes of a long day and a short one
(`test/features/tvos/tvos_sky_phase_reference_test.dart`).

What the phone has and the television has not: a viewer's own offsets to
each prayer, times entered by hand, and their mosque's time for Jumu’ah. A
phone set up with any of these shows other times than the television
beside it.

### The Hijri date is not shown

The phone reckons the Hijri date by arithmetic (`toHijriDate`), which is
the civil tabular calendar. `TVHijriCalendar` is a port of it, held to the
phone day by day from 2020 to 2040
(`tools/tv_hijri_reference.json`,
`test/features/tvos/tvos_hijri_reference_test.dart`), and it is what the
automatic look uses to put on Ramadan on the day the phone does.

It is not used to tell the viewer the date. Against the Umm al-Qura
calendar, over those 7,671 days, it names the same day on 4,326, is a day
behind on 2,868 and two behind on 87, and is a day ahead on 390. On 27
September 2026 it says 14 Rabi’ al-Thani where Umm al-Qura says 16. The
phone shows its date only when a viewer asks for the Islamic calendar, so
the television without one is the phone as it comes. If the phone moves to
Umm al-Qura, the television has it from the system
(`Calendar(identifier: .islamicUmmAlQura)`) and one function changes.

The Apple TV asks for its location once, on first launch
(`TVPrayerService.startIfNeeded`). If it is refused or cannot be found, Settings
offers a list of cities. Until there is a place, the app shows no times at all.

In the simulator, `SIMCTL_CHILD_TV_SAMPLE_CITY=<city id>` stands in a city
without the prompt, and `xcrun simctl privacy <udid> grant location
com.shahab.pathOfNur` with `xcrun simctl location <udid> set <lat>,<lon>`
exercises the real path.

## Shipping a build

```
bash scripts/build_apple_tv_ipa.sh
```

archives, signs at export, inspects the package and leaves it at
`build/ios/ipa/path_of_nur_tv.ipa` for Transporter. The app shares the
iPhone app's bundle id and App Store listing.

```
bash scripts/capture_tvos_store_screenshots.sh
```

takes the App Store screenshots, nine to a language, into
`build/store/tvos/`. The listing text, the notes for App Review and the
privacy answers are in `docs/tvos_store_listing.md`.

## Looking at a screen without a remote

The app takes launch overrides in the simulator only
(`SIMCTL_CHILD_<NAME>=<value> xcrun simctl launch …`), so a screen can be
opened on the state that is wanted:

| Override | Opens |
| --- | --- |
| `TV_SAMPLE_ROUTE` | a section: `home`, `prayer`, `quran`, `dhikr`, `settings` |
| `TV_SAMPLE_SECTION` | focus on a part of it, such as `settings.prayer` |
| `TV_SAMPLE_CITY` | prayer times for a city, without the location prompt; `none` for no place at all |
| `TV_SAMPLE_SURAH`, `TV_SAMPLE_AYAH` | a surah in the reader, and an ayah of it, by number |
| `TV_SAMPLE_LISTENING` | `1` for listening mode |
| `TV_SAMPLE_FOCUS` | the focus on one control of the Qur’an, by its focus id: `quran.reader.2:282.p3` |
| `TV_SAMPLE_FRESH` | `1` for the app as it is before anything has been read |
| `TV_SAMPLE_DATE` | the day, or the day and hour by the Mac's clock: `2026-10-16`, `2026-10-02T13:15` |
| `TV_SAMPLE_ROUTINE` | a routine in the player: `after-salah`, `morning`, `evening`, `sleep` |
| `TV_SAMPLE_CITY_PICKER` | `1` for the list of cities |
| `TV_SAMPLE_THEME`, `TV_SAMPLE_PHASE` | a look, and the hour it is dressed for |

## How focus travels

```
bash scripts/verify_tv_focus.sh [simulator-udid] [test ...]
```

presses the remote's buttons in the simulator (`XCUIRemote`) and reads back
where the focus is. Every control of the Qur’an carries its focus id
(`TVFocusSectionId`) as its accessibility identifier (`tvFocusID`), so a step
reads "left from the reader returns to the selected surah:
quran.browse.2". The tests are in `tooling/tv_focus_harness/UITests/`
(`QuranFocusTests` for the reader, `ShellFocusTests` for the rail and the
other four sections), a project of its own so that the app's carries no test
target. The run takes about half an hour, restarts the simulator before it
begins and leaves its log and screenshots in `build/tvos/focus/`. It is not
part of the preflight.

It also holds what is in focus to its pane: the frame of the focused card
must lie wholly inside the pane that scrolls it.

What it cannot show is the touch surface: a swipe, its momentum, a long list
under the thumb, and how quick a real Apple TV is. That wants a person with a
remote.

## Copy

The app looks strings up by their English text. Every line a viewer can reach
follows `docs/voice_and_copy_guide.md` and is translated into German, Arabic,
Urdu and French. After changing any string:

```
python3 tools/tv_strings.py --write --translations <file.json>
python3 tools/tv_strings.py --lint
```

`test/app/tv_strings_ratchet_test.dart` fails when the tables fall out of step
with the Swift, when released copy breaks the guide or lacks a translation, and
when the held-back sections drift further from the guide than they are now.

## Focus

Wrap a card in a button with `.buttonStyle(TVCardButtonStyle())`, never
`.plain`: the system's plain style lays a pale platter behind the focused
button. A card that is not a button takes `.tvFocusableCard()`. Both draw the
same ring, and rails leave `TVTheme.railBleed` at their edges so the focused
card can grow without being cut.

The rail and the section beside it are two focus sections (`TVRootView`,
`TVNavigationSidebar`). The system moves the focus from the edge of one into
the other, whichever side the rail is on, and Menu steps back from the
section to the rail. Four rules keep that working:

- **No screen sends the focus to the rail on a press.** A screen-wide
  `onMoveCommand` is called for every press, not only the one that has
  nowhere to go: "left goes to the rail" made every press to the left go
  there, from the middle of a row too, and in Arabic and Urdu it was the
  wrong way round. Where a press must do more than the system does, the
  handler goes on the one control at the edge and asks the layout direction
  (`MoveCommandDirection.towardRail(in:)`).
- **A part of a screen says where it is entered**, with
  `tvPreferredFocus`: the section at the part last used, the rail at the
  section that is open, the prayer times at the prayer in hand. Without it
  the focus lands on whatever is nearest. On a pane or a rail it is said
  of the scroll view itself, before `tvPane()` or `tvRail()`: said outside
  the feathered edge it has no effect.
- **Nothing lazy stands below the fold with something eager after it.** A
  lazy row that is wholly off the screen is not there for the focus to move
  to, so a press down goes past it. Six prayer times are a `VStack`; 114
  surahs are a `LazyVStack`, and nothing follows them.
- **A rail and its neighbour stand `TVTheme.railBleed` apart**, since the
  rail reaches that far past its own edge to fade.

Name a control with `tvFocusID` and not `.focused`: it is the same focus
id, and a test can then say where the focus is.

`.tvFocusableCard()` goes inside a button's label, or on a card that is not
a button, and never on the button itself. On the button it wraps it in a
second thing that takes the focus: the ring is drawn, and a press never
reaches the button.

## Folder structure

- `App/`: tvOS app entry and root tab shell
- `Screens/`: current tvOS screens
- `Components/`: shared focus-friendly UI building blocks
- `Models/`: lightweight view-facing models
- `ViewModels/`: screen and shell state
- `Data/`: local seeded repository content for the current shell
- `Theme/`: colors, spacing, background, and focus behavior

## Future work should continue here

Future tvOS implementation work should extend `ios/PathOfNurTV` and the existing `PathOfNurTV` target rather than reviving a parallel tvOS app path elsewhere in the repository.

For mirrored surfaces, especially Home prayer content and the Qur'an page, future changes should review the current mobile implementation in the same pass and keep tvOS aligned unless a platform-specific deviation is required.

## Asset note

`Assets.xcassets/AppIcon.brandassets` holds everything tvOS asks for:

- `App Icon.imagestack` (400x240 at 1x and 2x) for the home screen
- `App Icon - App Store.imagestack` (1280x768) for the store
- `Top Shelf Image.imageset` (1920x720) and `Top Shelf Image Wide.imageset` (2320x720), each at 1x and 2x

Each stack has three layers: the lantern and book in front, the ring of light in the middle, the night sky behind. The sky is the only opaque layer. tvOS rounds the corners and moves the layers itself, so every image is square to its edges.

Do not edit these files by hand. They are generated from the app icon source:

```
swift tooling/scripts/generate_tvos_brand_assets.swift
```

`scripts/ci_apple_bundle_consistency.sh` checks the catalog's shape, because the asset compiler does not: a catalog it cannot read is dropped without a warning and the app ships with no icon.
