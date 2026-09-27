# PathOfNurTV

Canonical tvOS source for Path of Nūr lives in this folder and is compiled by the existing `PathOfNurTV` target inside `ios/Runner.xcodeproj`.

## Current status

Five sections are in the rail: Home, Prayer, Qur’an, Dhikr and Settings
(`TVRoute.released`). The other six screens (Profiles, Saved, Arabic, Learn,
Games, Kids) are still compiled but cannot be reached: they run on sample
content, and each one joins the rail when its content is real.

What is real today:

- Dhikr routines, generated from the phone's catalog and guarded by
  `test/features/tvos/tvos_dhikr_routines_parity_test.dart`
- Qur’an recitation, streamed ayah by ayah
- appearance, startup and listening preferences, kept on the device

What is not yet:

- prayer times are fixed sample times in `TVSeedRepository.homePrayerSnapshot`,
  the same for every place and date. They must be replaced before anyone
  outside the team sees a build.
- the Qur’an holds five surahs, not all of their ayahs

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
