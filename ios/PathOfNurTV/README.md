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
  `test/features/tvos/tvos_dhikr_routines_parity_test.dart`
- five surahs of the Qur’an, whole, with recitation streamed ayah by ayah
- appearance, startup, listening and prayer preferences, kept on the device

What is not yet:

- the other 109 surahs. The text is one line away
  (`tvQuranSurahNumbers` in `lib/features/tvos/application/tvos_quran_export.dart`),
  but the reader is not: the surah list and the ayahs share one scrolling
  page, which holds for a short list beside a short surah and not for 114
  beside Al-Baqarah. It wants two panes that scroll apart, built with a
  remote in hand.

## Qur’an text

`Data/TVQuranData.swift` is generated. The Arabic and the translations come
from `package:quran`, the transliteration from the phone's bundled table, the
same sources the phone reads. Nothing of the Qur’an is typed into the Swift by
hand: `TVSeedRepository` looks a verse up and never writes one out.

```
REGENERATE_TV_QURAN=1 flutter test test/features/tvos/tvos_quran_parity_test.dart
```

The translation follows the Apple TV's language where the sources carry one
(English, French, Urdu) and is English otherwise. In Arabic the ayah stands
alone.

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
